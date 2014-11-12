require 'rails_helper'

describe Admin::ModerationController do
  describe 'GET index' do
    let(:unmoderated_memories) { stub_memories(2) }

    context 'when not logged in' do
      it 'redirects to sign in' do
        get :index
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in but not as an admin' do
      it 'redirects to sign in' do
        @user = Fabricate(:active_user)
        login_user
        get :index
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
      it 'redirects to sign in' do
        get :moderated
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in but not as an admin' do
      it 'redirects to sign in' do
        @user = Fabricate(:active_user)
        login_user
        get :moderated
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
