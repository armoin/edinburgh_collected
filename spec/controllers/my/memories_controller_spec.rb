require 'rails_helper'

describe My::MemoriesController do
  before { @user = Fabricate.build(:user) }

  describe 'GET index' do
    context 'when not logged in' do
      it 'asks user to login' do
        get :index
        expect(response).to redirect_to(:login)
      end
    end

    context 'when logged in' do
      let(:stub_memories) { double('memories') }

      before :each do
        login_user
        allow(@user).to receive(:memories).and_return(stub_memories)
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
      let(:memory_stub)  { double('memory', 'user=' => true) }

      before :each do
        login_user
        allow(Memory).to receive(:new).and_return(memory_stub)
        allow(memory_stub).to receive(:save).and_return(true)
        post :create, memory: memory_params
      end

      it "builds a new Memory with the given params" do
        expect(Memory).to have_received(:new).with(memory_params)
      end

      it "assigns the memory" do
        expect(assigns(:memory)).to eql(memory_stub)
      end

      it "assigns the current user" do
        expect(memory_stub).to have_received('user=').with(@user)
      end

      it "saves the Memory" do
        expect(memory_stub).to have_received(:save)
      end

      context "save is successful" do
        it "redirects to the user's memories page" do
          expect(response).to redirect_to(my_memories_url)
        end
      end

      context "save is not successful" do
        it "re-renders the new form" do
          allow(memory_stub).to receive(:save).and_return(false)
          post :create, memory: memory_params
          expect(response).to render_template(:new)
        end
      end
    end
  end
end

