require 'rails_helper'

describe Admin::UsersController do
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
        let(:find_result) { requested_user }

        it 'assigns the requested user' do
          expect(assigns[:user]).to eql(requested_user)
        end

        it 'renders the profile page' do
          expect(response).to render_template(:show)
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

      context 'when the user is not found' do
        let(:find_result) { raise(ActiveRecord::RecordNotFound) }

        it 'is not found' do
          expect(response).to be_not_found
        end
      end
    end
  end
end