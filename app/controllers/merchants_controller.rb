# frozen_string_literal: true

class MerchantsController < ApplicationController
  def index
    ctx = Merchant::IndexInteractor.new(
      token: request.headers['Authorization'],
      params:
    ).call

    if ctx.success?
      render json: { merchants: ctx.merchants }, status: ctx.http_status
    else
      render json: {
        errors: ctx.errors
      }, status: ctx.http_status
    end
  end

  def update
    ctx = Merchant::UpdateInteractor.new(
      token: request.headers['Authorization'],
      params:
    ).call

    if ctx.success?
      render json: { merchant: ctx.merchant }, status: ctx.http_status
    else
      render json: {
        errors: ctx.errors
      }, status: ctx.http_status
    end
  end

  def destroy
    ctx = Merchant::DestroyInteractor.new(
      token: request.headers['Authorization'],
      params:
    ).call

    if ctx.success?
      head ctx.http_status
    else
      render json: {
        errors: ctx.errors
      }, status: ctx.http_status
    end
  end
end
