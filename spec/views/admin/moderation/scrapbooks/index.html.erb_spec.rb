require 'rails_helper'

describe "admin/moderation/scrapbooks/index.html.erb" do
  let(:items) { Array.new(3) {|n| Fabricate.build(:scrapbook, id: n+1) } }

  before :each do
    assign(:items, items)
  end

  context 'when viewing from the index action' do
    before :each do
      allow(view).to receive(:action_name).and_return('index')
      render
    end

    it "has a link to the Moderated view" do
      expect(rendered).to have_link('Moderated', href: moderated_admin_moderation_scrapbooks_path)
    end

    it "does not have a link to the Unmoderated view" do
      expect(rendered).not_to have_link('Unmoderated', href: admin_moderation_scrapbooks_path)
    end
  end

  context 'when viewing from the moderated action' do
    before :each do
      allow(view).to receive(:action_name).and_return('moderated')
      render
    end

    it "does not have a link to the Moderated view" do
      expect(rendered).not_to have_link('Moderated', href: moderated_admin_moderation_scrapbooks_path)
    end

    it "has a link to the Unmoderated view" do
      expect(rendered).to have_link('Unmoderated', href: admin_moderation_scrapbooks_path)
    end
  end

  context 'when viewing either action' do
    it "shows each of the given items" do
      render
      expect(rendered).to have_css('tr.item', count: 3)
    end

    describe 'an item' do
      let(:item)              { Fabricate.build(:scrapbook, id: 123) }
      let(:last_moderated_at) { nil }

      before :each do
        allow(item).to receive(:last_moderated_at).and_return(last_moderated_at)
        assign(:items, [item])
        render
      end

      it 'has a "View Details" link to the item show page' do
        expect(rendered).to have_link('View details', scrapbook_path(item.id))
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

