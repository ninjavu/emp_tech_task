# frozen_string_literal: true

class TransactionsController < ApplicationController
  def index
    # [TODO] move to interactor + pagination
    render json: {
      transactions: Transaction.all
    }, status: :ok
  end

  def create
    ctx = Transaction::BaseInteractor.new(
      token: request.headers['Authorization'],
      params:
    ).call

    if ctx.success?
      render json: { transaction: ctx.transaction_ctx.transaction }, status: ctx.http_status
    else
      render json: {
        errors: ctx.errors
      }, status: ctx.http_status
    end
  end
end
