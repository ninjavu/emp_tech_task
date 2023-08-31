# frozen_string_literal: true

class Transaction::AuthorizeInteractor
  prepend Internal::BaseInteractor

  attr_reader :ctx,
              :params

  def initialize(params:)
    @params = params
    @ctx = use_context
  end

  def _call
    create_transaction
    ctx
  end

  private

  def create_transaction
    ctx.transaction = Transaction::Authorize.create!(
      amount: ctx.params[:amount],
      customer_email: ctx.params[:customer_email],
      customer_phone: ctx.params[:customer_phone],
      merchant_id: ctx.params[:merchant_id]
    )
  end

  def use_context
    Internal::Context.new(
      params:,
      transaction: nil
    )
  end
end
