# frozen_string_literal: true

class Transaction::BaseInteractor
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
    check_params
    authenticate
    check_if_merchant_active
    process_transaction_by_type
    ctx
  end

  private

  def permit_params
    # Можно обмернуть в форм объект
    ctx.params = params.permit(
      :merchant_id,
      :type,
      :amount,
      :customer_email,
      :customer_phone,
      :transaction_reference
    )

    # params = params.permit(
    #   :merchant_id,
    #   :type,
    #   :amount,
    #   :customer_email,
    #   :customer_phone,
    #   :transaction_reference
    # )

    # contract_ctx = TransactionContract.new.call(
    #   params
    # ).call

    # if contract_ctx.success?
    #   ctx.params = params
    # else
    #   raise Exceptions::Interactor::ContractError, contract_ctx
    # end
  end

  def check_params
    raise ActiveRecord::RecordNotFound, 'Please, write :type parameter' unless ctx.params[:type]

    return if ctx.params[:type].in?(Transaction::TRANSACTION_TYPES)

    raise ActiveRecord::RecordNotFound,
          'unknown transaction type'
  end

  def authenticate
    raise Exceptions::Auth::Error, 'Authorization header is empty' if ctx.token.blank?

    ctx.merchant = TokenCheckInteractor.new(token: ctx.token).call.user
    raise Exceptions::Auth::Error, 'Merchant Not Found' unless ctx.merchant
  end

  def check_if_merchant_active
    raise ActiveRecord::RecordNotFound, 'Merchant is inactive' unless ctx.merchant.active?
  end

  def process_transaction_by_type
    transaction_type = ctx.params[:type]

    transaction_ctx = Transaction.build_transaction_type_interactor_name(transaction_type:)&.new(
      params: ctx.params
    )&.call

    if transaction_ctx&.success?
      @ctx.transaction_ctx = transaction_ctx
    else
      @ctx = transaction_ctx
      # Можно дописать кастомную ошибку Interactor::StopOperation
      # и от нее райзит уже с дочерним контекстом
    end
  end

  def use_context
    Internal::Context.new(
      token:,
      params: nil,
      merchant: nil,
      transaction_ctx: nil,
      http_status: :created
    )
  end
end
