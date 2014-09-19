require 'rails_helper'

describe ApplicationHelper do
  describe '#active_if_controller_path' do
    let(:path) { 'test/path' }

    before :each do
      allow(helper).to receive(:controller_path) { path }
    end

    it 'returns "active" if the controller path matches the given controller path' do
      expect(helper.active_if_controller_path(path)).to eql('active')
    end

    it 'is nil if the controller path does not match the given controller path' do
      expect(helper.active_if_controller_path('other/path')).to be_nil
    end
  end
end
