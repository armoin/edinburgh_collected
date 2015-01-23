RSpec.shared_examples 'state labelled content' do
  before :each do
    allow(memory).to receive(:moderation_state).and_return(moderation_state)
    allow(memory).to receive(:moderation_reason).and_return(moderation_reason)
    render
  end

  context 'when the memory is unmoderated' do
    let(:moderation_state)        { 'unmoderated' }
    let(:moderation_reason) { nil }

    it 'displays an "unmoderated" state label' do
      expect(rendered).to have_css('.state.unmoderated', text: 'unmoderated')
    end
  end

  context 'when the memory is approved' do
    let(:moderation_state)        { 'approved' }
    let(:moderation_reason) { nil }

    it 'does not display an "approved" state label' do
      expect(rendered).not_to have_css('.state.approved', text: 'approved')
    end
  end

  context 'when the memory is rejected because it is unsuitable' do
    let(:moderation_state)        { 'rejected' }
    let(:moderation_reason) { 'unsuitable' }

    it 'displays an "rejected - unsuitable" state label' do
      expect(rendered).to have_css('.state.rejected', text: 'rejected - unsuitable')
    end
  end

  context 'when the memory is rejected because it is offensive' do
    let(:moderation_state)        { 'rejected' }
    let(:moderation_reason) { 'offensive' }

    it 'displays an "rejected - offensive" state label' do
      expect(rendered).to have_css('.state.rejected', text: 'rejected - offensive')
    end
  end
end

