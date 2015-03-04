require 'rails_helper'

def user_allowed_params
  {
    first_name:            'Bobby',
    last_name:             'Tables',
    screen_name:           'BobbyT',
    is_group:              false,
    email:                 'bobby@example.com',
    password:              'password',
    password_confirmation: 'password',
    accepted_t_and_c:      true,
    description:           'Test description.',
    links_attributes: {
      0 => {
        name: 'Test',
        url:  'http://www.example.com'
      }
    }
  }
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
