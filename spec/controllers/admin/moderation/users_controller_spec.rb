require 'rails_helper'

describe Admin::Moderation::UsersController do
  it 'requires the user to be authenticated as an administrator' do
    expect(subject).to be_a(Admin::AuthenticatedAdminController)
  end

  describe 'GET index' do
    let(:all_users)     { double('all_users') }
    let(:ordered_users) { double('ordered_users') }

    context 'current user must be an admin' do
      let(:perform_action) { get :index }

      it_behaves_like 'an admin only controller'
    end

    context 'when logged in as an admin' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user

        allow(User).to receive(:all).and_return(all_users)
        allow(all_users).to receive(:order).and_return(ordered_users)

        get :index
      end

      it 'fetches all items' do
        expect(User).to have_received(:all)
      end

      it 'sorts the items with first created first' do
        expect(all_users).to have_received(:order).with('created_at')
      end

      it 'assigns the ordered items' do
        expect(assigns[:items]).to eql(ordered_users)
      end

      it 'renders the index view' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET unmoderated' do
    let(:unmoderated_users) { double('unmoderated_users') }
    let(:ordered_users)     { double('ordered_users') }

    context 'current user must be an admin' do
      let(:perform_action) { get :unmoderated }

      it_behaves_like 'an admin only controller'
    end

    context 'when logged in as an admin' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user

        allow(User).to receive(:unmoderated).and_return(unmoderated_users)
        allow(unmoderated_users).to receive(:order).and_return(ordered_users)

        get :unmoderated
      end

      it 'fetches all items that need to be moderated' do
        expect(User).to have_received(:unmoderated)
      end

      it 'sorts the items with first created first' do
        expect(unmoderated_users).to have_received(:order).with('created_at')
      end

      it 'assigns the ordered items' do
        expect(assigns[:items]).to eql(ordered_users)
      end

      it 'renders the index view' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET blocked' do
    let(:blocked_users) { double('blocked_users') }
    let(:ordered_users) { double('ordered_users') }

    context 'current user must be an admin' do
      let(:perform_action) { get :blocked }

      it_behaves_like 'an admin only controller'
    end

    context 'when logged in as an admin' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user

        allow(User).to receive(:blocked).and_return(blocked_users)
        allow(blocked_users).to receive(:by_last_moderated).and_return(ordered_users)

        get :blocked
      end

      it 'fetches all items that need to be blocked' do
        expect(User).to have_received(:blocked)
      end

      it 'sorts the items with last moderated first' do
        expect(blocked_users).to have_received(:by_last_moderated)
      end

      it 'assigns the sorted items' do
        expect(assigns[:items]).to eql(ordered_users)
      end

      it 'renders the index view' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET reported' do
    let(:reported_users) { double('reported_users') }
    let(:ordered_users)  { double('ordered_users') }

    context 'current user must be an admin' do
      let(:perform_action) { get :reported }

      it_behaves_like 'an admin only controller'
    end

    context 'when logged in as an admin' do
      before :each do
        @user = Fabricate(:admin_user)
        login_user

        allow(User).to receive(:reported).and_return(reported_users)
        allow(reported_users).to receive(:by_first_moderated).and_return(ordered_users)

        get :reported
      end

      it 'fetches all items that need to be reported' do
        expect(User).to have_received(:reported)
      end

      it 'sorts the items with oldest report first' do
        expect(reported_users).to have_received(:by_first_moderated)
      end

      it 'assigns the sorted items' do
        expect(assigns[:items]).to eql(ordered_users)
      end

      it 'renders the index view' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET show' do
    let(:requested_user) { Fabricate.build(:user, id: 123) }

    context 'current user must be an admin' do
      let(:perform_action) { get :show, id: requested_user.id }

      before :each do
        allow(User).to receive(:find)
      end

      it_behaves_like 'an admin only controller'
    end

    context 'when logged in as an admin' do
      let(:find_result) { requested_user }

      before :each do
        @user = Fabricate(:admin_user)
        login_user

        allow(User).to receive(:find).with(requested_user.to_param) { find_result }

        get :show, id: requested_user.id
      end

      it 'looks for the requested user' do
        expect(User).to have_received(:find).with(requested_user.to_param)
      end

      context "when user is found" do
        let(:find_result) { requested_user }

        it "assigns the user" do
          expect(assigns[:user]).to eql(requested_user)
        end

        it 'renders the show page' do
          expect(response).to render_template(:show)
        end

        it 'has a 200 status' do
          expect(response.status).to eql(200)
        end
      end

      context "when user is not found" do
        let(:find_result) { raise(ActiveRecord::RecordNotFound) }
        it 'renders the Not Found page' do
          expect(response).to render_template('exceptions/not_found')
        end

        it 'has a 404 status' do
          expect(response.status).to eql(404)
        end
      end
    end
  end

  describe 'PUT block' do
    let(:requested_user) { Fabricate.build(:active_user, id: 123) }

    context 'user must be an admin' do
      let(:perform_action) { put :block, id: requested_user.id }

      before do
        allow(User).to receive(:find) { requested_user }
        allow(requested_user).to receive(:block!)
      end

      it_behaves_like 'an admin only controller'
    end

    context 'when the admin is signed in' do
      let(:find_result)  { requested_user }
      let(:block_result) { true }

      before :each do
        @user = Fabricate.build(:admin_user, id: 789)
        login_user
        allow(User).to receive(:find) { find_result }
        allow(requested_user).to receive(:block!) { block_result }
        put :block, id: requested_user.id
      end

      it 'fetches the requested user' do
        expect(User).to have_received(:find).with('123')
      end

      context 'when the user is found' do
        context 'and the requested user is not the current user' do
          let(:find_result) { requested_user }

          it 'assigns the requested user' do
            expect(assigns[:user]).to eql(requested_user)
          end

          it 'blocks the user' do
            expect(requested_user).to have_received(:block!)
          end

          context 'when user is successfully blocked' do
            let(:block_result) { true }

            it 'shows a success message' do
              expect(flash[:notice]).to eql("User #{requested_user.screen_name} has been blocked.")
            end

            it 'redirects to the show page' do
              expect(response).to redirect_to(admin_moderation_user_path(requested_user))
            end
          end

          context 'when user is not successfully blocked' do
            let(:block_result) { false }

            it 'shows a failure alert' do
              expect(flash[:alert]).to eql("User #{requested_user.screen_name} could not be blocked.")
            end

            it 'redirects to the show page' do
              expect(response).to redirect_to(admin_moderation_user_path(requested_user))
            end
          end
        end

        context 'and the current user is the requested user' do
          let(:find_result) { @user }

          it 'redirects to the show page' do
            expect(response).to redirect_to(admin_moderation_user_path(@user))
          end

          it 'shows an error' do
            expect(flash[:alert]).to eql("You can't block your own account.")
          end
        end
      end

      context 'when the user is not found' do
        let(:find_result) { raise(ActiveRecord::RecordNotFound) }

        it 'is not found' do
          expect(response).to be_not_found
        end
      end
    end
  end

  describe 'PUT unblock' do
    let(:requested_user) { Fabricate.build(:blocked_user, id: 123) }

    context 'user must be an admin' do
      let(:perform_action) { put :unblock, id: requested_user.id }

      before do
        allow(User).to receive(:find) { requested_user }
        allow(requested_user).to receive(:unblock!)
      end

      it_behaves_like 'an admin only controller'
    end

    context 'when the admin is signed in' do
      let(:find_result)  { requested_user }
      let(:unblock_result) { true }

      before :each do
        @user = Fabricate.build(:admin_user, id: 789)
        login_user
        allow(User).to receive(:find) { find_result }
        allow(requested_user).to receive(:unblock!) { unblock_result }
        put :unblock, id: requested_user.id
      end

      it 'fetches the requested user' do
        expect(User).to have_received(:find).with('123')
      end

      context 'when the user is found' do
        context 'and the requested user is not the current user' do
          let(:find_result) { requested_user }

          it 'assigns the requested user' do
            expect(assigns[:user]).to eql(requested_user)
          end

          it 'unblocks the user' do
            expect(requested_user).to have_received(:unblock!)
          end

          context 'when user is successfully unblocked' do
            let(:unblock_result) { true }

            it 'shows a success message' do
              expect(flash[:notice]).to eql("User #{requested_user.screen_name} has been unblocked.")
            end

            it 'redirects to the show page' do
              expect(response).to redirect_to(admin_moderation_user_path(requested_user))
            end
          end

          context 'when user is not successfully unblocked' do
            let(:unblock_result) { false }

            it 'shows a failure alert' do
              expect(flash[:alert]).to eql("User #{requested_user.screen_name} could not be unblocked.")
            end

            it 'redirects to the show page' do
              expect(response).to redirect_to(admin_moderation_user_path(requested_user))
            end
          end
        end

        context 'and the current user is the requested user' do
          let(:find_result) { @user }

          it 'redirects to the show page' do
            expect(response).to redirect_to(admin_moderation_user_path(@user))
          end

          it 'shows an error' do
            expect(flash[:alert]).to eql("You can't unblock your own account.")
          end
        end
      end

      context 'when the user is not found' do
        let(:find_result) { raise(ActiveRecord::RecordNotFound) }

        it 'is not found' do
          expect(response).to be_not_found
        end
      end
    end
  end
end
