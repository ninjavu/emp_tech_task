# frozen_string_literal: true

class Transaction::DestroyExpiredJob
  include Sidekiq::Job

  sidekiq_options retry: false

  def perform
    Transaction.expired.destroy_all
  end
end
