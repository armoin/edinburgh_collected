require 'rails_helper'

describe Filter::CategoryController do
  describe 'GET index' do
    let(:paged_memory_results) { double('paged_memory_results') }
    let(:memory_results)       { double('memory_results', page: paged_memory_results) }

    before :each do
      allow(Memory).to receive(:filter_by_category).and_return(memory_results)
      get :index, category: category
    end

    context 'when no category is given' do
      let(:category) { nil }
    
      it 'stores the memory index path with no category' do
        expect(session[:current_memory_index_path]).to eql(filter_category_path)
      end

      it "redirects to the browse memories page" do
        expect(response).to redirect_to(memories_path)
      end
    end

    context 'when a blank category is given' do
      let(:category) { '' }
    
      it 'stores the memory index path with a blank category' do
        expect(session[:current_memory_index_path]).to eql(filter_category_path(category: category))
      end

      it "redirects to the browse memories page" do
        expect(response).to redirect_to(memories_path)
      end
    end

    context 'when a category is given' do
      let(:category) { 'foo' }
    
      it 'stores the memory index path with the given category' do
        expect(session[:current_memory_index_path]).to eql(filter_category_path(category: category))
      end

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