require 'rails_helper'

describe Admin::ModerationController do
  it 'requires the user to be authenticated as an administrator' do
    expect(subject).to be_a(Admin::AuthenticatedAdminController)
  end

  describe 'GET index' do
    let(:memories) { stub_memories(2) }

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
        allow(Memory).to receive(:unmoderated).and_return(memories)
      end

      it 'fetches all memories that need to be moderated' do
        get :index
        expect(Memory).to have_received(:unmoderated)
      end

      it 'assigns the unmoderated memories' do
        get :index
        expect(assigns[:memories]).to eql(memories)
      end

      it 'renders the index view' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'PUT approve_memory' do
    let(:memory) { Fabricate.build(:photo_memory, id: 123) }

    context 'when not logged in' do
      it 'redirects to sign in' do
        put :approve, id: memory.id
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in but not as an admin' do
      it 'redirects to sign in' do
        @user = Fabricate(:active_user)
        login_user
        put :approve, id: memory.id
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(Memory).to receive(:find).with(memory.to_param).and_return(memory)
        allow(memory).to receive(:approve!).and_return(true)
      end

      it 'looks for the memory to approve' do
        put :approve, id: memory.id
        expect(Memory).to have_received(:find).with(memory.to_param)
      end

      context "when memory is found" do
        it "updates the memory's status to 'Approved'" do
          put :approve, id: memory.id
          expect(memory).to have_received(:approve!)
        end

        it 'redirects to the moderation index page' do
          put :approve, id: memory.id
          expect(response).to redirect_to(admin_moderation_path)
        end

        context "when successful" do
          it "displays a success message" do
            allow(memory).to receive(:approve!).and_return(true)
            put :approve, id: memory.id
            expect(flash[:notice]).to eql('Memory approved')
          end
        end

        context "when unsuccessful" do
          it "displays a failure alert" do
            allow(memory).to receive(:approve!).and_return(false)
            put :approve, id: memory.id
            expect(flash[:alert]).to eql('Could not approve memory')
          end
        end
      end
    end
  end
end

