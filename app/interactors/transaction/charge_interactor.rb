# frozen_string_literal: true

class Transaction::ChargeInteractor
  prepend Internal::BaseInteractor

  attr_reader :ctx,
              :params

  def initialize(params:)
    @params = params
    @ctx = use_context
  end

  def _call
    find_ref_transaction
    check_amounts
    check_if_transaction_exists
    define_status
    create_transaction
    ctx

    # find_ref_transaction
    # if ctx.ref_transaction
    #   define_status
    #   check_if_amount_the_same
    # end
    # create_transaction
    # ctx
  end

  private

  def find_ref_transaction
    ctx.ref_transaction = Transaction::Authorize.find(ctx.params[:transaction_reference])
    raise ActiveRecord::RecordNotFound, 'no matched authorize transaction' unless ctx.ref_transaction
  end

  def check_amounts
    return if ctx.ref_transaction.amount == ctx.params[:amount]

    raise ActiveRecord::RecordNotFound, 'amount differs from authorize transaction'
  end

  def check_if_transaction_exists
    return unless ctx.ref_transaction.charge_transaction

    raise ActiveRecord::RecordNotFound, 'charge transaction for this authorize transaction already exists'
  end

  def define_status
    ctx.status = ctx.ref_transaction.able_to_reference? ? :approved : :error
  end

  def create_transaction
    ctx.transaction = Transaction::Charge.create!(
      amount: ctx.params[:amount],
      customer_email: ctx.params[:customer_email],
      customer_phone: ctx.params[:customer_phone],
      merchant_id: ctx.params[:merchant_id],
      transaction_reference: ctx.params[:transaction_reference],
      status: ctx.status
    )
  end

  def use_context
    Internal::Context.new(
      params:,
      ref_transaction: nil,
      status: nil,
      transaction: nil
    )
  end
end
