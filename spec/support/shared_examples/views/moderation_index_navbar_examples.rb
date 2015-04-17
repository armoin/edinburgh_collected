RSpec.shared_examples 'a moderation index navbar' do
  before :each do
    allow(view).to receive(:action_name).and_return(action)
    render
  end

  context 'when viewing from the index action' do
    let(:action) { 'index' }

    it "has a link back to the Inbox view" do
      expect(rendered).to have_link('Back to Inbox', href: admin_home_path)
    end

    it "does not have a link to the Unmoderated view" do
      expect(rendered).not_to have_link('Unmoderated')
    end

    it "has a link to the Reported view" do
      expect(rendered).to have_link('Reported', href: send("reported_admin_moderation_#{path_segment}_path"))
    end

    it "has a link to the Moderated view" do
      expect(rendered).to have_link('Moderated', href: send("moderated_admin_moderation_#{path_segment}_path"))
    end
  end

  context 'when viewing from the reported action' do
    let(:action) { 'reported' }

    it "has a link back to the Inbox view" do
      expect(rendered).to have_link('Back to Inbox', href: admin_home_path)
    end

    it "has a link to the Unmoderated view" do
      expect(rendered).to have_link('Unmoderated', href: send("admin_moderation_#{path_segment}_path"))
    end

    it "does not have a link to the Reported view" do
      expect(rendered).not_to have_link('Reported')
    end

    it "has a link to the Moderated view" do
      expect(rendered).to have_link('Moderated', href: send("moderated_admin_moderation_#{path_segment}_path"))
    end
  end

  context 'when viewing from the moderated action' do
    let(:action) { 'moderated' }

    it "has a link back to the Inbox view" do
      expect(rendered).to have_link('Back to Inbox', href: admin_home_path)
    end

    it "has a link to the Unmoderated view" do
      expect(rendered).to have_link('Unmoderated', href: send("admin_moderation_#{path_segment}_path"))
    end

    it "has a link to the Reported view" do
      expect(rendered).to have_link('Reported', href: send("reported_admin_moderation_#{path_segment}_path"))
    end

    it "does not have a link to the Moderated view" do
      expect(rendered).not_to have_link('Moderated')
    end
  end
end
