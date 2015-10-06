RSpec.shared_examples 'a moderated show page' do
  it_behaves_like 'a page with a state bar'

  context 'when the current state is "unmoderated"' do
    let(:state) { 'unmoderated'}

    it 'does not have an "unmoderate" button' do
      expect(rendered).not_to have_link('Unmoderate')
    end

    it 'has an "approve" button' do
      expect(rendered).to have_link('Approve', href: send("approve_admin_moderation_#{path_segment}_path", moderatable.to_param, reason: nil))
    end

    it 'has a "reject - unsuitable"  button' do
      expect(rendered).to have_link('Reject - unsuitable', href: send("reject_admin_moderation_#{path_segment}_path", moderatable.to_param, reason: 'unsuitable'))
    end

    it 'has a "reject - offensive"  button' do
      expect(rendered).to have_link('Reject - offensive', href: send("reject_admin_moderation_#{path_segment}_path", moderatable.to_param, reason: 'offensive'))
    end
  end

  context 'when the current state is "approved"' do
    let(:state) { 'approved'}

    it 'has an "unmoderate" button' do
      expect(rendered).to have_link('Unmoderate', href: send("unmoderate_admin_moderation_#{path_segment}_path", moderatable.to_param))
    end

    it 'does not have an "approve" button' do
      expect(rendered).not_to have_link('Approve')
    end

    it 'has a "reject - unsuitable"  button' do
      expect(rendered).to have_link('Reject - unsuitable', href: send("reject_admin_moderation_#{path_segment}_path", moderatable.to_param, reason: 'unsuitable'))
    end

    it 'has a "reject - offensive"  button' do
      expect(rendered).to have_link('Reject - offensive', href: send("reject_admin_moderation_#{path_segment}_path", moderatable.to_param, reason: 'offensive'))
    end
  end

  context 'when the current state is "rejected"' do
    let(:state) { 'rejected' }

    context 'and the reason is "unsuitable"' do
      let(:reason) { 'unsuitable' }

      it 'has an "unmoderate" button' do
        expect(rendered).to have_link('Unmoderate', href: send("unmoderate_admin_moderation_#{path_segment}_path", moderatable.to_param))
      end

      it 'has an "approve" button' do
        expect(rendered).to have_link('Approve', href: send("approve_admin_moderation_#{path_segment}_path", moderatable.to_param))
      end

      it 'does not have a "reject - unsuitable"  button' do
        expect(rendered).not_to have_link('Reject - unsuitable')
      end

      it 'has a "reject - offensive"  button' do
        expect(rendered).to have_link('Reject - offensive', href: send("reject_admin_moderation_#{path_segment}_path", moderatable.to_param, reason: 'offensive'))
      end
    end

    context 'and the reason is "offensive"' do
      let(:reason) { 'offensive' }

      it 'has an "Unmoderate" button' do
        expect(rendered).to have_link('Unmoderate', href: send("unmoderate_admin_moderation_#{path_segment}_path", moderatable.to_param))
      end

      it 'has an "Approve" button' do
        expect(rendered).to have_link('Approve', href: send("approve_admin_moderation_#{path_segment}_path", moderatable.to_param))
      end

      it 'has a "Reject - unsuitable"  button' do
        expect(rendered).to have_link('Reject - unsuitable', href: send("reject_admin_moderation_#{path_segment}_path", moderatable.to_param, reason: 'unsuitable'))
      end

      it 'does not have a "Reject - offensive"  button' do
        expect(rendered).not_to have_link('Reject - offensive')
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

    it 'has an "unmoderate" button' do
      expect(rendered).to have_link('Unmoderate', href: send("unmoderate_admin_moderation_#{path_segment}_path", moderatable.to_param))
    end

    it 'has an "approve" button' do
      expect(rendered).to have_link('Approve', href: send("approve_admin_moderation_#{path_segment}_path", moderatable.to_param))
    end

    it 'has a "reject - unsuitable"  button' do
      expect(rendered).to have_link('Reject - unsuitable', href: send("reject_admin_moderation_#{path_segment}_path", moderatable.to_param, reason: 'unsuitable'))
    end

    it 'has a "reject - offensive"  button' do
      expect(rendered).to have_link('Reject - offensive', href: send("reject_admin_moderation_#{path_segment}_path", moderatable.to_param, reason: 'offensive'))
    end
  end
end
