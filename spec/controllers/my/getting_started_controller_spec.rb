require 'rails_helper'

describe My::GettingStartedController do
  describe 'GET index' do
    describe 'ensure user is logged in' do
      before :each do
        get :index, format: format
      end

      it_behaves_like 'requires logged in user'
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate.build(:user)
        login_user

        get :index
      end

      it 'displays the getting started page' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'PATCH skip_getting_started' do
    describe 'ensure user is logged in' do
      before :each do
        patch :skip_getting_started, format: format
      end

      it_behaves_like 'requires logged in user'
    end

    context 'when logged in' do
      let(:result)               { true }
      let(:hide_getting_started) { false }
      let(:user_params)          { {hide_getting_started: hide_getting_started} }

      before :each do
        @user = Fabricate.build(:active_user)
        login_user

        allow(@user).to receive(:update).and_return(result)
        allow(@user).to receive(:hide_getting_started?).and_return(hide_getting_started)

        patch :skip_getting_started, user: user_params
      end

      context 'when hide_getting_started is set to false' do
        let(:hide_getting_started) { false }

        it 'updates the hide_getting_started value to false' do
          expect(@user).to have_received(:update).with({ hide_getting_started: false })
        end
      end

      context 'when hide_getting_started is set to true' do
        let(:hide_getting_started) { true }

        it 'updates the hide_getting_started value to true' do
          expect(@user).to have_received(:update).with({ hide_getting_started: true })
        end
      end

      context 'when successfully updated' do
        let(:result) { true }

        context 'and the user has not asked to hide the getting started page' do
          let(:hide_getting_started) { false }

          it 'shows the success message' do
            expect(flash[:notice]).to eql("You can access the Getting Started page from the My account menu at any time.")
          end
        end

        context 'and the user has asked to hide the getting started page' do
          let(:hide_getting_started) { true }

          it 'tells the user that the getting started page will not be shown again' do
            expect(flash[:notice]).to eql("Got it. We'll not show you the Getting Started page when you log in. You can access the Getting Started page from the My account menu at any time.")
          end
        end

        it 'redirects to the my memories page' do
          expect(response).to redirect_to(my_memories_path)
        end
      end

      context 'when unsuccessful' do
        let(:result) { false }

        it 'redirects to the my memories page' do
          expect(response).to redirect_to(my_memories_path)
        end

        it 'does not show a success notice' do
          expect(flash[:notice]).to be_nil
        end
      end
    end
  end
end