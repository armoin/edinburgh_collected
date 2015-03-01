require 'rails_helper'

def user_allowed_params
  Fabricate.attributes_for(:user).merge({
    image_data: {
      rotation: 90,
      scale: 0.89,
      x: 50,
      y: 90
    }
  })
end

describe UserParamCleaner do
  subject { UserParamCleaner.clean(params) }

  context 'when params are allowed' do
    let(:params) { ActionController::Parameters.new({
      user: user_allowed_params
    })}

    it "keeps allowed params" do
      expect(subject.length).to eql(user_allowed_params.length)
    end

    user_allowed_params.each do |key,value|
      it "allows #{key}" do
        expect(subject).to have_key(key)
      end
    end
  end

  context 'when params are not allowed' do
    let(:params) { ActionController::Parameters.new({
      user: {
        not_allowed: 'This should not be allowed'
      }
    })}

    it "is empty" do
      result = UserParamCleaner.clean(params)
      expect(subject).to be_empty
    end
  end
end
