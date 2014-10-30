require 'rails_helper'

describe My::MemoriesController do
  let(:stub_memories) { double('memories', find: memory, by_recent: true) }
  let(:memory)        { Fabricate.build(:photo_memory, id: 123, user: @user) }

  before :each do
    @user = Fabricate.build(:user)
    allow(@user).to receive(:memories).and_return(stub_memories)
    allow(stub_memories).to receive(:by_recent).and_return(stub_memories)
  end

  describe 'GET index' do
    context 'when not logged in' do
      it 'asks user to signin' do
        get :index
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      before :each do
        login_user
        get :index
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it "fetches the user's memories" do
        expect(@user).to have_received(:memories)
      end

      it "orders by most recent first" do
        expect(stub_memories).to have_received(:by_recent)
      end

      it "assigns the returned memories" do
        expect(assigns[:memories]).to eql(stub_memories)
      end

      it "renders the index page" do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET show' do
    context 'when not logged in' do
      it 'asks user to sign in' do
        get :show, id: 123
        expect(response).to redirect_to(:signin)
      end
    end

    context "when logged in" do
      before :each do
        login_user
        get :show, id: 123
      end

      it "is successful" do
        expect(response).to be_success
        expect(response.status).to eql(200)
      end

      it "fetches the requested memory" do
        expect(stub_memories).to have_received(:find).with('123')
      end

      it "assigns fetched memory" do
        expect(assigns(:memory)).to eql(memory)
      end

      context "fetch is successful" do
        it "renders the show page" do
          expect(response).to render_template(:show)
        end
      end

      context "fetch is not successful" do
        it "renders the not found page" do
          allow(stub_memories).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
          get :show, id: '123'
          expect(response).to render_template('exceptions/not_found')
        end
      end
    end
  end

  describe 'GET new' do
    context 'when not logged in' do
      it 'asks user to sign in' do
        get :new
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      before :each do
        login_user
        get :new
      end

      it "assigns a new Memory" do
        expect(assigns(:memory)).to be_a(Memory)
      end

      it "is successful" do
        expect(response).to be_success
        expect(response.status).to eql(200)
      end

      it "renders the new page" do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST create' do
    let(:strong_params) {{ title: 'A title' }}
    let(:given_params) {{
      memory: strong_params,
      controller: "my/memories",
      action: "create"
    }}

    context 'when not logged in' do
      it 'asks user to signin' do
        post :create, given_params
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      before :each do
        login_user
        allow(MemoryParamCleaner).to receive(:clean).and_return(strong_params)
        allow(Memory).to receive(:new).and_return(memory)
        allow(memory).to receive(:user=)
        allow(memory).to receive(:save).and_return(true)
        post :create, given_params
      end

      it "cleans the given params" do
        expect(MemoryParamCleaner).to have_received(:clean).with(given_params)
      end

      it "builds a new Memory with the given params" do
        expect(Memory).to have_received(:new).with(strong_params)
      end

      it "assigns the memory" do
        expect(assigns(:memory)).to eql(memory)
      end

      it "assigns the current user" do
        expect(memory).to have_received('user=').with(@user)
      end

      it "saves the Memory" do
        expect(memory).to have_received(:save)
      end

      context "save is successful" do
        context "when save and add another" do
          it "redirects to the new page" do
            post :create, given_params.merge(commit: 'Save And Add Another')
            expect(response).to redirect_to(new_my_memory_url)
          end
        end

        context "when save" do
          it "redirects to the user's memories page" do
            post :create, given_params.merge(commit: 'Save')
            expect(response).to redirect_to(my_memories_url)
          end
        end
      end

      context "save is not successful" do
        it "re-renders the new form" do
          allow(memory).to receive(:save).and_return(false)
          post :create, given_params
          expect(response).to render_template(:new)
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

    context "when logged in" do
      before :each do
        login_user
        get :edit, id: 123
      end

      it "is successful" do
        expect(response).to be_success
        expect(response.status).to eql(200)
      end

      it "fetches the requested memory" do
        expect(stub_memories).to have_received(:find).with('123')
      end

      it "assigns fetched memory" do
        expect(assigns(:memory)).to eql(memory)
      end

      context "fetch is successful" do
        it "renders the edit page" do
          expect(response).to render_template(:edit)
        end
      end

      context "fetch is not successful" do
        it "renders the not found page" do
          allow(stub_memories).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
          get :show, id: '123'
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
      controller: "my/memories",
      action: "update"
    }}


    context 'when not logged in' do
      it 'asks user to signin' do
        put :update, given_params
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      before :each do
        login_user
        allow(MemoryParamCleaner).to receive(:clean).and_return(strong_params)
        allow(stub_memories).to receive(:find).and_return(memory)
        allow(memory).to receive(:update_attributes).and_return(true)
        put :update, given_params
      end

      it "cleans the given params" do
        expect(MemoryParamCleaner).to have_received(:clean).with(given_params)
      end

      it "finds the Memory with the given id" do
        expect(stub_memories).to have_received(:find).with('123')
      end

      it "assigns the memory" do
        expect(assigns(:memory)).to eql(memory)
      end

      it "updates the given attributes" do
        expect(memory).to have_received('update_attributes').with(strong_params)
      end

      context "update is successful" do
        it "redirects to the user's memories page" do
          expect(response).to redirect_to(my_memories_url)
        end
      end

      context "update is not successful" do
        it "re-renders the edit form" do
          allow(memory).to receive(:update_attributes).and_return(false)
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

    context 'when logged in' do
      before :each do
        login_user
        allow(stub_memories).to receive(:find).and_return(memory)
        allow(memory).to receive(:destroy).and_return(true)
        delete :destroy, id: '123'
      end

      it "finds the Memory with the given id" do
        expect(stub_memories).to have_received(:find).with('123')
      end

      it "destroys the given attributes" do
        expect(memory).to have_received('destroy')
      end

      it "redirects to the user's memories page" do
        expect(response).to redirect_to(my_memories_url)
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

