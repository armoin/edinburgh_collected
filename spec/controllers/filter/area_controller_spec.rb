require 'rails_helper'

describe Filter::AreaController do
  describe 'GET index' do
    let(:paged_memory_results) { double('paged_memory_results') }
    let(:memory_results)       { double('memory_results', page: paged_memory_results) }

    before :each do
      allow(Memory).to receive(:filter_by_area).and_return(memory_results)
      get :index, area: area
    end

    context 'when no area is given' do
      let(:area) { nil }
    
      it 'stores the memory index path with no area' do
        expect(session[:current_memory_index_path]).to eql(filter_area_path)
      end

      it "redirects to the browse memories page" do
        expect(response).to redirect_to(memories_path)
      end
    end

    context 'when a blank area is given' do
      let(:area) { '' }
    
      it 'stores the memory index path with a blank area' do
        expect(session[:current_memory_index_path]).to eql(filter_area_path(area: area))
      end

      it "redirects to the browse memories page" do
        expect(response).to redirect_to(memories_path)
      end
    end

    context 'when a area is given' do
      let(:area) { 'foo' }
    
      it 'stores the memory index path with the given area' do
        expect(session[:current_memory_index_path]).to eql(filter_area_path(area: area))
      end

      it 'finds all memories that are under the given area' do
        expect(Memory).to have_received(:filter_by_area).with(area)
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