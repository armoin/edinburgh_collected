RSpec.shared_examples 'a memory index' do
  context 'a memory' do

    it "displays all given memories" do
      expect(rendered).to have_css('.memory:not(.add)', count: 3)
    end

    describe 'a memory' do
      let(:memory) { memories.first }

      it 'has a link to add that memory to a scrapbook' do
        expect(rendered).to have_css(".memory a.addScrapbook")
      end

      it 'has a link to view that memory' do
        path_to_memory = send(base_memory_path, memory)

        expect(rendered).to have_css(".memory a.view[href=\"#{path_to_memory}\"]")
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
end
