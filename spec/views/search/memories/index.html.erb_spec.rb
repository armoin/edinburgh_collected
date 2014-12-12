require 'rails_helper'

describe 'search/memories/index.html.erb' do
  let(:user)           { Fabricate(:user) }
  let(:params_stub)    { {query: 'test search'}  }

  context 'when there are no results' do
    let(:memories)       { [] }
    let(:paged_memories) { Kaminari.paginate_array(memories).page(1) }

    before :each do
      allow(view).to receive(:current_user).and_return(user)
      allow(view).to receive(:params).and_return(params_stub)
      assign(:memories, paged_memories)
      render
    end

    it 'displays the result count' do
      expect(rendered).to have_css('#contentHeader', text: "Found 0 matches for \"#{params_stub[:query]}\"")
    end

    it "doesn't show an add button" do
      expect(rendered).not_to have_css('.memory.add')
    end

    it "does not display any results" do
      expect(rendered).not_to have_css('.memory')
    end

    it "displays a no results message" do
      expect(rendered).to have_css('.no-results p', text: "Sorry, but we couldn't find any results for \"#{params_stub[:query]}\"")
    end
  end

  context 'when there are results' do
    let(:memories)       { Fabricate.times(3, :photo_memory, user: user) }
    let(:paged_memories) { Kaminari.paginate_array(memories).page(1) }

    before :each do
      allow(view).to receive(:current_user).and_return(user)
      allow(view).to receive(:params).and_return(params_stub)
      assign(:memories, paged_memories)
      render
    end

    it 'displays the result count' do
      expect(rendered).to have_css('#contentHeader', text: "Found 3 matches for \"#{params_stub[:query]}\"")
    end

    it "doesn't show an add button" do
      expect(rendered).not_to have_css('.memory.add')
    end

    context 'a memory' do
      let(:memory) { memories.first }

      it 'is a link to the show page for that memory' do
        expect(rendered).to have_css("a.memory[href=\"#{memory_path(memory)}\"]")
      end
    end

    it_behaves_like 'a memory index'
    it_behaves_like 'paginated content'
  end
end

