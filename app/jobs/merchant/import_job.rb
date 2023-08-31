# frozen_string_literal: true

class Merchant::ImportJob
  include Sidekiq::Job
  sidekiq_options retry: false

  def perform
    ::Merchant::Import.new.call
  end
end
