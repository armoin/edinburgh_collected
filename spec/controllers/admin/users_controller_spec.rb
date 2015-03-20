require 'rails_helper'

describe Admin::UsersController do
  describe 'GET index' do
    context 'user must be an admin' do
      let(:perform_action) { get :index }

      it_behaves_like 'an admin only controller'
    end

    context 'when the user is signed in as an admin' do
      let(:users)         { double('users') }
      let(:ordered_users) { Array.new(3) {|i| Fabricate.build(:user, id: i+1)} }

      before :each do
        @user = Fabricate.build(:admin_user, id: 789)
        login_user
        allow(User).to receive(:all).and_return(users)
        allow(users).to receive(:order).and_return(ordered_users)
        get :index
      end

      it 'fetches all users' do
        expect(User).to have_received(:all)
      end

      it 'orders them by screen_name' do
        expect(users).to have_received(:order).with('screen_name')
      end

      it 'assigns the ordered users' do
        expect(assigns[:users]).to eql(ordered_users)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET blocked' do
    context 'user must be an admin' do
      let(:perform_action) { get :blocked }

      it_behaves_like 'an admin only controller'
    end

    context 'when the user is signed in as an admin' do
      let(:users)         { double('users') }
      let(:ordered_users) { Array.new(3) {|i| Fabricate.build(:user, id: i+1)} }

      before :each do
        @user = Fabricate.build(:admin_user, id: 789)
        login_user
        allow(User).to receive(:blocked).and_return(users)
        allow(users).to receive(:order).and_return(ordered_users)
        get :blocked
      end

      it 'fetches only blocked users' do
        expect(User).to have_received(:blocked)
      end

      it 'orders them by screen_name' do
        expect(users).to have_received(:order).with('screen_name')
      end

      it 'assigns the ordered users' do
        expect(assigns[:users]).to eql(ordered_users)
      end

      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET show' do
    let(:requested_user) { Fabricate.build(:active_user, id: 123) }

    context 'user must be an admin' do
      let(:perform_action) { get :show, id: requested_user.id }

      before do
        allow(User).to receive(:find)
      end

      it_behaves_like 'an admin only controller'
    end

    context 'when the admin is signed in' do
      let(:find_result) { requested_user }

      before :each do
        @user = Fabricate.build(:admin_user, id: 789)
        login_user
        allow(User).to receive(:find) { find_result }
        get :show, id: requested_user.id
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

          it 'renders the profile page' do
            expect(response).to render_template(:show)
          end
        end

        context 'and the requested user is the current user' do
          let(:find_result) { @user }

          it 'assigns the requested user' do
            expect(assigns[:user]).to eql(@user)
          end

          it 'renders the profile page' do
            expect(response).to render_template(:show)
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
              expect(response).to redirect_to(admin_user_path(requested_user))
            end
          end

          context 'when user is not successfully blocked' do
            let(:block_result) { false }

            it 'shows a failure alert' do
              expect(flash[:alert]).to eql("User #{requested_user.screen_name} could not be blocked.")
            end

            it 'redirects to the show page' do
              expect(response).to redirect_to(admin_user_path(requested_user))
            end
          end
        end

        context 'and the current user is the requested user' do
          let(:find_result) { @user }

          it 'redirects to the show page' do
            expect(response).to redirect_to(admin_user_path(@user))
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
              expect(response).to redirect_to(admin_user_path(requested_user))
            end
          end

          context 'when user is not successfully unblocked' do
            let(:unblock_result) { false }

            it 'shows a failure alert' do
              expect(flash[:alert]).to eql("User #{requested_user.screen_name} could not be unblocked.")
            end

            it 'redirects to the show page' do
              expect(response).to redirect_to(admin_user_path(requested_user))
            end
          end
        end

        context 'and the current user is the requested user' do
          let(:find_result) { @user }

          it 'redirects to the show page' do
            expect(response).to redirect_to(admin_user_path(@user))
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