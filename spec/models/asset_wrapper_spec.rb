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
      let(:mock_conn)     { double('conn', get: mock_response) }

      it 'fetches all assets' do
        AssetWrapper.fetchAll
        expect(mock_conn).to have_received(:get).with('/assets')
      end
    end

    describe 'fetching a single asset' do
      let(:mock_response) { double('response', body: asset_attrs.to_json, status: status) }
      let(:mock_conn)     { double('conn', get: mock_response) }
      let(:status)        { 200 }

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
      let(:mock_conn)     { double('conn', post: mock_response) }

      it 'creates a new asset' do
        AssetWrapper.create(asset)
        expect(mock_conn).to have_received(:post).with('/assets', asset: asset.instance_values)
      end

      it 'returns the id' do
        expect(AssetWrapper.create(asset)).to eql(id)
      end
    end

    describe 'updating an asset' do
      let(:mock_response) { double('response', body: asset.to_json) }
      let(:mock_conn)     { double('conn', put: mock_response) }

      it 'updates the asset' do
        AssetWrapper.update(asset)
        expect(mock_conn).to have_received(:put).with("/assets/#{asset.id}", asset: asset.instance_values)
      end
    end
  end
end

