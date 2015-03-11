require 'rails_helper'

describe Admin::Moderation::MemoriesController do
  it 'requires the user to be authenticated as an administrator' do
    expect(subject).to be_a(Admin::AuthenticatedAdminController)
  end

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
        expect(session[:current_memory_index_path]).to eql(admin_moderation_memories_path)
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
    let(:moderated_memories) { double('moderated_memories') }
    let(:ordered_memories)   { double('ordered_memories') }

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
        allow(moderated_memories).to receive(:by_recent).and_return(ordered_memories)
        get :moderated
      end

      it 'stores the moderated path' do
        expect(session[:current_memory_index_path]).to eql(moderated_admin_moderation_memories_path)
      end

      it 'fetches all items that need to be moderated' do
        expect(Memory).to have_received(:moderated)
      end

      it 'sorts the items with newest first' do
        expect(moderated_memories).to have_received(:by_recent)
      end

      it 'assigns the sorted items' do
        expect(assigns[:items]).to eql(ordered_memories)
      end

      it 'renders the index view' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET show' do
    let(:memory) { Fabricate.build(:photo_memory, id: 123) }

    context 'when not logged in' do
      it 'redirects to sign in' do
        get :show, id: memory.id
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in but not as an admin' do
      it 'redirects to sign in' do
        @user = Fabricate(:active_user)
        login_user
        get :show, id: memory.id
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user
      end

      it 'looks for the memory to approve' do
        allow(Memory).to receive(:find).with(memory.to_param).and_return(memory)
        get :show, id: memory.id
        expect(Memory).to have_received(:find).with(memory.to_param)
      end

      context "when memory is found" do
        before :each do
          allow(Memory).to receive(:find).with(memory.to_param).and_return(memory)
          get :show, id: memory.id
        end

        it "assigns the memory" do
          expect(assigns[:memory]).to eql(memory)
        end

        it 'renders the show page' do
          expect(response).to render_template(:show)
        end

        it 'has a 200 status' do
          expect(response.status).to eql(200)
        end
      end

      context "when memory is not found" do
        before :each do
          allow(Memory).to receive(:find).with(memory.to_param).and_raise(ActiveRecord::RecordNotFound)
          get :show, id: memory.id
        end

        it 'renders the Not Found page' do
          expect(response).to render_template('exceptions/not_found')
        end

        it 'has a 404 status' do
          expect(response.status).to eql(404)
        end
      end
    end
  end

  describe 'PUT approve' do
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
        allow(memory).to receive(:approve!).and_return(result)
      end

      it 'looks for the memory to approve' do
        allow(Memory).to receive(:find).with(memory.to_param).and_return(memory)
        put :approve, id: memory.id, format: format
        expect(Memory).to have_received(:find).with(memory.to_param)
      end

      context "when memory is found" do
        before :each do
          allow(Memory).to receive(:find).with(memory.to_param).and_return(memory)
          put :approve, id: memory.id, format: format
        end

        it "updates the memory's status to 'Approved'" do
          expect(memory).to have_received(:approve!)
        end

        context 'when an HTML request' do
          let(:format) { 'html' }

          it 'redirects to the unmoderated index page' do
            expect(response).to redirect_to(admin_moderation_memories_path)
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

      context "when memory is not found" do
        before :each do
          allow(Memory).to receive(:find).with(memory.to_param).and_raise(ActiveRecord::RecordNotFound)
          put :approve, id: memory.id, format: format
        end

        it 'has a 404 status' do
          expect(response.status).to eql(404)
        end

        context 'when an HTML request' do
          let(:format) { 'html' }

          it 'renders the Not Found page' do
            expect(response).to render_template('exceptions/not_found')
          end
        end
      end
    end
  end

  describe 'PUT reject' do
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
        allow(memory).to receive(:reject!).and_return(result)
      end

      it 'looks for the memory to reject' do
        allow(Memory).to receive(:find).with(memory.to_param).and_return(memory)
        put :reject, id: memory.id, reason: reason, format: format
        expect(Memory).to have_received(:find).with(memory.to_param)
      end

      context "when memory is found" do
        before :each do
          allow(Memory).to receive(:find).with(memory.to_param).and_return(memory)
          put :reject, id: memory.id, reason: reason, format: format
        end

        it "updates the memory's status to 'Rejected'" do
          expect(memory).to have_received(:reject!).with('unsuitable')
        end

        context 'when an HTML request' do
          let(:format) { 'html' }

          it 'redirects to the unmoderated index page' do
            expect(response).to redirect_to(admin_moderation_memories_path)
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

      context "when memory is not found" do
        before :each do
          allow(Memory).to receive(:find).with(memory.to_param).and_raise(ActiveRecord::RecordNotFound)
          put :reject, id: memory.id, reason: reason, format: format
        end

        it 'has a 404 status' do
          expect(response.status).to eql(404)
        end

        context 'when an HTML request' do
          let(:format) { 'html' }

          it 'renders the Not Found page' do
            expect(response).to render_template('exceptions/not_found')
          end
        end
      end
    end
  end

  describe 'PUT unmoderate' do
    let(:memory) { Fabricate.build(:photo_memory, id: 123) }
    let(:result) { true }
    let(:format) { 'html' }

    context 'when not logged in' do
      it 'redirects to sign in' do
        put :unmoderate, id: memory.id
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in but not as an admin' do
      it 'redirects to sign in' do
        @user = Fabricate(:active_user)
        login_user
        put :unmoderate, id: memory.id
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(memory).to receive(:unmoderate!).and_return(result)
      end

      it 'looks for the memory to unmoderate' do
        allow(Memory).to receive(:find).with(memory.to_param).and_return(memory)
        put :unmoderate, id: memory.id, format: format
        expect(Memory).to have_received(:find).with(memory.to_param)
      end

      context "when memory is found" do
        before :each do
          allow(Memory).to receive(:find).with(memory.to_param).and_return(memory)
          put :unmoderate, id: memory.id, format: format
        end

        it "updates the memory's status to 'Unmoderated'" do
          expect(memory).to have_received(:unmoderate!)
        end

        context 'when an HTML request' do
          let(:format) { 'html' }

          it 'redirects to the moderated index page' do
            expect(response).to redirect_to(moderated_admin_moderation_memories_path)
          end

          context "when successful" do
            let(:result) { true }

            it "displays a success message" do
              expect(flash[:notice]).to eql('Memory unmoderated')
            end
          end

          context "when unsuccessful" do
            let(:result) { false }

            it "displays a failure alert" do
              expect(flash[:alert]).to eql('Could not unmoderate memory')
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
              expect(response.body).to eql('Unable to unmoderate')
            end
          end
        end
      end

      context "when memory is not found" do
        before :each do
          allow(Memory).to receive(:find).with(memory.to_param).and_raise(ActiveRecord::RecordNotFound)
          put :unmoderate, id: memory.id, format: format
        end

        it 'has a 404 status' do
          expect(response.status).to eql(404)
        end

        context 'when an HTML request' do
          let(:format) { 'html' }

          it 'renders the Not Found page' do
            expect(response).to render_template('exceptions/not_found')
          end
        end
      end
    end
  end
end
