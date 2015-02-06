require 'rails_helper'

describe Filter::CategoriesController do
  describe 'GET index' do
    let(:paged_memory_results) { double('paged_memory_results') }
    let(:memory_results)       { double('memory_results', page: paged_memory_results) }

    before :each do
      allow(Memory).to receive(:filter_by_category).and_return(memory_results)
      get :index, category: category
    end

    context 'when no category is given' do
      let(:category) { nil }
    
      it "redirects to the browse memories page" do
        expect(response).to redirect_to(memories_path)
      end
    end

    context 'when a category is given' do
      let(:category) { 'foo' }
    
      it 'finds all memories that are under the given category' do
        expect(Memory).to have_received(:filter_by_category).with(category)
      end

      it 'paginates the found memories' do
        expect(memory_results).to have_received(:page)
      end

      it 'assigns the paged memories' do
        expect(assigns[:memories]).to eql(paged_memory_results)
      end

      it 'renders the index view' do
        expect(response).to render_template(:index)
      end
    end
  end
end