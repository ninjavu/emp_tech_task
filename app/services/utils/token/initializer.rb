# frozen_string_literal: true

class Utils::Token::Initializer
  def call(resource:, expiration: 24.hours)
    JWT.encode(
      {
        resource_id: resource.id,
        expiration: expiration.from_now.to_i,
        resource_type: resource.class.name
      },
      Rails.application.secrets.secret_key_base.to_s
    )
  end
end
