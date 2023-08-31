# frozen_string_literal: true

module Activable
  extend ActiveSupport::Concern

  included do
    STATUSES = %w[active inactive].freeze # rubocop:disable Lint/ConstantDefinitionInBlock
    enum status: STATUSES
    validates :status, inclusion: { in: STATUSES }
    validates :status, presence: true
  end
end
