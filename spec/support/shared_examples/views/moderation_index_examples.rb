##
# Needs to have the following set up:
#
#   items: an array of moderatable items
#   owner: a user that owns the given items
#   admin: an admin user
#   path_segment: the string that completes the route to various links
#
#   Example:
#     let(:owner)        { Fabricate.build(:user, id: 123) }
#     let(:admin)        { Fabricate.build(:admin_user, id: 456) }
#     let(:items)        { Array.new(3) {|n| Fabricate.build(:scrapbook, id: n+1, user: owner) } }
#     let(:path_segment) { 'scrapbooks' }
#
RSpec.shared_examples 'a moderation index' do
  it "allows the moderator to filter the items" do
    render
    expect(rendered).to have_css('input.light-table-filter')
  end

  it "shows each of the given items" do
    render
    expect(rendered).to have_css('tr.item', count: 3)
  end

  describe 'an item' do
    let(:item)              { items.first }
    let(:last_moderated_at) { nil }
    let(:moderated_by)      { nil }

    before :each do
      allow(item).to receive(:last_moderated_at).and_return(last_moderated_at)
      allow(item).to receive(:moderated_by).and_return(moderated_by)
      render
    end

    it 'shows the title as a link to the item show page' do
      expect(rendered).to have_link(item.title, href: send("admin_moderation_#{path_segment.singularize}_path", item.id))
    end

    it 'has a link to the owning user' do
      expect(rendered).to have_link(owner.screen_name, href: admin_moderation_user_path(owner))
    end

    it 'shows the state' do
      expect(rendered).to have_css('td', text: 'unmoderated')
    end

    it 'shows the created at date' do
      expect(rendered).to have_css('td:nth-child(4)', text: created_at.strftime('%d-%b-%Y'))
    end

    it 'shows the updated at date' do
      expect(rendered).to have_css('td:nth-child(5)', text: updated_at.strftime('%d-%b-%Y'))
    end

    context 'when not yet moderated' do
      let(:last_moderated_at) { nil }
      let(:moderated_by)      { nil }

      it 'has a blank last moderated date' do
        expect(rendered).to have_css("td:nth-child(#{moderated_date_col})", text: '')
      end

      it 'has a blank moderated by' do
        expect(rendered).to have_css("td:nth-child(#{moderated_date_col + 1})", text: '')
      end
    end

    context 'when moderated at least once' do
      let(:last_moderated_at) { Time.parse('13-Nov-2014 14:44') }
      let(:moderated_by)      { admin }

      it 'shows the last moderated date' do
        expect(rendered).to have_css("td:nth-child(#{moderated_date_col})", text: '13-Nov-2014 14:44')
      end

      it 'has a link to the moderating user' do
        expect(rendered).to have_link(admin.screen_name, href: admin_moderation_user_path(admin))
      end
    end
  end
end
