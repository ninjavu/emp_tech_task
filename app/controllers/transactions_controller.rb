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
      params: Transaction::ParamsCreator.new(request:).call
    ).call

    respond_to do |format|
      data = ctx.success? ? { transaction_id: ctx.transaction.id } : { errors: ctx.errors }

      format.json { render json: data, status: ctx.http_status }
      format.xml { render xml: data.to_xml(root: :transaction), status: ctx.http_status }
    end
  end
end
