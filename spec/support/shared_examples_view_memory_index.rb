RSpec.shared_examples 'a memory index' do
  context 'a memory' do
    let(:memory) { memories.first }

    it "displays all given memories" do
      expect(rendered).to have_css('.memory:not(.add)', count: 3)
    end

    it 'has a title' do
      expect(rendered).to have_css('.memory .title', text: memory.title)
    end

    it 'has a thumbnail image' do
      expect(rendered).to match /img.*alt="#{memory.title}"/
      expect(rendered).to match /img.*src="#{memory.source_url(:thumb)}.*"/
    end
  end
end
