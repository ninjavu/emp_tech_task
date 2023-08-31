# frozen_string_literal: true

module Internal
  class Context < OpenStruct
    attr_accessor :errors, :http_status

    def initialize(*args)
      super(*args)
      @http_status = :ok
      @errors = []
    end

    def success?
      errors.empty?
    end
  end
end
