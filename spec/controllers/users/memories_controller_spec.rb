require 'rails_helper'

describe Users::MemoriesController do
  let(:requested_user)   { Fabricate.build(:active_user, id: 123) }
  let(:user_find_result) { requested_user }

  let(:user)             { nil }

  let(:visible)          { true }

  let(:memories)         { double }
  let(:visible_memories) { double }

  before :each do
    allow(User).to receive(:find) { user_find_result }
    allow(requested_user).to receive(:publicly_visible?).and_return(visible)

    allow(controller).to receive(:current_user).and_return(user)

    allow(requested_user).to receive(:memories).and_return(memories)
    allow(memories).to receive(:publicly_visible).and_return(visible_memories)
  end

  describe 'GET index' do
    let(:page)               { '1' }

    let(:ordered_memories)   { double }
    let(:paged_memories)     { double }

    let(:scrapbooks)         { double }
    let(:visible_scrapbooks) { double }

    let(:scrapbooks_count)   { 3 }

    before :each do
      allow(visible_memories).to receive(:by_last_created).and_return(ordered_memories)
      allow(ordered_memories).to receive(:page).and_return(paged_memories)

      allow(requested_user).to receive(:scrapbooks).and_return(scrapbooks)
      allow(scrapbooks).to receive(:publicly_visible).and_return(visible_scrapbooks)
      allow(visible_scrapbooks).to receive(:count).and_return(scrapbooks_count)

      get :index, user_id: requested_user.to_param, page: page
    end

    it 'sets the current memory index path' do
      expect(session[:current_memory_index_path]).to eql(user_memories_path(user_id: requested_user.to_param, page: page))
    end

    it 'finds the requested user' do
      expect(User).to have_received(:find).with(requested_user.to_param)
    end

    context 'when no user is found' do
      let(:user_find_result) { fail ActiveRecord::RecordNotFound }

      it 'returns a 404 error' do
        expect(response).to be_not_found
      end
    end

    context 'when requested user is found' do
      let(:user_find_result) { requested_user }

      context 'if the requested user is the current user' do
        let(:user) { requested_user }

        it 'redirects to my/memories' do
          expect(response).to redirect_to(my_memories_path)
        end
      end

      context 'if the requested user is not the current user' do
        let(:user) { nil }


        context 'but the requested user is not publicly visible' do
          let(:visible) { false }

          it 'returns a 404 error' do
            expect(response).to be_not_found
          end
        end

        context 'and the requested user is publicly visible' do
          let(:visible) { true }

          it "fetches the requested user's memories" do
            expect(requested_user).to have_received(:memories)
          end

          it 'filters out any memories that are not publicly visible' do
            expect(memories).to have_received(:publicly_visible)
          end

          it 'orders the visible memories by their last created date' do
            expect(visible_memories).to have_received(:by_last_created)
          end

          it 'paginates the ordered memories' do
            expect(ordered_memories).to have_received(:page).with(page)
          end

          it 'assigns the paged memories' do
            expect(assigns[:memories]).to eq(paged_memories)
          end

          it 'assigns the scrapbook count' do
            expect(assigns[:scrapbooks_count]).to eql(scrapbooks_count)
          end

          it 'renders the user index page' do
            expect(response).to render_template('users/memories/index')
          end
        end
      end
    end
  end

  describe 'GET show' do
    let(:user_find_result) { requested_user }

    let(:memory)           { Fabricate.build(:photo_memory, id: 123) }
    let(:find_result)      { memory }

    let(:page)             { '2' }

    before :each do
      allow(visible_memories).to receive(:find) { find_result }

      get :show, id: '123', user_id: requested_user.to_param, page: page
    end

    it 'does not set the current memory index path' do
      expect(session[:current_memory_index_path]).to be_nil
    end

    it 'finds the requested user' do
      expect(User).to have_received(:find).with(requested_user.to_param)
    end

    context 'when no user is found' do
      let(:user_find_result) { fail ActiveRecord::RecordNotFound }

      it 'returns a 404 error' do
        expect(response).to be_not_found
      end
    end

    context 'when requested user is found' do
      context 'but the requested user is not publicly visible' do
        let(:visible) { false }

        it 'returns a 404 error' do
          expect(response).to be_not_found
        end
      end

      context 'and the requested user is publicly visible' do
        let(:visible) { true }

        it "searches for the requested memory in the requested user's visible memories" do
          expect(visible_memories).to have_received(:find).with('123')
        end

        context 'when a memory is found' do
          let(:find_result) { memory }

          it 'assigns the memory' do
            expect(assigns[:memory]).to eq(memory)
          end

          it 'assigns the page' do
            expect(assigns[:page]).to eq(page)
          end

          it 'renders the show page' do
            expect(response).to render_template(:show)
          end
        end

        context 'when a memory is not found' do
          let(:find_result) { fail ActiveRecord::RecordNotFound }

          it 'does not assign the memory' do
            expect(assigns[:memory]).to be_nil
          end

          it 'does not assign the page' do
            expect(assigns[:page]).to be_nil
          end

          it 'returns a 404 error' do
            expect(response).to be_not_found
          end
        end
      end
    end
  end
end
