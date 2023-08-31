# frozen_string_literal: true

class Transaction::ReversalInteractor
  prepend Internal::BaseInteractor

  attr_reader :ctx,
              :params,
              :merchant

  def initialize(params:)
    @params = params
    @ctx = use_context
  end

  def _call
    ActiveRecord::Base.transaction do
      find_ref_transaction
      check_amounts
      check_if_transaction_exists
      define_status
      create_transaction
      reverse_ref_transaction
    end

    ctx
  end

  private

  def find_ref_transaction
    ctx.ref_transaction = Transaction::Authorize.find(ctx.params[:transaction_reference])

    raise ActiveRecord::RecordNotFound, 'unknown transaction type' unless ctx.ref_transaction
  end

  def check_amounts
    unless ctx.ref_transaction.amount == ctx.params[:amount]
      raise ActiveRecord::RecordNotFound, 'amount differs from authorize transaction'
    end
  end

  def check_if_transaction_exists
    if ctx.ref_transaction.reversal_transaction
      raise ActiveRecord::RecordNotFound, 'reversal transaction for this authorize transaction already exists'
    end
  end


  def define_status
    ctx.status = ctx.ref_transaction.able_to_reference? ? :approved : :error
  end

  def create_transaction
    ctx.transaction = Transaction::Reversal.create!(
      customer_email: ctx.params[:customer_email],
      customer_phone: ctx.params[:customer_phone],
      merchant_id: ctx.params[:merchant_id],
      transaction_reference: ctx.params[:transaction_reference],
      status: ctx.status
    )
  end

  def reverse_ref_transaction
    ctx.ref_transaction.to_reversed! if ctx.ref_transaction.approved?
  end

  def use_context
    Internal::Context.new(
      params:,
      status: nil,
      transaction: nil,
      ref_transaction: nil
    )
  end
end
