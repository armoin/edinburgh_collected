require 'rails_helper'

describe AssetWrapper do
  let(:assets)      { AssetFactory.assets_data }
  let(:asset_attrs) { AssetFactory.asset_data }
  let(:asset)       { Asset.new(AssetFactory.new_asset_data) }
  let(:id)          { asset_attrs['id'] }

  describe 'talking to the API' do
    before :each do
      allow(Faraday).to receive(:new).and_return(mock_conn)
    end

    describe 'fetching assets' do
      let(:mock_response) { double('response', body: assets.to_json) }
      let(:mock_conn)     { double('conn', get: mock_response, token_auth: true) }

      it 'does not add token authentication to the request' do
        AssetWrapper.fetchAll
        expect(mock_conn).not_to have_received(:token_auth)
      end

      it 'fetches all assets' do
        AssetWrapper.fetchAll
        expect(mock_conn).to have_received(:get).with('/assets')
      end
    end

    describe "fetching a user's assets" do
      let(:mock_response) { double('response', body: asset_attrs.to_json, status: status) }
      let(:mock_conn)     { double('conn', get: mock_response, token_auth: true) }
      let(:status)        { 200 }

      it 'adds token authentication to the request' do
        AssetWrapper.fetchUser(auth_token)
        expect(mock_conn).to have_received(:token_auth).with(auth_token)
      end

      it "fetches the user's assets" do
        AssetWrapper.fetchUser(auth_token)
        expect(mock_conn).to have_received(:get).with("/assets/user")
      end

      context 'when status == 200' do
        it "provides the data for the user's assets" do
          expect(AssetWrapper.fetchUser(auth_token)).to eql(asset_attrs)
        end
      end

      context 'when status == 400' do
        let(:status) { 400 }

        it 'raises an Invalid authentication token error' do
          expect {AssetWrapper.fetchUser(auth_token)}.to raise_error('Invalid authentication token')
        end
      end

      context 'when status == 403' do
        let(:status) { 403 }

        it 'raises a Forbidden error' do
          expect {AssetWrapper.fetchUser(auth_token)}.to raise_error('Forbidden')
        end
      end
    end

    describe 'fetching a single asset' do
      let(:mock_response) { double('response', body: asset_attrs.to_json, status: status) }
      let(:mock_conn)     { double('conn', get: mock_response, token_auth: true) }
      let(:status)        { 200 }

      it 'does not add token authentication to the request' do
        AssetWrapper.fetch(id)
        expect(mock_conn).not_to have_received(:token_auth)
      end

      it 'fetches the requested asset' do
        AssetWrapper.fetch(id)
        expect(mock_conn).to have_received(:get).with("/assets/#{id}")
      end

      context 'when status == 200' do
        it 'provides the data for the request asset' do
          expect(AssetWrapper.fetch(id)['id']).to eql(id)
        end
      end

      context 'when status == 404' do
        let(:status) { 404 }

        it 'raises a Not Found error' do
          expect {AssetWrapper.fetch(id)}.to raise_error('Asset not found')
        end
      end
    end

    describe 'creating an asset' do
      let(:mock_response) { double('response', body: asset_attrs.to_json) }
      let(:mock_conn)     { double('conn', post: mock_response, token_auth: true) }

      it 'adds token authentication to the request' do
        AssetWrapper.create(asset, auth_token)
        expect(mock_conn).to have_received(:token_auth).with(auth_token)
      end

      it 'creates a new asset' do
        AssetWrapper.create(asset, auth_token)
        expect(mock_conn).to have_received(:post).with('/assets', asset: asset.instance_values)
      end

      it 'returns the id' do
        expect(AssetWrapper.create(asset, auth_token)).to eql(id)
      end
    end
  end
end

