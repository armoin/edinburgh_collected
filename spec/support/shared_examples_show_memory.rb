RSpec.shared_examples "a memory show page" do
  before :each do
    assign(:memory, memory)
    render
  end

  it "displays a memory" do
    expect(rendered).to have_css('.memory')
  end

  it 'has a title' do
    expect(rendered).to have_css('.title', text: memory.title)
  end

  it 'has an image' do
    expect(rendered).to match /img.*alt="#{memory.title}"/
    expect(rendered).to match /img.*src="#{memory.source_url}.*"/
  end

  it 'has a description' do
    expect(rendered).to have_css('p', text: "This is a test.", count: 1)
  end

  it "has an area" do
    expect(rendered).to have_css('.sub', memory.area.name)
  end

  it "has a location" do
    expect(rendered).to have_css('.sub', memory.location)
  end

  it "has a date" do
    expect(rendered).to have_css('.sub', memory.date_string)
  end

  it 'has an attribution' do
    expect(rendered).to have_css('p', text: memory.attribution, count: 1)
  end

  it 'has a comma separated list of categories' do
    expect(rendered).to have_css('p', text: memory.category_list, count: 1)
  end

  context "when memory belongs to the user" do
    let(:user) { Fabricate.build(:active_user) }

    before :each do
      assign(:memory, memory)
      allow(view).to receive(:current_user).and_return(user)
      allow(user).to receive(:can_modify?).and_return(true)
      render
    end

    it "has an edit link" do
      expect(rendered).to have_link('Edit this memory', href: edit_path)
    end

    it "has a delete link" do
      expect(rendered).to have_link('Delete this memory', href: delete_path)
    end
  end
end
