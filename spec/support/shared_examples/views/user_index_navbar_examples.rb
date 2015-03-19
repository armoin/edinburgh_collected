RSpec.shared_examples 'a user index navbar' do
  before :each do
    allow(view).to receive(:action_name).and_return(action)
    render
  end

  context 'when viewing from the index action' do
    let(:action) { 'index' }

    it "has a link back to the Inbox view" do
      expect(rendered).to have_link('Back to Inbox', href: admin_home_path)
    end

    it "does not have a link to the Show all view" do
      expect(rendered).not_to have_link('Show all')
    end

    it "has a link to the Show blocked view" do
      expect(rendered).to have_link('Show blocked', href: blocked_admin_users_path)
    end
  end

  context 'when viewing from the blocked action' do
    let(:action) { 'blocked' }

    it "has a link back to the Inbox view" do
      expect(rendered).to have_link('Back to Inbox', href: admin_home_path)
    end

    it "has a link to the Show all view" do
      expect(rendered).to have_link('Show all', href: admin_users_path)
    end

    it "does not have a link to the Show blocked view" do
      expect(rendered).not_to have_link('Show blocked')
    end
  end
end
