require 'rails_helper'

RSpec.describe 'admin/cms/home_pages/show.html.erb' do
  before :all do
    @memory = Fabricate(:approved_photo_memory)
    @scrapbook = Fabricate(:approved_scrapbook)
    @scrapbook_memories = Fabricate.times(4, :scrapbook_photo_memory, scrapbook: @scrapbook)
  end

  after :all do
    @memory.destroy
    @scrapbook.destroy
    @scrapbook_memories.each(&:destroy)
    User.destroy_all
  end

  let(:home_page) do
    HomePage.new(
      featured_memory: @memory,
      featured_scrapbook: @scrapbook,
      featured_scrapbook_memory_ids: @scrapbook_memories.map(&:id).join(',')
    )
  end

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

  describe 'preview' do
    describe 'featured memory' do
      it 'displays the image' do
        expect(rendered).to have_css("img[src=\"#{@memory.source_url}\"]")
      end

      it 'displays the title' do
        expect(rendered).to have_css('#imageInfo p', text: @memory.title)
      end

      it 'displays the year' do
        expect(rendered).to have_css('#imageInfo p', text: @memory.year)
      end

      it "displays a link to the owner's other memories" do
        expect(rendered).to have_link(@memory.user.screen_name, href: user_memories_url(@memory.user))
      end
    end

    describe 'featured scrapbook' do
      it 'displays the title' do
        expect(rendered).to have_css('#featuredScrapbook footer', text: @scrapbook.title)
      end

      it "displays a link to the owner's other scrapbooks" do
        expect(rendered).to have_link(@scrapbook.user.screen_name, href: user_scrapbooks_path(@scrapbook.user))
      end

      it "displays a link to view the scrapbook" do
        expect(rendered).to have_link('View scrapbook', href: scrapbook_url(@scrapbook))
      end
    end

    describe 'featured scrapbook memories' do
      it 'displays all scrapbook memories' do
        expect(rendered).to have_css('.item[title="View memory details"]', count: 4)
      end

      describe 'each memory' do
        let(:scrapbook_memory) { @scrapbook_memories.first }

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
