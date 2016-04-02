RSpec.shared_examples 'a tabbed admin page' do
  describe 'tab bar' do
    before { render }

    it 'is displayed' do
      expect(rendered).to have_css('.nav.nav-tabs')
    end

    it "shows the correct active tab" do
      expect(rendered).to have_css('li.active', text: active_tab)
    end
  end
end
