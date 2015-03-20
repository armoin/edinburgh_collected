RSpec.shared_examples 'a user profile' do
  let(:links)    { build_array(2, :link) }
  let(:is_group) { false }
  let(:user)     { Fabricate.build(:active_user, id: 123, is_group: is_group, links: links) }
  let(:blocked)  { false }

  before :each do
    assign(:user, user)
    allow(user).to receive(:is_blocked?).and_return(blocked)
    render
  end

  context 'when the user has not been blocked' do
    let(:blocked) { false }

    it 'does not show a blocked label' do
      expect(rendered).not_to have_css('.blocked', text: 'Blocked')
    end
  end

  context 'when the user has been blocked' do
    let(:blocked) { true }

    it 'shows a blocked label' do
      expect(rendered).to have_css('.blocked', text: 'Blocked')
    end
  end

  it 'shows the avatar' do
    expect(rendered).to have_css('.userAvatar img')
  end

  it 'shows the username' do
    expect(rendered).to have_css('h1.title', text: user.screen_name)
  end

  context 'when the user is an individual' do
    let(:is_group) { false }

    it 'shows the first name' do
      expect(rendered).to have_css('p', text: "First name: #{user.first_name}")
    end

    it 'shows the last name' do
      expect(rendered).to have_css('p', text: "Last name: #{user.last_name}")
    end

    it 'does not show the group name' do
      expect(rendered).not_to have_css('p', text: "Group name: #{user.first_name}")
    end
  end

  context 'when the user is a group' do
    let(:is_group) { true }

    it 'does not show the first name' do
      expect(rendered).not_to have_css('p', text: "First name: #{user.first_name}")
    end

    it 'does not show the last name' do
      expect(rendered).not_to have_css('p', text: "Last name: #{user.last_name}")
    end

    it 'shows the group name' do
      expect(rendered).to have_css('p', text: "Group name: #{user.first_name}")
    end
  end

  it 'shows the description' do
    expect(rendered).to have_css('p', text: "Bio:")
    expect(rendered).to have_css('p', text: user.description)
  end

  it 'shows the email' do
    expect(rendered).to have_css('p', text: "Email: #{user.email}")
  end

  context "when the user has no links" do
    let(:links) { [] }

    it "does not display the requested user's links" do
      expect(rendered).not_to have_css('p.link')
      expect(rendered).not_to have_css('p.link a')
    end
  end

  context "when the user has links" do
    let(:links) { build_array(2, :link) }

    it "displays the requested user's links" do
      links.each do |link|
        expect(rendered).to have_css('p.link', text: link.name, count: 1)
        expect(rendered).to have_css("p.link a[href=\"#{link.url}\"]", text: link.url_without_protocol, count: 1)
      end
    end
  end
end