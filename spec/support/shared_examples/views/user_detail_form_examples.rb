RSpec.shared_examples 'a user detail form' do
  describe 'first_name' do
    it "asks for the user's first name" do
      expect(rendered).to have_css('input[type="text"]#user_first_name')
    end

    it "is required" do
      expect(rendered).to have_css('.form-group[aria-required="true"] input[type="text"]#user_first_name')
    end
  end

  describe 'email' do
    it "asks for the user's email address" do
      expect(rendered).to have_css('input[type="email"]#user_email')
    end

    it "is required" do
      expect(rendered).to have_css('.form-group[aria-required="true"] input[type="email"]#user_email')
    end
  end

  describe 'screen_name' do
    it 'has the label "Username"' do
      expect(rendered).to have_css('label[for="user_screen_name"]', text: "Username")
    end

    it "asks for the user's screen name" do
      expect(rendered).to have_css('input[type="text"]#user_screen_name')
    end

    it "is required" do
      expect(rendered).to have_css('.form-group[aria-required="true"] input[type="text"]#user_screen_name')
    end
  end
end