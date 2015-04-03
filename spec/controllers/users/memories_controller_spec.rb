require 'rails_helper'

describe Users::MemoriesController do
  let(:requested_user) { Fabricate.build(:active_user, id: 123) }

  before :each do
    allow(User).to receive(:find).and_return(requested_user)
  end

  describe 'GET index' do
    it 'sets the current memory index path' do
      get :index, user_id: requested_user.to_param
      expect(session[:current_memory_index_path]).to eql(user_memories_path(user_id: requested_user.to_param))
    end

    it 'finds the requested user' do
      get :index, user_id: requested_user.to_param
      expect(User).to have_received(:find).with(requested_user.to_param)
    end

    context 'when no user is found' do
      before :each do
        allow(User).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        get :index, user_id: requested_user.to_param
      end

      it 'returns a 404 error' do
        expect(response).to be_not_found
      end
    end

    context 'when requested user is found' do
      context 'if the requested user is the current user' do
        it 'redirects to my/memories' do
          allow(controller).to receive(:current_user).and_return(requested_user)
          get :index, user_id: requested_user.to_param
          expect(response).to redirect_to(my_memories_path)
        end
      end

      context 'if the requested user is not the current user' do
        let(:other_user)             { Fabricate.build(:active_user, id: 456) }
        let(:presenter_stub)         { double('presenter') }
        let(:page)                   { nil }

        before :each do
          allow(controller).to receive(:current_user).and_return(other_user)
          allow(UserMemoriesPresenter).to receive(:new).and_return(presenter_stub)
          allow(requested_user).to receive(:publicly_visible?).and_return(visible)

          get :index, user_id: requested_user.to_param, page: page
        end

        context 'but the requested user is not publicly visible' do
          let(:visible) { false }

          it 'returns a 404 error' do
            expect(response).to be_not_found
          end
        end

        context 'and the requested user is publicly visible' do
          let(:visible) { true }

          context 'when no page is given' do
            let(:page) { nil }

            it 'generates an UserMemoriesPresenter with a nil page' do
              expect(UserMemoriesPresenter).to have_received(:new).with(requested_user, other_user, nil)
            end
          end

          context 'when a page is given' do
            let(:page) { "1" }

            it 'generates an UserMemoriesPresenter with the page' do
              expect(UserMemoriesPresenter).to have_received(:new).with(requested_user, other_user, "1")
            end
          end

          it 'assigns the presenter' do
            expect(assigns[:presenter]).to eql(presenter_stub)
          end

          it 'renders the user index page' do
            expect(response).to render_template('memories/user_index')
          end
        end
      end
    end
  end
end