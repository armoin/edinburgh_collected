require 'rails_helper'

describe My::ScrapbookMemoriesController do
  before :each do
    @user = Fabricate.build(:active_user)
  end

  describe 'POST create' do
    let(:scrapbooks)    { Array.new(3) { Fabricate.build(:scrapbook) } }
    let(:scrapbook)     { scrapbooks.first }
    let(:memory)        { Fabricate.build(:photo_memory, id: 456) }
    let(:strong_params) {{
      scrapbook_id: scrapbook.id,
      memory_id: memory.id,
    }}
    let(:given_params)    {{
      scrapbook_memory: strong_params,
      controller: 'my/scrapbook_memories',
      action: 'create',
      format: 'js'
    }}

    context 'when not logged in' do
      it 'asks user to signin' do
        post :create, given_params
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      before :each do
        login_user
        allow(ScrapbookMemoryParamCleaner).to receive(:clean).and_return(strong_params)
        allow(@user).to receive(:scrapbooks).and_return(scrapbooks)
        allow(scrapbooks).to receive(:find).and_return(scrapbook)
        allow(Memory).to receive(:find) { memory }
        allow(scrapbook).to receive(:save).and_return(true)
        post :create, given_params
      end

      it "cleans the given params" do
        expect(ScrapbookMemoryParamCleaner).to have_received(:clean).with(given_params).once
      end

      it "finds the requested scrapbook in the user's scrapbooks" do
        expect(scrapbooks).to have_received(:find).with(scrapbook.id).at_least(:once)
      end

      context "when the scrapbook is found" do
        it "finds the memory" do
          expect(Memory).to have_received(:find).with(memory.id)
        end

        context "when memory is found" do
          it "saves the scrapbook" do
            expect(scrapbook).to have_received(:save)
          end

          context "and scrapbook saves successfully" do
            before :each do
              allow(scrapbook).to receive(:save).and_return(true)
              post :create, given_params
            end

            it "renders the create javascript" do
              expect(response.body).to render_template('create')
            end

            it "is successful" do
              expect(response).to have_http_status(:success)
            end
          end

          context "and scrapbook does not save successfully" do
            before :each do
              allow(scrapbook).to receive(:save).and_return(false)
              post :create, given_params
            end

            it "renders the error javascript" do
              expect(response.body).to render_template('error')
            end

            it "is unprocessable" do
              expect(response).to have_http_status(:unprocessable_entity)
            end
          end
        end

        context "when memory is not found" do
          it "is not found" do
            allow(Memory).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
            post :create, given_params
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context "when the scrapbook is not found" do
        it "is not found" do
          allow(scrapbooks).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
          post :create, given_params
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let(:scrapbook_memory) { Fabricate.build(:scrapbook_memory, id: 123) }
    let(:scrapbook)        { scrapbook_memory.scrapbook }

    before :each do
      allow(ScrapbookMemory).to receive(:find).and_return(scrapbook_memory)
      allow(scrapbook_memory).to receive(:destroy).and_return(true)
    end

    context 'when not logged in' do
      it 'asks user to signin' do
        delete :destroy, id: scrapbook_memory.id
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      before :each do
        @user = scrapbook.user
        login_user
        allow(controller).to receive(:current_user).and_return(@user)
      end

      context 'as the scrapbook owner' do
        before :each do
          allow(@user).to receive(:scrapbooks).and_return([scrapbook])
        end

        it "destroys the scrapbook_memory" do
          delete :destroy, id: scrapbook_memory.id
          expect(scrapbook_memory).to have_received(:destroy)
        end

        it "redirects to the scrapbook edit page" do
          delete :destroy, id: scrapbook_memory.id
          expect(response).to redirect_to(edit_my_scrapbook_path(scrapbook))
        end

        context 'when successfully destroyed' do
          it 'shows a success message' do
            allow(scrapbook_memory).to receive(:destroy).and_return(true)
            delete :destroy, id: scrapbook_memory.id
            expect(flash[:notice]).to eql('Memory successfully removed')
          end
        end

        context 'when there is an error' do
          it 'shows an error message' do
            allow(scrapbook_memory).to receive(:destroy).and_return(false)
            delete :destroy, id: scrapbook_memory.id
            expect(flash[:alert]).to eql('Could not remove memory')
          end
        end
      end

      context "as another user" do
        before :each do
          allow(@user).to receive(:scrapbooks).and_return([])
          delete :destroy, id: scrapbook_memory.id
        end

        it "redirects to the scrapbook edit page" do
          expect(response).to redirect_to(edit_my_scrapbook_path(scrapbook))
        end

        it 'shows an error message' do
          expect(flash[:alert]).to eql('Could not remove memory')
        end
      end
    end
  end
end
