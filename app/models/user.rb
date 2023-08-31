# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, presence: true

  belongs_to :userable, polymorphic: true
end
