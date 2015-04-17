RSpec.shared_examples 'a page with a state bar' do
  context 'when the current state is "unmoderated"' do
    let(:state) { 'unmoderated' }

    it 'displays the current state' do
      expect(rendered).to have_css('.state', text: 'unmoderated')
    end

    it 'does not display the reason' do
      expect(rendered).not_to have_css('.comment')
    end
  end

  context 'when the current state is "approved"' do
    let(:state) { 'approved'}

    it 'displays the current state' do
      expect(rendered).to have_css('.state', text: 'approved')
    end

    it 'does not display the reason' do
      expect(rendered).not_to have_css('.comment')
    end
  end

  context 'when the current state is "rejected"' do
    let(:state) { 'rejected' }

    context 'and the reason is "unsuitable"' do
      let(:reason) { 'unsuitable' }

      it 'displays the current state' do
        expect(rendered).to have_css('.state', text: 'rejected')
      end

      it 'displays the reason' do
        expect(rendered).to have_css('.comment', text: 'unsuitable')
      end
    end

    context 'and the reason is "offensive"' do
      let(:reason) { 'offensive' }

      it 'displays the current state' do
        expect(rendered).to have_css('.state', text: 'rejected')
      end

      it 'displays the reason' do
        expect(rendered).to have_css('.comment', text: 'offensive')
      end
    end
  end

  context 'when the current state is "reported"' do
    let(:state)  { 'reported'}
    let(:reason) { 'I do not think that this is a appropriate.' }

    it 'displays the current state' do
      expect(rendered).to have_css('.state', text: 'reported')
    end

    it 'displays the reason' do
      expect(rendered).to have_css('.comment', text: 'I do not think that this is a appropriate.')
    end
  end

  context 'when the current state is "blocked"' do
    let(:state) { 'blocked'}

    it 'displays the current state' do
      expect(rendered).to have_css('.state', text: 'blocked')
    end

    it 'does not display the reason' do
      expect(rendered).not_to have_css('.comment')
    end
  end
end