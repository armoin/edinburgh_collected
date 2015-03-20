require 'rails_helper'

describe Users::ScrapbooksController do
  let(:requested_user)       { Fabricate.build(:active_user, id: 123) }
  let(:active_users_stub)    { double('active_users') }
  let(:unblocked_users_stub) { double('unblocked_users') }

  before :each do
    allow(User).to receive(:active).and_return(active_users_stub)
    allow(active_users_stub).to receive(:unblocked).and_return(unblocked_users_stub)
    allow(unblocked_users_stub).to receive(:find).and_return(requested_user)
  end

  describe 'GET index' do
    it 'sets the current scrapbook index path' do
      get :index, user_id: requested_user.to_param
      expect(session[:current_scrapbook_index_path]).to eql(user_scrapbooks_path(user_id: requested_user.to_param))
    end

    it 'finds the requested user' do
      get :index, user_id: requested_user.to_param
      expect(User.active.unblocked).to have_received(:find).with(requested_user.to_param)
    end

    context 'when no user is found' do
      before :each do
        allow(unblocked_users_stub).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        get :index, user_id: requested_user.to_param
      end

      it 'returns a 404 error' do
        expect(response).to be_not_found
      end
    end

    context 'when requested user is found' do
      it 'assigns the requested user' do
        get :index, user_id: requested_user.to_param
        expect(assigns[:requested_user]).to eql(requested_user)
      end

      context 'if the requested user is the current user' do
        it 'redirects to my/scrapbooks' do
          allow(controller).to receive(:current_user).and_return(requested_user)
          get :index, user_id: requested_user.to_param
          expect(response).to redirect_to(my_scrapbooks_path)
        end
      end

      context 'if the requested user is not the current user' do
        let(:other_user)               { Fabricate.build(:active_user, id: 456) }
        let(:scrapbooks_stub)          { double('scrapbooks') }
        let(:approved_scrapbooks_stub) { double('approved_scrapbooks') }
        let(:stub_presenter)           { double('presenter') }
        let(:stub_memory_fetcher)      { double('memory_fetcher') }

        before :each do
          allow(controller).to receive(:current_user).and_return(other_user)
          allow(requested_user).to receive(:scrapbooks).and_return(scrapbooks_stub)
          allow(scrapbooks_stub).to receive(:approved).and_return(approved_scrapbooks_stub)
          allow(approved_scrapbooks_stub).to receive(:page).and_return(approved_scrapbooks_stub)
          allow(ScrapbookIndexPresenter).to receive(:new).and_return(stub_presenter)
          allow(ApprovedScrapbookMemoryFetcher).to receive(:new).with(approved_scrapbooks_stub).and_return(stub_memory_fetcher)

          get :index, user_id: requested_user.to_param
        end

        it 'fetches approved scrapbooks for the requested user' do
          expect(requested_user).to have_received(:scrapbooks)
          expect(scrapbooks_stub).to have_received(:approved)
        end

        it "generates a ScrapbookIndexPresenter for the requested user's scrapbooks" do
          expect(ScrapbookIndexPresenter).to have_received(:new).with(approved_scrapbooks_stub, stub_memory_fetcher, nil)
        end

        it "assigns the generated presenter" do
          expect(assigns[:presenter]).to eql(stub_presenter)
        end

        it 'renders the index page' do
          expect(response).to render_template(:index)
        end
      end
    end
  end
end