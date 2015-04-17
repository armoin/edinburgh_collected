RSpec.shared_examples 'a button for state helper' do
  let(:action)      { 'reject' }
  let(:state)       { 'rejected' }
  let(:moderatable) { Fabricate.build(moderatable_name, id: 213) }
  let(:button)      { helper.button_for_state(action, state, moderatable, moderatable_name, reason) }

  before :each do
    allow(moderatable).to receive(:moderation_state).and_return(moderation_state)
    allow(moderatable).to receive(:moderation_reason).and_return(reason)
  end

  context 'when button is not for current moderation state' do
    let(:moderation_state) { 'approved' }

    context 'when there is no reason' do
      let(:reason) { nil }

      before :each do
        allow(moderatable).to receive(:moderation_reason).and_return(nil)
      end

      it 'provides a link button for the action wrapped in a list item' do
        expect(button).to have_css("li a.btn.#{action}")
      end

      it 'has a URL for the given action with no reason' do
        expect(button).to have_link('Reject', href: send("reject_admin_moderation_#{moderatable_name}_path", moderatable))
      end
    end

    context 'when there is a reason' do
      let(:reason) { 'unsuitable' }

      before :each do
        allow(moderatable).to receive(:moderation_reason).and_return('unsuitable')
      end

      it 'provides a link button for the action wrapped in a list item' do
        expect(button).to have_css("li a.btn.#{action}")
      end

      it 'has a URL for the given action with the given reason' do
        expect(button).to have_link('Reject - unsuitable', href: send("reject_admin_moderation_#{moderatable_name}_path", moderatable, reason: reason))
      end
    end
  end

  context 'when button is for current moderation state' do
    let(:moderation_state) { 'rejected' }

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