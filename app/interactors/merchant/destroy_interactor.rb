# frozen_string_literal: true

class Merchant::DestroyInteractor
  prepend Internal::BaseInteractor

  attr_reader :ctx,
              :token,
              :params

  def initialize(params:, token:)
    @token = token
    @params = params
    @ctx = use_context
  end

  def _call
    permit_params
    authenticate
    find_merchant
    check_transactions
    destroy_merchant
    ctx
  end

  private

  def permit_params
    ctx.params = params.permit(
      :id
    )
  end

  def authenticate
    raise Exceptions::Auth::Error, 'Authorization header is empty' if ctx.token.blank?

    ctx.user = TokenCheckInteractor.new(token: ctx.token).call.user
    raise Exceptions::Auth::Error, 'User Not Found' unless ctx.user
  end

  def find_merchant
    ctx.merchant = Merchant.find(ctx.params[:id])
  end

  def check_transactions
    transactions = ctx.merchant.transactions

    raise Exceptions::Merchant::DestroyError, 'Transactions exist' unless transactions.empty?
  end

  def destroy_merchant
    ctx.merchant.destroy
  end

  def use_context
    Internal::Context.new(
      token:,
      http_status: :ok,
      params: nil,
      user: nil,
      merchant: nil
    )
  end
end
