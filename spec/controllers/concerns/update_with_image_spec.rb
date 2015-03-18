require 'rails_helper'

class FakeController < ApplicationController
  include UpdateWithImage
end

describe FakeController do
  let(:model)          { double('model') }
  let(:model_params)   { double('model_parms') }
  let(:updater_double) { double('updater') }
  let(:result)         { true }

  before :each do
    allow(ModelWithImageUpdater).to receive(:new).and_return(updater_double)
    allow(updater_double).to receive(:process).and_return(result)
  end

  it "process the model with the given params" do
    subject.update_and_process_image(model, model_params)
    expect(ModelWithImageUpdater).to have_received(:new).with(model, model_params)
  end

  context 'when update and process is successful' do
    let(:result) { true }

    it 'returns true' do
      expect(subject.update_and_process_image(model, model_params)).to be_truthy
    end
  end

  context 'when update and process is not successful' do
    let(:result) { false }

    it 'returns false' do
      expect(subject.update_and_process_image(model, model_params)).to be_falsy
    end
  end
end