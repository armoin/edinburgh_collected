require 'rails_helper'

RSpec.describe 'admin/cms/home_pages/show.html.erb' do
  include_context 'home_page'

  let(:home_page) do
    HomePage.new(
      id: 123,
      featured_memory: @featured_memory,
      featured_scrapbook: @featured_scrapbook,
      featured_scrapbook_memory_ids: @featured_scrapbook_memories.map(&:id).join(','),
      published: published
    )
  end
  let(:published) { false }

  before :each do
    assign(:home_page_presenter, HomePagePresenter.new(home_page))
    render
  end

  it 'lets the user know that this is a preview' do
    expect(rendered).to have_css('h1', text: 'Preview')
  end

  it 'has a link back to the index page' do
    expect(rendered).to have_link('Back to list', href: admin_cms_home_pages_path)
  end

  context 'when the page is not published' do
    let(:published) { false }

    it 'shows the state as draft' do
      expect(rendered).to have_css('.state.draft', text: 'draft')
    end

    it 'has an edit button' do
      expect(rendered).to have_link('Edit', href: edit_admin_cms_home_page_path(home_page))
    end

    it 'has a publish button' do
      expect(rendered).to have_link('Publish', href: publish_admin_cms_home_page_path(home_page))
    end

    it 'has a delete button' do
      expect(rendered).to have_link('Delete', href: admin_cms_home_page_path(home_page))
    end

    it 'does not have a message saying that it can not be modified' do
      expect(rendered).not_to have_css('span', text: 'Cannot modify whilst live')
    end
  end

  context 'when the page is published' do
    let(:published) { true }

    it 'shows the state as live' do
      expect(rendered).to have_css('.state.live', text: 'live')
    end

    it 'does not have an edit button' do
      expect(rendered).not_to have_link('Edit', href: edit_admin_cms_home_page_path(home_page))
    end

    it 'does not have a publish button' do
      expect(rendered).not_to have_link('Publish', href: publish_admin_cms_home_page_path(home_page))
    end

    it 'does not have a delete button' do
      expect(rendered).not_to have_link('Delete', href: admin_cms_home_page_path(home_page))
    end

    it 'has a message saying that it can not be modified' do
      expect(rendered).to have_css('span', text: 'Cannot modify whilst live')
    end
  end

  describe 'preview' do
    describe 'featured memory' do
      it 'displays the image' do
        expect(rendered).to have_css("img[src=\"#{home_page.hero_image_url}\"]")
      end

      it 'displays the title' do
        expect(rendered).to have_css('#imageInfo p', text: @featured_memory.title)
      end

      it 'displays the year' do
        expect(rendered).to have_css('#imageInfo p', text: @featured_memory.year)
      end

      it "displays a link to the owner's other memories" do
        expect(rendered).to have_link(@featured_memory.user.screen_name, href: user_memories_url(@featured_memory.user))
      end
    end

    describe 'featured scrapbook' do
      it 'displays the title' do
        expect(rendered).to have_css('#featuredScrapbook footer', text: @featured_scrapbook.title)
      end

      it "displays a link to the owner's other scrapbooks" do
        expect(rendered).to have_link(@featured_scrapbook.user.screen_name, href: user_scrapbooks_path(@featured_scrapbook.user))
      end

      it "displays a link to view the scrapbook" do
        expect(rendered).to have_link('View scrapbook', href: scrapbook_url(@featured_scrapbook))
      end
    end

    describe 'featured scrapbook memories' do
      it 'displays all scrapbook memories' do
        expect(rendered).to have_css('.item[title="View memory details"]', count: 4)
      end

      describe 'each memory' do
        let(:scrapbook_memory) { @featured_scrapbook_memories.first }

        it 'has a link to the memory page for that memory' do
          expect(rendered).to have_css("a.item[href='#{memory_path(scrapbook_memory.memory.id)}']")
        end

        it 'shows the thumbnail image for that memory' do
          expect(rendered).to have_css("img[src='#{scrapbook_memory.memory.source_url(:thumb)}']")
        end
      end
    end
  end
end
