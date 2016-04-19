require 'rails_helper'

describe "admin/cms/home_pages/index.html.erb" do
  it_behaves_like 'a tabbed admin page' do
    let(:active_tab) { 'CMS' }
  end

  let(:published) { false }
  let(:home_pages) do
    Array.new(3) do |i|
      double(
        id: i+1,
        featured_memory: double(title: "Memory #{i}"),
        created_at: i.days.ago,
        updated_at: i.days.ago,
        published?: published
      )
    end
  end

  before :each do
    assign(:home_pages, home_pages)
    render
  end

  it 'has a button to add a new home_page' do
    expect(rendered).to have_link('Add a new home page', href: new_admin_cms_home_page_path)
  end

  it 'shows each of the given home_pages' do
    expect(rendered).to have_css('tr.home-page', count: 3)
  end

  describe 'a home_page' do
    let(:home_page) { home_pages.first }

    it 'shows the title of the featured memory with a link to the show page' do
      expect(rendered).to have_link(home_page.featured_memory.title, href: admin_cms_home_page_path(home_page))
    end

    def formatted_date(date)
      date.strftime('%d-%b-%Y %H:%M')
    end

    it 'shows the created at date' do
      expect(rendered).to have_css('tr.home-page td.t-created-at', text: formatted_date(home_page.created_at))
    end

    it 'shows the updated at date' do
      expect(rendered).to have_css('tr.home-page td.t-updated-at', text: formatted_date(home_page.updated_at))
    end

    describe 'actions' do
      context 'when not published' do
        let(:published) { false }

        it 'shows the Publish button' do
          expect(rendered).to have_link('Publish')
        end
      end

      context 'when published' do
        let(:published) { true }

        it 'shows the LIVE label' do
          expect(rendered).to have_css('span.home-page_status--live', text: 'LIVE')
        end
      end
    end
  end
end
