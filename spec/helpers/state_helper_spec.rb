require 'rails_helper'

describe StateHelper do
  let(:memory) { Fabricate.build(:photo_memory, id: 123) }

  describe '#button_for_state' do
    let(:action) { 'reject' }
    let(:state)  { 'rejected' }
    let(:button) { helper.button_for_state(action, state, memory, reason) }

    before :each do
      allow(memory).to receive(:current_state).and_return(current_state)
      allow(memory).to receive(:current_state_reason).and_return(reason)
    end

    context 'when button is not for current state' do
      let(:current_state) { 'approved' }

      context 'when there is no reason' do
        let(:reason) { nil }

        before :each do
          allow(memory).to receive(:current_state_reason).and_return(nil)
        end

        it 'provides a link button for the action wrapped in a list item' do
          expect(button).to have_css("li a.btn.#{action}")
        end

        it 'has a URL for the given action with no reason' do
          expect(button).to have_link('Reject', href: reject_admin_moderation_memory_path(memory))
        end
      end

      context 'when there is a reason' do
        let(:reason) { 'unsuitable' }

        before :each do
          allow(memory).to receive(:current_state_reason).and_return('unsuitable')
        end

        it 'provides a link button for the action wrapped in a list item' do
          expect(button).to have_css("li a.btn.#{action}")
        end

        it 'has a URL for the given action with the given reason' do
          expect(button).to have_link('Reject - unsuitable', href: reject_admin_moderation_memory_path(memory, reason: reason))
        end
      end
    end

    context 'when button is for current state' do
      let(:current_state) { 'rejected' }

      context 'when there is no reason' do
        let(:reason) { nil }

        it 'is nil' do
          expect(button).to be_nil
        end
      end

      context 'when there is a reason' do
        let(:reason) { 'unsuitable' }

        it 'is nil' do
          expect(button).to be_nil
        end
      end
    end
  end

  describe '#state_label' do
    context 'when there is no reason' do
      before :each do
        allow(memory).to receive(:current_state).and_return('unmoderated')
        allow(memory).to receive(:current_state_reason).and_return(nil)
      end

      it 'just provides the current state' do
        expect(helper.state_label(memory)).to eql('unmoderated')
      end
    end

    context 'when there is a reason' do
      before :each do
        allow(memory).to receive(:current_state).and_return('rejected')
        allow(memory).to receive(:current_state_reason).and_return('unsuitable')
      end

      it 'just provides the current state' do
        expect(helper.state_label(memory)).to eql('rejected - unsuitable')
      end
    end
  end

  describe '#show_state?' do
    it 'shows state if the controller path is in viewable state paths' do
      allow(helper).to receive(:controller_path).and_return(StateHelper::VIEWABLE_STATE_PATHS.first)
      expect(helper.show_state?).to be_truthy
    end

    it 'does not show state if the controller path is not in viewable state paths' do
      allow(helper).to receive(:controller_path).and_return('test/not/viewable')
      expect(helper.show_state?).to be_falsy
    end
  end
end

