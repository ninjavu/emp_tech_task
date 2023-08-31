# frozen_string_literal: true

class TokenCheckInteractor
  prepend Internal::BaseInteractor

  attr_reader :token,
              :ctx,
              :token_checker

  def initialize(
    token:,
    token_checker: Utils::Token::Checker
  )
    @token = token
    @ctx = use_context
    @token_checker = token_checker
  end

  def _call
    parse_token
    check_token
    identify_user
    ctx
  end

  private

  def parse_token
    payload = Utils::Token::Parser.new.call(token: ctx.token)
    ctx.expiration = payload[:expiration]
    ctx.resource_type = payload[:resource_type]
    ctx.resource_id = payload[:resource_id]
  end

  def check_token
    token_checker.new.call(expiration: ctx.expiration)
  end

  def identify_user
    ctx.user = ctx.resource_type.constantize.find(ctx.resource_id)
  end

  def use_context
    ::Internal::Context.new(
      token:,
      expiration: nil,
      resource_type: nil,
      resource_id: nil
    )
  end
end
