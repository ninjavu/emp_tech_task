# frozen_string_literal: true

require 'rails_helper'

class Dummy
  prepend Internal::BaseInteractor

  attr_reader :params, :ctx

  def initialize(params:)
    @params = params
    @ctx = use_context
  end

  def _call
    check_params
    ctx
  end

  def check_params
    raise StandardError, 'Some error' unless ctx.params[:token]
  end

  def use_context
    Internal::Context.new(
      params:
    )
  end
end

RSpec.describe Internal::BaseInteractor, type: :module do
  context 'when valid params' do
    let(:params) { { token: '123123123' } }

    it 'it should create ctx for dummy instance by module call method' do
      dummy = Dummy.new(params:)
      dummy.call
      expect(dummy.ctx).to be_present
    end
  end

  context 'when invalid params' do
    let(:params) { {} }

    it 'it should writes error for instance ctx by module call method' do
      dummy = Dummy.new(params:).call

      expect(dummy.errors[:server]).to eq('Some error')
    end

    it 'it should set http status by module call method' do
      dummy = Dummy.new(params:).call

      expect(dummy.http_status).to eq(:unprocessable_entity)
    end
  end
end
