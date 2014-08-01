require 'rails_helper'

describe SessionWrapper do
  describe 'creating a session' do
    let(:session_attrs) {{
      username: 'bobbyt',
      password: 's3cr3t'
    }}

    before :each do
      allow(Faraday).to receive(:new).and_return(mock_conn)
    end

    let(:mock_response) { double('response', status: 200, body: {token: 't0k3n'}.to_json) }
    let(:mock_conn)     { double('conn', post: mock_response) }

    it 'creates a new session' do
      SessionWrapper.create(session_attrs)
      expect(mock_conn).to have_received(:post).with('/login', session_attrs)
    end

    context 'when successful' do
      let(:mock_response) { double('response', status: 200, body: {token: 't0k3n'}.to_json) }

      it 'returns the token' do
        expect(SessionWrapper.create(session_attrs)).to eql('t0k3n')
      end
    end

    context 'when unsuccessful' do
      let(:mock_response) { double('response', status: 403) }

      it 'returns nil' do
        expect(SessionWrapper.create(session_attrs)).to be_nil
      end
    end
  end

  describe 'deleting a session' do
    let(:token) { 't0k3n' }

    before :each do
      allow(Faraday).to receive(:new).and_return(mock_conn)
    end

    let(:mock_response) { double('response', status: 200) }
    let(:mock_conn)     { double('conn', post: mock_response, token_auth: "") }

    it 'appends the token to the header' do
      SessionWrapper.delete(token)
      expect(mock_conn).to have_received(:token_auth).with(token)
    end

    it 'deletes the session' do
      SessionWrapper.delete(token)
      expect(mock_conn).to have_received(:post).with('/logout')
    end

    context 'when successful' do
      let(:mock_response) { double('response', status: 200) }

      it 'returns true' do
        expect(SessionWrapper.delete(token)).to be_truthy
      end
    end

    context 'when unsuccessful' do
      let(:mock_response) { double('response', status: 403) }

      it 'returns false' do
        expect(SessionWrapper.delete(token)).to be_falsy
      end
    end
  end
end
