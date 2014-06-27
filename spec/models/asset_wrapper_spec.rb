require 'spec_helper'

describe 'AssetWrapper' do
  describe 'fetching assets' do
    it 'fetches all assets' do
      expect(AssetWrapper.fetchAll.count).to eql(5)
    end
  end
end
