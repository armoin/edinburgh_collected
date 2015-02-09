require 'rails_helper'

describe Filter::TagsController do
  describe 'GET index' do
    let(:paged_memory_results) { double('paged_memory_results') }
    let(:memory_results)       { double('memory_results', page: paged_memory_results) }

    before :each do
      allow(Memory).to receive(:filter_by_tag).and_return(memory_results)
      get :index, tag: tag
    end

    context 'when no tag is given' do
      let(:tag) { nil }
    
      it 'stores the memory index path with no tag' do
        expect(session[:current_memory_index_path]).to eql(filter_tags_path)
      end

    it "redirects to the browse memories page" do
        expect(response).to redirect_to(memories_path)
      end
    end

    context 'when a blank tag is given' do
      let(:tag) { '' }
    
      it 'stores the memory index path with a blank tag' do
        expect(session[:current_memory_index_path]).to eql(filter_tags_path(tag: tag))
      end

      it "redirects to the browse memories page" do
        expect(response).to redirect_to(memories_path)
      end
    end

    context 'when a tag is given' do
      let(:tag) { 'foo' }
    
      it 'stores the memory index path with the given tag' do
        expect(session[:current_memory_index_path]).to eql(filter_tags_path(tag: tag))
      end

      it 'finds all memories that are under the given tag' do
        expect(Memory).to have_received(:filter_by_tag).with(tag)
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