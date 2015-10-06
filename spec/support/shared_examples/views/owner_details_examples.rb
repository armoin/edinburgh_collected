RSpec.shared_examples 'an owner details page' do
  let(:user) { nil }

  before :each do
    allow(view).to receive(:current_user).and_return(user)
    render
  end

  it "displays the owner's avatar" do
    expect(rendered).to have_css( "img[src=\"/assets/#{owner.avatar_url}\"]" )
  end

  context 'when current user is not signed in' do
    it "displays a link to the user page for the owner" do
      expect(rendered).to have_link("#{label} #{owner.screen_name}", user_page_link)
    end
  end

  context 'when current user is signed in' do
    context 'but is not the owner' do
      let(:user) { Fabricate.build(:active_user, id: 789) }

      it "displays a link to the user page for the owner" do
        expect(rendered).to have_link("#{label} #{owner.screen_name}", user_page_link)
      end
    end

    context 'and is the owner' do
      let(:user) { owner }

      it "displays a link to the user page for the owner" do
        expect(rendered).to have_link("#{label} You", user_page_link)
      end
    end
  end
end
