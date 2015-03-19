##
# Needs to have the following set up:
#
#   users: an array of users
#
#   Example:
#     let(:items)        { Array.new(3) {|i| Fabricate.build(:user, id: i+1) } }
#
RSpec.shared_examples 'a user index' do
  it "shows each of the given users" do
    render
    expect(rendered).to have_css('tr.user', count: 3)
  end

  describe 'a user' do
    let(:user)       { users.first }
    let(:active)     { false }
    let(:is_group)   { false }
    let(:is_blocked) { false }

    before :each do
      allow(user).to receive(:active?).and_return(active)
      allow(user).to receive(:is_group?).and_return(is_group)
      allow(user).to receive(:is_blocked?).and_return(is_blocked)
      render
    end

    it 'has a link to the user' do
      expect(rendered).to have_link(user.screen_name, href: admin_user_path(user))
    end

    it "shows the user's name" do
      expect(rendered).to have_css('td', text: user.name)
    end

    it "shows the user's email" do
      expect(rendered).to have_css('td', text: user.email)
    end

    describe 'shows the whether the user is active or not' do
      context 'when the user is not active' do
        let(:active) { false }

        it 'displays false' do
          expect(rendered).to have_css('td:nth-child(4)', text: "false")
        end
      end

      context 'when the user is active' do
        let(:active) { true }

        it 'displays true' do
          expect(rendered).to have_css('td:nth-child(4)', text: "true")
        end
      end
    end

    describe 'shows the whether the user is a group or not' do
      context 'when the user is not a group' do
        let(:is_group) { false }

        it 'displays false' do
          expect(rendered).to have_css('td:nth-child(5)', text: "false")
        end
      end

      context 'when the user is a group' do
        let(:is_group) { true }

        it 'displays true' do
          expect(rendered).to have_css('td:nth-child(5)', text: "true")
        end
      end
    end

    describe 'shows the whether the user is blocked or not' do
      context 'when the user is not blocked' do
        let(:is_blocked) { false }

        it 'displays false' do
          expect(rendered).to have_css('td:nth-child(6)', text: "false")
        end
      end

      context 'when the user is blocked' do
        let(:is_blocked) { true }

        it 'displays true' do
          expect(rendered).to have_css('td:nth-child(6)', text: "true")
        end
      end
    end
  end
end