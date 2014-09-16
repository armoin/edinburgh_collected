require 'rails_helper'

describe My::ScrapbookMemoriesController do
  before :each do
    @user = Fabricate.build(:active_user)
  end

  describe 'POST create' do
    let(:scrapbooks)    { Fabricate.times(1, :scrapbook) }
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
      format: 'json'
    }}

    context 'when not logged in' do
      it 'asks user to login' do
        post :create, given_params
        expect(response).to redirect_to(:login)
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

            it "returns the scrapbook" do
              expect(response.body).to eql(scrapbook.to_json)
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
end
