require 'rails_helper'

describe UserWrapper do
  describe 'creating a user' do
    let(:user_attrs) {{
      first_name: 'Bobby',
      last_name: 'Tables',
      email: 'bobby@example.com',
      username: 'bobbyt',
      password: 'password',
      password_confirmation: 'password'
    }}

    before :each do
      allow(Faraday).to receive(:new).and_return(mock_conn)
    end

    let(:mock_response) { double('response', status: 200) }
    let(:mock_conn)     { double('conn', post: mock_response) }

    it 'creates a new user' do
      UserWrapper.create(user_attrs)
      expect(mock_conn).to have_received(:post).with('/signup', user: user_attrs)
    end

    context 'when successful' do
      let(:mock_response) { double('response', status: 200) }

      it 'returns true' do
        expect(UserWrapper.create(user_attrs)).to be_truthy
      end
    end

    context 'when unsuccessful' do
      let(:mock_response) { double('response', status: 400) }

      it 'returns false' do
        expect(UserWrapper.create(user_attrs)).to be_falsy
      end
    end
  end
end
