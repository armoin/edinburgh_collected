require 'rails_helper'

describe Report::ScrapbooksController do
  let(:user)      { Fabricate.build(:user, id: 123) }
  let(:scrapbook) { Fabricate.build(:scrapbook, id: 213, user: user) }

  describe 'GET edit' do
    describe 'ensure user is logged in' do
      before :each do
        get :edit, id: scrapbook.id, format: format
      end

      it_behaves_like 'requires logged in user'
    end

    context 'when user is logged in' do
      before :each do
        @user = user
        login_user
      end

      context 'and response type is html' do
        let(:format) { 'html' }

        it 'finds the scrapbook to update' do
          allow(Scrapbook).to receive(:find).and_return(scrapbook)
          get :edit, id: scrapbook.id, format: format
          expect(Scrapbook).to have_received(:find).with(scrapbook.to_param)
        end

        context 'when scrapbook is found' do
          before :each do
            allow(Scrapbook).to receive(:find).and_return(scrapbook)
            get :edit, id: scrapbook.id, format: format
          end

          it 'assigns the scrapbook' do
            expect(assigns[:scrapbook]).to eql(scrapbook)
          end

          it 'renders the edit page' do
            expect(response.body).to render_template(:edit)
          end
        end

        context 'when the scrapbook is not found' do
          before :each do
            allow(Scrapbook).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
            get :edit, id: scrapbook.id, format: format
          end

          it 'is not found' do
            expect(response).to be_not_found
          end
        end
      end
    end
  end

  describe 'PUT update' do
    let(:reason)           { "I am offended!" }
    let(:scrapbook_params) { {moderation_reason: reason} }

    describe 'ensure user is logged in' do
      before :each do
        put :update, id: scrapbook.id, scrapbook: scrapbook_params, format: format
      end

      it_behaves_like 'requires logged in user'
    end

    context 'when user is logged in' do
      before :each do
        @user = user
        login_user
      end

      context 'and response type is html' do
        let(:format) { 'html' }
        let(:result) { true }

        it 'finds the scrapbook to update' do
          allow(Scrapbook).to receive(:find).and_return(scrapbook)
          allow(scrapbook).to receive(:report!).and_return(result)
          put :update, id: scrapbook.id, scrapbook: scrapbook_params, format: format
          expect(Scrapbook).to have_received(:find).with(scrapbook.to_param)
        end

        context 'when scrapbook is found' do
          let(:test_path) { '/stored/scrapbook/index/path' }

          before :each do
            allow(Scrapbook).to receive(:find).and_return(scrapbook)
            allow(scrapbook).to receive(:report!).and_return(result)
            session[:current_scrapbook_index_path] = test_path
            put :update, id: scrapbook.id, scrapbook: scrapbook_params, format: format
          end

          it 'assigns the scrapbook' do
            expect(assigns[:scrapbook]).to eql(scrapbook)
          end

          it 'marks the scrapbook as reported with the given reason' do
            expect(scrapbook).to have_received(:report!).with(user, reason)
          end

          context 'when report is successful' do
            let(:result) { true }

            it 'redirects back to the current scrapbook index path as the scrapbook itself is no longer viewable' do
              expect(response.body).to redirect_to(test_path)
            end

            it 'shows a success message' do
              expect(flash[:notice]).to eql('Thank you for reporting your concern.')
            end
          end

          context 'when report is not successful' do
            let(:result) { false }

            it 'renders the edit page' do
              expect(response.body).to render_template(:edit)
            end
          end
        end

        context 'when the scrapbook is not found' do
          before :each do
            allow(Scrapbook).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
            put :update, id: scrapbook.id, scrapbook: scrapbook_params, format: format
          end

          it 'is not found' do
            expect(response).to be_not_found
          end
        end
      end
    end
  end
end
