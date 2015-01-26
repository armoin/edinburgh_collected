require 'rails_helper'

describe My::ScrapbooksController do
  let(:scrapbook) { Fabricate.build(:scrapbook, id: 123, user: @user) }
  let(:stub_scrapbooks) { double('scrapbooks', find: scrapbook) }

  before :each do
    @user = Fabricate.build(:user)
    allow(@user).to receive(:scrapbooks).and_return(stub_scrapbooks)
  end

  describe 'GET index' do
    context 'when not logged in' do
      before :each do
        get :index
      end

      it 'does not store the scrapbook index path' do
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'does not set the current memory index path' do
        expect(session[:current_memory_index_path]).to be_nil
      end

      it 'asks user to signin' do
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      before :each do
        allow(stub_scrapbooks).to receive(:page).and_return(stub_scrapbooks)
        allow(stub_scrapbooks).to receive(:per).and_return(stub_scrapbooks)
        login_user
        get :index
      end

      it 'stores the scrapbook index path' do
        expect(session[:current_scrapbook_index_path]).to eql(my_scrapbooks_path)
      end

      it 'does not set the current memory index path' do
        expect(session[:current_memory_index_path]).to be_nil
      end

      it "fetches the user's scrapbooks" do
        expect(@user).to have_received(:scrapbooks)
      end

      it "paginates the results" do
        expect(stub_scrapbooks).to have_received(:page)
      end

      it "assigns the returned scrapbooks" do
        expect(assigns[:scrapbooks]).to eql(stub_scrapbooks)
      end

      it "renders the index page" do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'POST create' do
    let(:strong_params) {{ title: 'A title' }}
    let(:given_params) {{
      scrapbook: strong_params,
      controller: 'my/scrapbooks',
      action: 'create',
      format: 'js'
    }}

    context 'when not logged in' do
      before :each do
        post :create, given_params
      end

      it 'does not store the scrapbook index path' do
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'does not set the current memory index path' do
        expect(session[:current_memory_index_path]).to be_nil
      end

      it 'asks user to signin' do
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      before :each do
        login_user
        allow(ScrapbookParamCleaner).to receive(:clean).and_return(strong_params)
        allow(Scrapbook).to receive(:new).and_return(scrapbook)
        allow(scrapbook).to receive(:user=)
        allow(scrapbook).to receive(:save).and_return(true)
        post :create, given_params
      end

      it 'does not store the scrapbook index path' do
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'does not set the current memory index path' do
        expect(session[:current_memory_index_path]).to be_nil
      end

      it "cleans the given params" do
        expect(ScrapbookParamCleaner).to have_received(:clean).with(given_params)
      end

      it "builds a new Scrapbook with the given params" do
        expect(Scrapbook).to have_received(:new).with(strong_params)
      end

      it "assigns the scrapbook" do
        expect(assigns(:scrapbook)).to eql(scrapbook)
      end

      it "assigns the current user" do
        expect(scrapbook).to have_received('user=').with(@user)
      end

      it "saves the scrapbook" do
        expect(scrapbook).to have_received(:save)
      end

      context "save is successful" do
        it "is successful" do
          expect(response.status).to eql(200)
        end

        it "renders the create javascript" do
          expect(response.body).to render_template('create')
        end
      end

      context "save is not successful" do
        let(:errors) { {title: 'is invalid'} }

        before :each do
          allow(scrapbook).to receive(:save).and_return(false)
          allow(scrapbook).to receive(:errors).and_return(errors)
          post :create, given_params
        end

        it "is not successful" do
          expect(response.status).to eql(422)
        end

        it "renders the error javascript" do
          expect(response.body).to render_template('error')
        end
      end
    end
  end

  describe 'GET edit' do
    context 'when not logged in' do
      before :each do
        get :edit, id: '123'
      end

      it 'does not store the scrapbook index path' do
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'does not set the current memory index path' do
        expect(session[:current_memory_index_path]).to be_nil
      end

      it 'asks user to signin' do
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      let(:stub_scrapbooks) { double('scrapbooks', find: scrapbook) }

      before :each do
        login_user
        allow(Scrapbook).to receive(:find).and_return(scrapbook)
      end

      it 'does not store the scrapbook index path' do
        get :edit, id: 123
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'does not set the current memory index path' do
        get :edit, id: 123
        expect(session[:current_memory_index_path]).to be_nil
      end

      it "looks for the requested scrapbook" do
        get :edit, id: 123
        expect(Scrapbook).to have_received(:find).with('123')
      end

      context "when the current user can modify the scrapbook" do
        before :each do
          allow(@user).to receive(:can_modify?).and_return(true)
          get :edit, id: 123
        end

        it "assigns the scrapbook" do
          expect(assigns[:scrapbook]).to eql(scrapbook)
        end

        it "renders the edit page" do
          expect(response).to render_template(:edit)
        end
      end

      context "when the current user cannot modify the scrapbook" do
        before :each do
          allow(@user).to receive(:can_modify?).and_return(false)
          get :edit, id: 123
        end

        it "renders the not found page" do
          expect(response).to render_template('exceptions/not_found')
        end
      end
    end
  end

  describe 'PUT upate' do
    let(:strong_params) {{
      title: 'New title',
      ordering: [],
      deleted: []
    }}
    let(:given_params) {{
      scrapbook: strong_params,
      id: '123',
      controller: "my/scrapbooks",
      action: "update"
    }}

    context 'when not logged in' do
      before :each do
        put :update, given_params
      end

      it 'does not store the scrapbook index path' do
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'does not set the current memory index path' do
        expect(session[:current_memory_index_path]).to be_nil
      end

      it 'asks user to signin' do
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      before :each do
        login_user
        allow(ScrapbookParamCleaner).to receive(:clean).and_return(strong_params)
        allow(Scrapbook).to receive(:find).and_return(scrapbook)
        allow(scrapbook).to receive(:update).and_return(true)
      end

      it 'does not store the scrapbook index path' do
        put :update, given_params
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'does not set the current memory index path' do
        put :update, given_params
        expect(session[:current_memory_index_path]).to be_nil
      end

      it "cleans the given params" do
        put :update, given_params
        expect(ScrapbookParamCleaner).to have_received(:clean)#.with(strong_params)
      end

      it "finds the Scrapbook with the given id" do
        put :update, given_params
        expect(Scrapbook).to have_received(:find).with('123')
      end

      context "when the current user can modify the scrapbook" do
        before :each do
          allow(@user).to receive(:can_modify?).and_return(true)
          put :update, given_params
        end

        it "assigns the scrapbook" do
          expect(assigns[:scrapbook]).to eql(scrapbook)
        end

        it "updates the scrapbook" do
          expect(scrapbook).to have_received('update').with(strong_params)
        end

        context "update is successful" do
          it "redirects to the scrapbook page" do
            expect(response).to redirect_to(scrapbook_path('123'))
          end
        end

        context "update is not successful" do
          it "re-renders the edit form" do
            allow(scrapbook).to receive(:update).and_return(false)
            put :update, given_params
            expect(response).to render_template(:edit)
          end
        end
      end

      context "when the current user cannot modify the scrapbook" do
        before :each do
          allow(@user).to receive(:can_modify?).and_return(false)
          put :update, given_params
        end

        it "renders the not found page" do
          expect(response).to render_template('exceptions/not_found')
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not logged in' do
      before :each do
        delete :destroy, id: '123'
      end

      it 'does not store the scrapbook index path' do
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'does not set the current memory index path' do
        expect(session[:current_memory_index_path]).to be_nil
      end

      it 'asks user to signin' do
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      before :each do
        login_user
        allow(Scrapbook).to receive(:find).and_return(scrapbook)
        allow(scrapbook).to receive(:destroy).and_return(true)
      end

      it 'does not store the scrapbook index path' do
        delete :destroy, id: '123'
        expect(session[:current_scrapbook_index_path]).to be_nil
      end

      it 'does not set the current memory index path' do
        delete :destroy, id: '123'
        expect(session[:current_memory_index_path]).to be_nil
      end

      it "finds the Scrapbook with the given id" do
        delete :destroy, id: '123'
        expect(Scrapbook).to have_received(:find).with('123')
      end

      context "when the current user can modify the scrapbook" do
        before :each do
          allow(@user).to receive(:can_modify?).and_return(true)
          session[:current_scrapbook_index_path] = '/stored/index/path'
          delete :destroy, id: '123'
        end

        it "destroys the given attributes" do
          expect(scrapbook).to have_received('destroy')
        end

        it "redirects to the current scrapbook index page" do
          expect(response).to redirect_to('/stored/index/path')
        end

        context "destroy is successful" do
          it "shows a success notice" do
            expect(flash[:notice]).to eql('Successfully deleted')
          end
        end

        context "destroy is not successful" do
          it "shows an alert" do
            allow(scrapbook).to receive(:destroy).and_return(false)
            delete :destroy, id: '123'
            expect(flash[:alert]).to eql('Could not delete')
          end
        end
      end
    end
  end
end
