require 'rails_helper'

describe ApplicationHelper do
  describe '#active_if_controller_path' do
    context "when a single path is given" do
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

    context "when an array of paths is given" do
      let(:controller_path) { 'test/path/1' }

      before :each do
        allow(helper).to receive(:controller_path) { controller_path }
      end

      it 'returns "active" if the given paths include the controller path' do
        expect(helper.active_if_controller_path('test/path/1', 'test/path/2')).to eql('active')
      end

      it 'is nil if the given paths do not contain the controller path' do
        expect(helper.active_if_controller_path('other/path/1', 'other/path/2')).to be_nil
      end
    end
  end
end
