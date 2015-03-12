require 'rails_helper'

describe StateHelper do
  let(:memory) { Fabricate.build(:photo_memory, id: 123) }

  describe '#button_for_state' do
    describe 'for memories' do
      let(:moderatable_name) { :memory }

      it_behaves_like 'a button for state helper'
    end

    describe 'for scrapbooks' do
      let(:moderatable_name) { :scrapbook }

      it_behaves_like 'a button for state helper'
    end
  end

  describe '#state_label' do
    context 'when there is no reason' do
      before :each do
        allow(memory).to receive(:moderation_state).and_return('unmoderated')
        allow(memory).to receive(:moderation_reason).and_return(nil)
      end

      it 'just provides the moderation state' do
        expect(helper.state_label(memory)).to eql('unmoderated')
      end
    end

    context 'when there is a blank reason' do
      before :each do
        allow(memory).to receive(:moderation_state).and_return('approved')
        allow(memory).to receive(:moderation_reason).and_return('')
      end

      it 'just provides the moderation state' do
        expect(helper.state_label(memory)).to eql('approved')
      end
    end

    context 'when there is a reason' do
      before :each do
        allow(memory).to receive(:moderation_state).and_return('rejected')
        allow(memory).to receive(:moderation_reason).and_return('unsuitable')
      end

      it 'just provides the moderation state' do
        expect(helper.state_label(memory)).to eql('rejected - unsuitable')
      end
    end
  end

  describe '#show_state?' do
    it "shows state on the show page of memories that belong to the user" do
      allow(helper).to receive(:controller_path).and_return('my/memories')
      expect(helper.show_state?).to be_truthy
    end

    it "shows state on the show page of scrapbooks that belong to the user" do
      allow(helper).to receive(:controller_path).and_return('my/scrapbooks')
      expect(helper.show_state?).to be_truthy
    end

    it 'does not show state if the controller path is not in viewable state paths' do
      allow(helper).to receive(:controller_path).and_return('test/not/viewable')
      expect(helper.show_state?).to be_falsy
    end
  end
end

