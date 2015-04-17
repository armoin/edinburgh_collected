require 'rails_helper'

describe Report::UsersController do
  let(:current_user)  { Fabricate.build(:user, id: 123) }
  let(:reported_user) { Fabricate.build(:user, id: 456) }

  describe 'GET edit' do
    describe 'ensure user is logged in' do
      before :each do
        get :edit, id: reported_user.id, format: format
      end

      it_behaves_like 'requires logged in user'
    end

    context 'when user is logged in' do
      let(:find_result) { reported_user }

      before :each do
        @user = current_user
        login_user

        allow(User).to receive(:find) { find_result }

        get :edit, id: reported_user.id, format: format
      end

      context 'and response type is html' do
        let(:format) { 'html' }

        it 'finds the user to report' do
          expect(User).to have_received(:find).with(reported_user.to_param)
        end

        context 'when reported user is found' do
          let(:find_result) { reported_user }

          it 'assigns the reported user' do
            expect(assigns[:user]).to eql(reported_user)
          end

          it 'renders the edit page' do
            expect(response.body).to render_template(:edit)
          end
        end

        context 'when the reported user is not found' do
          let(:find_result) { raise(ActiveRecord::RecordNotFound) }

          it 'is not found' do
            expect(response).to be_not_found
          end
        end
      end
    end
  end

  describe 'PUT update' do
    let(:reason)      { "I am offended!" }
    let(:user_params) { {moderation_reason: reason} }

    describe 'ensure user is logged in' do
      before :each do
        put :update, id: reported_user.id, user: user_params, format: format
      end

      it_behaves_like 'requires logged in user'
    end

    context 'when user is logged in' do
      let(:find_result) { reported_user }

      before :each do
        @user = current_user
        login_user

        allow(User).to receive(:find) { find_result }
        allow(reported_user).to receive(:report!).and_return(result)

        put :update, id: reported_user.id, user: user_params, format: format
      end

      context 'and response type is html' do
        let(:format) { 'html' }
        let(:result) { true }

        it 'finds the user to report' do
          expect(User).to have_received(:find).with(reported_user.to_param)
        end

        context 'when memory is found' do
          it 'assigns the reported user' do
            expect(assigns[:user]).to eql(reported_user)
          end

          it 'marks the user as reported with the given reason' do
            expect(reported_user).to have_received(:report!).with(current_user, reason)
          end

          context 'when report is successful' do
            let(:result) { true }

            it 'redirects to the all memories index path as the user and associated user page is no longer viewable' do
              expect(response.body).to redirect_to(memories_path)
            end

            it 'shows a success message' do
              expect(flash[:notice]).to eql('Thank you for reporting your concern.')
            end
          end

          context 'when report is not successful' do
            let(:result) { false }

            it 'renders the edit page' do
              expect(response).to render_template(:edit)
            end
          end
        end

        context 'when the memory is not found' do
          let(:find_result) { raise(ActiveRecord::RecordNotFound) }

          it 'is not found' do
            expect(response).to be_not_found
          end
        end
      end
    end
  end
end
