require 'rails_helper'

describe Admin::Moderation::MemoriesController do
  let(:memory) { Fabricate.build(:photo_memory, id: 123) }

  before :each do
    allow(Memory).to receive(:find).with(memory.to_param).and_return(memory)
  end

  it 'requires the user to be authenticated as an administrator' do
    expect(subject).to be_a(Admin::AuthenticatedAdminController)
  end

  describe 'GET show' do
    context 'when not logged in' do
      it 'redirects to sign in' do
        get :show, id: '123'
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in but not as an admin' do
      it 'redirects to sign in' do
        @user = Fabricate(:active_user)
        login_user
        get :show, id: '123'
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(Memory).to receive(:find).with('123').and_return(memory)
      end

      it 'fetches the requested memory' do
        get :show, id: '123'
        expect(Memory).to have_received(:find).with('123')
      end

      context 'when the memory is found' do
        before :each do
          allow(Memory).to receive(:find).with('123').and_return(memory)
          get :show, id: '123'
        end

        it 'assigns the memory' do
          expect(assigns[:memory]).to eql(memory)
        end

        it 'renders the show view' do
          expect(response).to render_template(:show)
        end
      end

      context 'when the memory is not found' do
        before :each do
          allow(Memory).to receive(:find).with('123').and_raise(ActiveRecord::RecordNotFound)
          get :show, id: '123'
        end

        it 'raises a 404' do
          expect(response.status).to eql(404)
        end
      end
    end
  end

  describe 'PUT approve' do
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
      let(:result)          { true }
      let(:format)          { 'html' }
      let(:previous_state)  { 'unmoderated' }

      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(memory).to receive(:approve!).and_return(result)
        allow(memory).to receive(:previous_state).and_return(previous_state)
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

          context 'when original state was "unmoderated"' do
            let(:previous_state) { 'unmoderated' }

            it 'redirects to the unmoderated index page' do
              expect(response).to redirect_to(admin_unmoderated_path)
            end
          end

          context 'when original state was not "unmoderated"' do
            let(:previous_state) { 'approved' }

            it 'redirects to the moderated index page' do
              expect(response).to redirect_to(admin_moderated_path)
            end
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

  describe 'PUT reject' do
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
      let(:previous_state)  { 'unmoderated' }

      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(memory).to receive(:reject!).and_return(result)
        allow(memory).to receive(:previous_state).and_return(previous_state)
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

          context 'when original state was "unmoderated"' do
            let(:previous_state) { 'unmoderated' }

            it 'redirects to the unmoderated index page' do
              expect(response).to redirect_to(admin_unmoderated_path)
            end
          end

          context 'when original state was not "unmoderated"' do
            let(:previous_state) { 'approved' }

            it 'redirects to the moderated index page' do
              expect(response).to redirect_to(admin_moderated_path)
            end
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

  describe 'PUT unmoderate' do
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
      let(:previous_state)  { 'unmoderated' }

      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(memory).to receive(:unmoderate!).and_return(result)
        allow(memory).to receive(:previous_state).and_return(previous_state)
        put :unmoderate, id: memory.id, format: format
      end

      it 'looks for the memory to unmoderate' do
        expect(Memory).to have_received(:find).with(memory.to_param)
      end

      context "when memory is found" do
        it "updates the memory's status to 'Unmoderated'" do
          expect(memory).to have_received(:unmoderate!)
        end

        context 'when an HTML  request' do
          let(:format) { 'html' }

          context 'when original state was "unmoderated"' do
            let(:previous_state) { 'unmoderated' }

            it 'redirects to the unmoderated index page' do
              expect(response).to redirect_to(admin_unmoderated_path)
            end
          end

          context 'when original state was not "unmoderated"' do
            let(:previous_state) { 'approved' }

            it 'redirects to the moderated index page' do
              expect(response).to redirect_to(admin_moderated_path)
            end
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
    end
  end

  describe 'GET edit' do
    context 'when not logged in' do
      it 'asks user to signin' do
        get :edit, id: 123
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in but not as an admin' do
      it 'redirects to sign in' do
        @user = Fabricate(:active_user)
        login_user
        get :edit, id: '123'
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(Memory).to receive(:find).with('123').and_return(memory)
      end

      it "fetches the requested memory" do
        get :edit, id: 123
        expect(Memory).to have_received(:find).with('123')
      end

      it "assigns fetched memory" do
        get :edit, id: 123
        expect(assigns(:memory)).to eql(memory)
      end

      context "fetch is successful" do
        it "renders the edit page" do
          get :edit, id: 123
          expect(response).to render_template(:edit)
        end
      end

      context "fetch is not successful" do
        it "renders the not found page" do
          allow(Memory).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
          get :edit, id: '123'
          expect(response).to render_template('exceptions/not_found')
        end
      end
    end
  end

  describe 'PUT upate' do
    let(:strong_params) {{ title: 'New title' }}
    let(:given_params) {{
      memory: strong_params,
      id: '123',
      controller: "admin/moderation/memories",
      action: "update"
    }}

    context 'when not logged in' do
      it 'asks user to signin' do
        put :update, given_params
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in but not as an admin' do
      it 'redirects to sign in' do
        @user = Fabricate(:active_user)
        login_user
        put :update, given_params
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(Memory).to receive(:find).with('123').and_return(memory)
        allow(MemoryParamCleaner).to receive(:clean).and_return(strong_params)
        allow(memory).to receive(:update).and_return(true)
      end

      it "cleans the given params" do
        put :update, given_params
        expect(MemoryParamCleaner).to have_received(:clean).with(given_params)
      end

      it "finds the Memory with the given id" do
        put :update, given_params
        expect(Memory).to have_received(:find).with('123')
      end

      it "assigns the memory" do
        put :update, given_params
        expect(assigns(:memory)).to eql(memory)
      end

      it "updates the given attributes" do
        put :update, given_params
        expect(memory).to have_received('update').with(strong_params)
      end

      context "update is successful" do
        it "redirects to the show page" do
          put :update, given_params
          expect(response).to redirect_to(admin_moderation_memory_path(memory.id))
        end
      end

      context "update is not successful" do
        it "re-renders the edit form" do
          allow(memory).to receive(:update).and_return(false)
          put :update, given_params
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not logged in' do
      it 'asks user to signin' do
        delete :destroy, id: '123'
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in but not as an admin' do
      it 'redirects to sign in' do
        @user = Fabricate(:active_user)
        login_user
        delete :destroy, id: '123'
        expect(response).to redirect_to(signin_path)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user
        allow(Memory).to receive(:find).with('123').and_return(memory)
        allow(memory).to receive(:destroy).and_return(true)
        delete :destroy, id: '123'
      end

      it "finds the Memory with the given id" do
        expect(Memory).to have_received(:find).with('123')
      end

      it "destroys the given attributes" do
        expect(memory).to have_received('destroy')
      end

      it "redirects to the unmoderated list page" do
        expect(response).to redirect_to(admin_unmoderated_url)
      end

      context "destroy is successful" do
        it "shows a success notice" do
          expect(flash[:notice]).to eql('Successfully deleted')
        end
      end

      context "destroy is not successful" do
        it "shows an alert" do
          allow(memory).to receive(:destroy).and_return(false)
          delete :destroy, id: '123'
          expect(flash[:alert]).to eql('Could not delete')
        end
      end
    end
  end
end

