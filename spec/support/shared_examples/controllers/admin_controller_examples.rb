##
# Requires a method, `perform_action` to be defined as the method under test.
#
# Example:
#     let(:perform_action) { get :index }
#
RSpec.shared_examples 'an admin only controller' do
  context "when user is not logged in" do
    it 'asks user to signin as an admin' do
      perform_action
      expect(response).to redirect_to(:signin)
      expect(flash[:alert]).to eql("You must be signed in as an administrator to do that")
    end
  end

  context "when user is logged in but not as an admin" do
    before :each do
      @user = Fabricate.build(:active_user)
      login_user
    end

    it 'asks user to signin as an admin' do
      perform_action
      expect(response).to redirect_to(:signin)
      expect(flash[:alert]).to eql("You must be signed in as an administrator to do that")
    end
  end
end
