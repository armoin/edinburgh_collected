require 'rails_helper'

describe Report::MemoriesController do
  let(:user)   { Fabricate.build(:user, id: 123) }
  let(:memory) { Fabricate.build(:memory, id: 213, user: user) }

  describe 'GET edit' do
    describe 'ensure user is logged in' do
      before :each do
        get :edit, id: memory.id, format: format
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

        it 'finds the memory to update' do
          allow(Memory).to receive(:find).and_return(memory)
          get :edit, id: memory.id, format: format
          expect(Memory).to have_received(:find).with(memory.to_param)
        end

        context 'when memory is found' do
          before :each do
            allow(Memory).to receive(:find).and_return(memory)
            get :edit, id: memory.id, format: format
          end

          it 'assigns the memory' do
            expect(assigns[:memory]).to eql(memory)
          end

          it 'renders the edit page' do
            expect(response.body).to render_template(:edit)
          end
        end

        context 'when the memory is not found' do
          before :each do
            allow(Memory).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
            get :edit, id: memory.id, format: format
          end

          it 'is not found' do
            expect(response).to be_not_found
          end
        end
      end
    end
  end

  describe 'PUT update' do
    let(:reason)        { "I am offended!" }
    let(:memory_params) { {moderation_reason: reason} }

    describe 'ensure user is logged in' do
      before :each do
        put :update, id: memory.id, memory: memory_params, format: format
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

        it 'finds the memory to update' do
          allow(Memory).to receive(:find).and_return(memory)
          allow(memory).to receive(:report!).and_return(result)
          put :update, id: memory.id, memory: memory_params, format: format
          expect(Memory).to have_received(:find).with(memory.to_param)
        end

        context 'when memory is found' do
          let(:test_path) { '/stored/memory/index/path' }

          before :each do
            allow(Memory).to receive(:find).and_return(memory)
            allow(memory).to receive(:report!).and_return(result)
            session[:current_memory_index_path] = test_path
            put :update, id: memory.id, memory: memory_params, format: format
          end

          it 'assigns the memory' do
            expect(assigns[:memory]).to eql(memory)
          end

          it 'marks the memory as reported with the given reason' do
            expect(memory).to have_received(:report!).with(user, reason)
          end

          context 'when report is successful' do
            let(:result) { true }

            it 'redirects back to the current memory index path as the memory itself is no longer viewable' do
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

        context 'when the memory is not found' do
          before :each do
            allow(Memory).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
            put :update, id: memory.id, memory: memory_params, format: format
          end

          it 'is not found' do
            expect(response).to be_not_found
          end
        end
      end
    end
  end
end
