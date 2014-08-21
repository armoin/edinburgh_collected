require 'rails_helper'

describe My::MemoriesController do
  let(:stub_memories) { double('memories', find: memory) }
  let(:memory)        { Fabricate.build(:photo_memory, id: 123, user: @user) }

  before :each do
    @user = Fabricate.build(:user)
    allow(@user).to receive(:memories).and_return(stub_memories)
  end

  describe 'GET index' do
    context 'when not logged in' do
      it 'asks user to login' do
        get :index
        expect(response).to redirect_to(:login)
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
      it 'asks user to login' do
        get :show, id: 123
        expect(response).to redirect_to(:login)
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
      it 'asks user to login' do
        get :new
        expect(response).to redirect_to(:login)
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
    let(:memory_params) {{ title: 'A title' }}

    context 'when not logged in' do
      it 'asks user to login' do
        post :create, memory: memory_params
        expect(response).to redirect_to(:login)
      end
    end

    context 'when logged in' do
      before :each do
        login_user
        allow(Memory).to receive(:new).and_return(memory)
        allow(memory).to receive(:user=)
        allow(memory).to receive(:save).and_return(true)
        post :create, memory: memory_params
      end

      it "builds a new Memory with the given params" do
        expect(Memory).to have_received(:new).with(memory_params)
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
            post :create, memory: memory_params, commit: 'Save And Add Another'
            expect(response).to redirect_to(new_my_memory_url)
          end
        end

        context "when save" do
          it "redirects to the user's memories page" do
            post :create, memory: memory_params, commit: 'Save'
            expect(response).to redirect_to(my_memories_url)
          end
        end
      end

      context "save is not successful" do
        it "re-renders the new form" do
          allow(memory).to receive(:save).and_return(false)
          post :create, memory: memory_params
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'GET edit' do
    context 'when not logged in' do
      it 'asks user to login' do
        get :edit, id: 123
        expect(response).to redirect_to(:login)
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
    let(:memory_params) {{ title: 'New title' }}

    context 'when not logged in' do
      it 'asks user to login' do
        put :update, id: '123', memory: memory_params
        expect(response).to redirect_to(:login)
      end
    end

    context 'when logged in' do
      before :each do
        login_user
        allow(stub_memories).to receive(:find).and_return(memory)
        allow(memory).to receive(:update_attributes).and_return(true)
        put :update, id: '123', memory: memory_params
      end

      it "finds the Memory with the given id" do
        expect(stub_memories).to have_received(:find).with('123')
      end

      it "assigns the memory" do
        expect(assigns(:memory)).to eql(memory)
      end

      it "updates the given attributes" do
        expect(memory).to have_received('update_attributes').with(memory_params)
      end

      context "update is successful" do
        it "redirects to the user's memories page" do
          expect(response).to redirect_to(my_memories_url)
        end
      end

      context "update is not successful" do
        it "re-renders the edit form" do
          allow(memory).to receive(:update_attributes).and_return(false)
          put :update, id: '123', memory: memory_params
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not logged in' do
      it 'asks user to login' do
        delete :destroy, id: '123'
        expect(response).to redirect_to(:login)
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

