# frozen_string_literal: true

module Internal
  module BaseInteractor
    EXCEPTIONS = [
      Exceptions::Interactor::ContractError,
      ::ActiveRecord::ActiveRecordError,
      ::ActiveRecord::RecordInvalid,
      ::JWT::DecodeError,
      AASM::InvalidTransition,
      StandardError
    ].freeze

    def call
      _call
    rescue *EXCEPTIONS => e
      set_errors(e)
      set_http_status(e)
      ctx.success = false
      ctx
    end

    private

    def set_errors(err)
      if err.instance_of?(::ActiveRecord::RecordInvalid)
        error = err.record
                   .errors
                   .group_by_attribute
                   .transform_values { |errors| errors.map(&:full_message) }
        ctx.errors = { validation: error }
      else
        ctx.errors = { server: err.message }
      end
    end

    def set_http_status(error)
      ctx.http_status = :unprocessable_entity
      ctx.http_status = :unauthorized if [Exceptions::Auth::Error, ::JWT::DecodeError].include?(error.class)
    end
  end
end
