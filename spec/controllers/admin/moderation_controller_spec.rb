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
      let(:result) { true }
      let(:format) { 'html' }

      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(Memory).to receive(:find).with(memory.to_param).and_return(memory)
        allow(memory).to receive(:approve!).and_return(result)
        put :approve, id: memory.id, format: format
      end

      it 'looks for the memory to approve' do
        expect(Memory).to have_received(:find).with(memory.to_param)
      end

      context "when memory is found" do
        it "updates the memory's status to 'Approved'" do
          expect(memory).to have_received(:approve!)
        end

        context 'when an HTML  request' do
          let(:format) { 'html' }

          it 'redirects to the moderation index page' do
            expect(response).to redirect_to(admin_moderation_path)
          end

          context "when successful" do
            let(:result) { true }

            it "displays a success message" do
              expect(flash[:notice]).to eql('Memory approved')
            end
          end

          context "when unsuccessful" do
            let(:result) { false }

            it "displays a failure alert" do
              expect(flash[:alert]).to eql('Could not approve memory')
            end
          end
        end

        context 'when a JSON request' do
          let(:format) { 'json' }

          context "when successful" do
            let(:result) { true }

            it 'provides a JSON version of the memory' do
              expect(response.body).to eql(memory.to_json)
            end
          end

          context "when unsuccessful" do
            let(:result) { false }

            it "returns an Unprocessable Entity error" do
              expect(response.status).to eql(422)
              expect(response.body).to eql('Unable to approve')
            end
          end
        end
      end
    end
  end

  describe 'PUT reject_memory' do
    let(:memory) { Fabricate.build(:photo_memory, id: 123) }
    let(:reason) { 'unsuitable' }
    let(:result) { true }
    let(:format) { 'html' }

    context 'when not logged in' do
      it 'redirects to sign in' do
        put :reject, id: memory.id, reason: reason
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in but not as an admin' do
      it 'redirects to sign in' do
        @user = Fabricate(:active_user)
        login_user
        put :reject, id: memory.id, reason: reason
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(Memory).to receive(:find).with(memory.to_param).and_return(memory)
        allow(memory).to receive(:reject!).and_return(result)
        put :reject, id: memory.id, reason: reason, format: format
      end

      it 'looks for the memory to reject' do
        expect(Memory).to have_received(:find).with(memory.to_param)
      end

      context "when memory is found" do
        it "updates the memory's status to 'Rejected'" do
          expect(memory).to have_received(:reject!).with('unsuitable')
        end

        context 'when an HTML  request' do
          let(:format) { 'html' }

          it 'redirects to the moderation index page' do
            expect(response).to redirect_to(admin_moderation_path)
          end

          context "when successful" do
            let(:result) { true }

            it "displays a success message" do
              expect(flash[:notice]).to eql('Memory rejected')
            end
          end

          context "when unsuccessful" do
            let(:result) { false }

            it "displays a failure alert" do
              expect(flash[:alert]).to eql('Could not reject memory')
            end
          end
        end

        context 'when a JSON request' do
          let(:format) { 'json' }

          context "when successful" do
            let(:result) { true }

            it 'provides a JSON version of the memory' do
              expect(response.body).to eql(memory.to_json)
            end
          end

          context "when unsuccessful" do
            let(:result) { false }

            it "returns an Unprocessable Entity error" do
              expect(response.status).to eql(422)
              expect(response.body).to eql('Unable to reject')
            end
          end
        end
      end
    end
  end
end

