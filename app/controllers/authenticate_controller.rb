# frozen_string_literal: true

class AuthenticateController < ApplicationController
  def create
    ctx = AuthenticateInteractor.new(
      params:,
      resource: ::User
    ).call

    if ctx.success?
      render json: {
        token: ctx.token,
        role: ctx.role
      }, status: ctx.http_status
    else
      render json: {
        errors: ctx.errors
      }, status: ctx.http_status
    end
  end
end
