# frozen_string_literal: true

class Transaction < ApplicationRecord
  include AASM

  STATUSES = %w[approved reversed refunded error].freeze
  REF_STATUSES = %w[approved refunded].freeze
  TRANSACTION_TYPES = %w[authorize charge refund reversal].freeze
  EXPIRATION = 1.hour.ago

  enum status: STATUSES

  validates :customer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :status, inclusion: { in: STATUSES }

  belongs_to :merchant

  scope :expired, -> { where('created_at < ?', EXPIRATION) }

  aasm column: :status, enum: true do
    state :approved, initial: true
    state :reversed, :refunded, :error

    after_all_transitions :log_status_change

    event :to_refunded do
      transitions from: :approved, to: :refunded
    end

    event :to_reversed do
      transitions from: :approved, to: :reversed
    end

    event :to_error do
      transitions from: %i[approved refunded reversed], to: :error
    end
  end

  def self.build_transaction_type_interactor_name(transaction_type:)
    "Transaction::#{transaction_type.capitalize}Interactor".constantize
  rescue StandardError
    nil
  end

  def able_to_reference?
    status.in?(REF_STATUSES)
  end

  private

  def log_status_change
    Rails.logger.info "Transaction:#{id} changing from #{aasm.from_state} to #{aasm.to_state})"
  end
end
