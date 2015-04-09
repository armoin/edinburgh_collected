RSpec.shared_examples 'add to scrapbook' do
  it 'has an Add To Scrapbook modal' do
    render
    expect(rendered).to have_css('#add-to-scrapbook-modal')
  end

  it 'allows the user to select from a list of their scrapbooks' do
    render
    expect(rendered).to have_css('.scrapbook_selector')
  end

  describe 'creating a new scrapbook' do
    it 'has a Create Scrapbook button' do
      render
      expect(rendered).to have_css('#create-scrapbook-button')
    end

    it 'contains a Create Scrapbook modal' do
      render
      expect(rendered).to have_css('#create-scrapbook-modal')
    end
  end

  describe 'after the memory has been added to the scrapbook' do
    it 'shows a success message modal' do
      render
      expect(rendered).to have_css('#after-add-to-scrapbook-modal')
    end
  end
end
