# frozen_string_literal: true

class Transaction::ParamsCreator
  attr_reader :body, :type

  def initialize(request:)
    @body = request.body.read
    @type = request.headers['Content-Type']
  end

  def call
    ActionController::Parameters.new(params)
  end

  def params
    type == 'application/xml' ? Hash.from_xml(body)['transaction'] : JSON.parse(body)
  end
end
