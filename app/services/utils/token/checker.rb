# frozen_string_literal: true

class Utils::Token::Checker
  def call(expiration:)
    return unless Time.at(expiration).utc < Time.now.utc

    raise ::JWT::DecodeError, 'Token has expired'
  end
end
