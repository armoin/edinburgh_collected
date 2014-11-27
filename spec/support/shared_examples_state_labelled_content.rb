RSpec.shared_examples 'state labelled content' do
  before :each do
    allow(memory).to receive(:current_state).and_return(current_state)
    allow(memory).to receive(:current_state_reason).and_return(current_state_reason)
    render
  end

  context 'when the memory is unmoderated' do
    let(:current_state)        { 'unmoderated' }
    let(:current_state_reason) { nil }

    it 'displays an "unmoderated" state label' do
      expect(rendered).to have_css('.state.unmoderated', text: 'unmoderated')
    end
  end

  context 'when the memory is approved' do
    let(:current_state)        { 'approved' }
    let(:current_state_reason) { nil }

    it 'displays an "approved" state label' do
      expect(rendered).to have_css('.state.approved', text: 'approved')
    end
  end

  context 'when the memory is rejected because it is unsuitable' do
    let(:current_state)        { 'rejected' }
    let(:current_state_reason) { 'unsuitable' }

    it 'displays an "rejected - unsuitable" state label' do
      expect(rendered).to have_css('.state.rejected', text: 'rejected - unsuitable')
    end
  end

  context 'when the memory is rejected because it is offensive' do
    let(:current_state)        { 'rejected' }
    let(:current_state_reason) { 'offensive' }

    it 'displays an "rejected - offensive" state label' do
      expect(rendered).to have_css('.state.rejected', text: 'rejected - offensive')
    end
  end
end

