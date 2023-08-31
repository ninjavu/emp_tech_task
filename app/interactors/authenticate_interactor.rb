# frozen_string_literal: true

class AuthenticateInteractor
  prepend Internal::BaseInteractor

  attr_reader :resource_email,
              :resource,
              :ctx

  def initialize(
    params:,
    resource:
  )
    @resource_email = params[:email]
    @resource = resource
    @ctx = use_context
  end

  def _call
    resource.transaction do
      find_resource
      find_role
      initialize_token
    end

    ctx
  end

  private

  def find_resource
    ctx.resource = resource.find_by_email!(resource_email)
  end

  def find_role
    ctx.role = ctx.resource.userable_type.downcase
  end

  def initialize_token
    ctx.token = Utils::Token::Initializer.new.call(resource: ctx.resource.userable)
  end

  def use_context
    ::Internal::Context.new(
      resource: nil,
      token: nil,
      role: nil
    )
  end
end
