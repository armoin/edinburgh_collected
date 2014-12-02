require 'rails_helper'

describe Admin::ModerationController do
  describe 'GET index' do
    let(:unmoderated_memories) { stub_memories(2) }

    context 'when not logged in' do
      before :each do
        get :index
      end

      it 'does not store the moderated path' do
        expect(session[:current_memory_index_path]).to be_nil
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
        expect(session[:current_memory_index_path]).to be_nil
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(Memory).to receive(:unmoderated).and_return(unmoderated_memories)
        get :index
      end

      it 'stores the index path' do
        expect(session[:current_memory_index_path]).to eql(admin_unmoderated_path)
      end

      it 'fetches all items that need to be moderated' do
        expect(Memory).to have_received(:unmoderated)
      end

      it 'assigns the unmoderated items' do
        expect(assigns[:items]).to eql(unmoderated_memories)
      end

      it 'renders the index view' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET moderated' do
    let(:older) { double('memory', last_moderated_at: 2.days.ago) }
    let(:newer) { double('memory', last_moderated_at: 1.day.ago) }
    let(:moderated_memories) { [older, newer] }

    context 'when not logged in' do
      before :each do
        get :moderated
      end

      it 'does not store the moderated path' do
        expect(session[:current_memory_index_path]).to be_nil
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
        expect(session[:current_memory_index_path]).to be_nil
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(Memory).to receive(:moderated).and_return(moderated_memories)
        get :moderated
      end

      it 'stores the moderated path' do
        expect(session[:current_memory_index_path]).to eql(admin_moderated_path)
      end

      it 'fetches all items that need to be moderated' do
        expect(Memory).to have_received(:moderated)
      end

      it 'assigns the items sorted with newest first' do
        expect(assigns[:items]).to eql([newer, older])
      end

      it 'renders the index view' do
        expect(response).to render_template(:index)
      end
    end
  end
end
