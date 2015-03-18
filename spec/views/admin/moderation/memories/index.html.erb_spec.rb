require 'rails_helper'

describe "admin/moderation/memories/index.html.erb" do
  let(:items)        { Array.new(3) {|n| Fabricate.build(:memory, id: n+1) } }
  let(:path_segment) { 'memories' }

  before :each do
    assign(:items, items)
  end

  it_behaves_like 'a moderation index navbar'

  context 'when viewing either action' do
    it "shows each of the given items" do
      render
      expect(rendered).to have_css('tr.item', count: 3)
    end

    describe 'an item' do
      let(:item)              { items.first }
      let(:last_moderated_at) { nil }

      before :each do
        allow(item).to receive(:last_moderated_at).and_return(last_moderated_at)
        render
      end

      it 'has a "View Details" link to the item show page' do
        expect(rendered).to have_link('View details', href: admin_moderation_memory_path(item.id))
      end

      it 'shows the title' do
        expect(rendered).to have_css('td', text: item.title)
      end

      it 'shows the state' do
        expect(rendered).to have_css('td', text: 'unmoderated')
      end

      it 'shows the email address of the owner' do
        expect(rendered).to have_css('td', text: item.user.email)
      end

      context 'when not yet moderated' do
        let(:last_moderated_at) { nil }

        it 'has a blank last modified date' do
          expect(rendered).to have_css('td:nth-child(4)', text: '')
        end
      end

      context 'when moderated at least once' do
        let(:last_moderated_at) { Time.parse('13-Nov-2014 14:44') }

        it 'shows the last moderated date' do
          expect(rendered).to have_css('td:nth-child(4)', text: '13-Nov-2014 14:44')
        end
      end
    end
  end
end

