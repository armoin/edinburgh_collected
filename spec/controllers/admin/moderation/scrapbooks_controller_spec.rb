require 'rails_helper'

describe Admin::Moderation::ScrapbooksController do
  let(:scrapbook) { Fabricate.build(:scrapbook, id: 123) }

  it 'requires the user to be authenticated as an administrator' do
    expect(subject).to be_a(Admin::AuthenticatedAdminController)
  end

  describe 'GET index' do
    let(:unmoderated_scrapbooks) { Array.new(2) {|i| Fabricate.build(:scrapbook, id: i+1)} }

    context 'when not logged in' do
      before :each do
        get :index
      end

      it 'does not store the moderated path' do
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in but not as an admin' do
      before :each do
        @user = Fabricate(:active_user)
        login_user
        get :index
      end

      it 'does not store the moderated path' do
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(Scrapbook).to receive(:unmoderated).and_return(unmoderated_scrapbooks)
        get :index
      end

      it 'stores the index path' do
        expect(session[:current_scrapbook_index_path]).to eql(admin_moderation_scrapbooks_path)
      end

      it 'fetches all items that need to be moderated' do
        expect(Scrapbook).to have_received(:unmoderated)
      end

      it 'assigns the unmoderated items' do
        expect(assigns[:items]).to eql(unmoderated_scrapbooks)
      end

      it 'renders the index view' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET moderated' do
    let(:moderated_scrapbooks) { double('moderated_scrapbooks') }
    let(:ordered_scrapbooks)   { double('ordered_scrapbooks') }

    context 'when not logged in' do
      before :each do
        get :moderated
      end

      it 'does not store the moderated path' do
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in but not as an admin' do
      before :each do
        @user = Fabricate(:active_user)
        login_user
        get :moderated
      end

      it 'does not store the moderated path' do
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(Scrapbook).to receive(:moderated).and_return(moderated_scrapbooks)
        allow(moderated_scrapbooks).to receive(:by_recent).and_return(ordered_scrapbooks)
        get :moderated
      end

      it 'stores the moderated path' do
        expect(session[:current_scrapbook_index_path]).to eql(moderated_admin_moderation_scrapbooks_path)
      end

      it 'fetches all items that need to be moderated' do
        expect(Scrapbook).to have_received(:moderated)
      end

      it 'sorts the items with newest first' do
        expect(moderated_scrapbooks).to have_received(:by_recent)
      end

      it 'assigns the sorted items' do
        expect(assigns[:items]).to eql(ordered_scrapbooks)
      end

      it 'renders the index view' do
        expect(response).to render_template(:index)
      end
    end
  end
end

