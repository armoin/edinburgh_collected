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
    expect(rendered).to have_css('.sub', memory.date)
  end

  it 'has an attribution' do
    expect(rendered).to have_css('p', text: memory.attribution, count: 1)
  end

  it 'has a comma separated list of categories' do
    expect(rendered).to have_css('p', text: memory.category_list, count: 1)
  end
end
