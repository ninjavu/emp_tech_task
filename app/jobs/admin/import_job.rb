# frozen_string_literal: true

class Admin::ImportJob
  include Sidekiq::Job
  sidekiq_options retry: false

  def perform
    ::Admin::Import.new.call
  end
end
