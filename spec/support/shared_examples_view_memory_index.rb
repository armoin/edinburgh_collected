RSpec.shared_examples 'a memory index' do
  it "displays all given memories and an add button" do
    expect(rendered).to have_css('.memory.add', count: 1)
    expect(rendered).to have_css('.memory', count: 4)
  end

  context 'a memory' do
    let(:memory) { memories.first }

    it 'has a title' do
      expect(rendered).to have_css('.memory .title', text: memory.title)
    end

    it 'has a thumbnail image' do
      expect(rendered).to match /img.*alt="#{memory.title}"/
      expect(rendered).to match /img.*src="#{memory.source_url(:thumb)}.*"/
    end
  end
end
