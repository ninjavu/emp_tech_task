# frozen_string_literal: true

class Utils::Token::Parser
  def call(token:)
    decoded = JWT.decode(
      token,
      Rails.application.secrets.secret_key_base.to_s
    ).first

    payload = HashWithIndifferentAccess.new(decoded)

    {
      resource_id: payload.fetch(:resource_id),
      expiration: payload.fetch(:expiration),
      resource_type: payload.fetch(:resource_type)
    }
  end
end
