require 'rails_helper'

describe Admin::ModerationController do
  it 'requires the user to be authenticated as an administrator' do
    expect(subject).to be_a(Admin::AuthenticatedAdminController)
  end

  describe 'GET index' do
    let(:memories) { stub_memories(2) }

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

