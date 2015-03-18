RSpec.shared_examples 'state labelled content' do
  before :each do
    allow(current_user).to receive(:can_modify?).and_return(can_modify)
    allow(moderatable).to receive(:moderation_state).and_return(moderation_state)
    allow(moderatable).to receive(:moderation_reason).and_return(moderation_reason)
    render
  end

  context 'when the current user can modify the moderatable item' do
    let(:can_modify) { true }

    context 'when the moderatable is unmoderated' do
      let(:moderation_state)  { 'unmoderated' }
      let(:moderation_reason) { nil }

      it 'displays an "unmoderated" state label' do
        expect(rendered).to have_css('.state.unmoderated', text: 'unmoderated')
      end
    end

    context 'when the moderatable is approved' do
      let(:moderation_state)  { 'approved' }
      let(:moderation_reason) { nil }

      it 'does not display an "approved" state label' do
        expect(rendered).not_to have_css('.state.approved', text: 'approved')
      end
    end

    context 'when the moderatable is rejected because it is unsuitable' do
      let(:moderation_state)  { 'rejected' }
      let(:moderation_reason) { 'unsuitable' }

      it 'displays an "rejected - unsuitable" state label' do
        expect(rendered).to have_css('.state.rejected', text: 'rejected - unsuitable')
      end
    end

    context 'when the moderatable is rejected because it is offensive' do
      let(:moderation_state)  { 'rejected' }
      let(:moderation_reason) { 'offensive' }

      it 'displays an "rejected - offensive" state label' do
        expect(rendered).to have_css('.state.rejected', text: 'rejected - offensive')
      end
    end
  end

  context 'when the current user cannot modify the moderatable item' do
    let(:can_modify) { false }

    context 'when the moderatable is unmoderated' do
      let(:moderation_state)  { 'unmoderated' }
      let(:moderation_reason) { nil }

      it 'does not display an "unmoderated" state label' do
        expect(rendered).not_to have_css('.state.unmoderated', text: 'unmoderated')
      end
    end

    context 'when the moderatable is approved' do
      let(:moderation_state)  { 'approved' }
      let(:moderation_reason) { nil }

      it 'does not display an "approved" state label' do
        expect(rendered).not_to have_css('.state.approved', text: 'approved')
      end
    end

    context 'when the moderatable is rejected because it is unsuitable' do
      let(:moderation_state)  { 'rejected' }
      let(:moderation_reason) { 'unsuitable' }

      it 'does not display an "rejected - unsuitable" state label' do
        expect(rendered).not_to have_css('.state.rejected', text: 'rejected - unsuitable')
      end
    end

    context 'when the moderatable is rejected because it is offensive' do
      let(:moderation_state)  { 'rejected' }
      let(:moderation_reason) { 'offensive' }

      it 'does not display an "rejected - offensive" state label' do
        expect(rendered).not_to have_css('.state.rejected', text: 'rejected - offensive')
      end
    end
  end
end

RSpec.shared_examples 'non state labelled content' do
  before :each do
    allow(moderatable).to receive(:moderation_state).and_return(moderation_state)
    allow(moderatable).to receive(:moderation_reason).and_return(moderation_reason)
    render
  end

  context 'when the moderatable is unmoderated' do
    let(:moderation_state)  { 'unmoderated' }
    let(:moderation_reason) { nil }

    it 'does not display an "unmoderated" state label' do
      expect(rendered).not_to have_css('.state.unmoderated', text: 'unmoderated')
    end
  end

  context 'when the moderatable is approved' do
    let(:moderation_state)  { 'approved' }
    let(:moderation_reason) { nil }

    it 'does not display an "approved" state label' do
      expect(rendered).not_to have_css('.state.approved', text: 'approved')
    end
  end

  context 'when the moderatable is rejected because it is unsuitable' do
    let(:moderation_state)  { 'rejected' }
    let(:moderation_reason) { 'unsuitable' }

    it 'does not display an "rejected - unsuitable" state label' do
      expect(rendered).not_to have_css('.state.rejected', text: 'rejected - unsuitable')
    end
  end

  context 'when the moderatable is rejected because it is offensive' do
    let(:moderation_state)  { 'rejected' }
    let(:moderation_reason) { 'offensive' }

    it 'does not display an "rejected - offensive" state label' do
      expect(rendered).not_to have_css('.state.rejected', text: 'rejected - offensive')
    end
  end
end
