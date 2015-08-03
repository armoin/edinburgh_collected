require 'rails_helper'

describe Scrapbooks::MemoriesController do
  describe 'GET show' do
    let(:format)                { :html }
    let(:scrapbook)             { Fabricate.build(:scrapbook) }
    let(:scrapbook_find_result) { scrapbook }
    let(:memory)                { Fabricate.build(:memory) }
    let(:memory_find_result)    { memory }
    let(:visible)               { false }
    let(:user)                  { Fabricate.build(:user) }
    let(:can_modify)            { false }
    let(:page)                  { '2' }

    before :each do
      allow(Scrapbook).to receive(:find) { scrapbook_find_result }
      allow(scrapbook.memories).to receive(:find) { memory_find_result }

      allow(memory).to receive(:publicly_visible?).and_return(visible)
      allow(controller).to receive(:current_user).and_return(user)
      allow(user).to receive(:can_modify?).and_return(can_modify)

      get :show, id: '123', scrapbook_id: '456', format: format, page: page
    end

    it "fetches the requested scrapbook" do
      expect(Scrapbook).to have_received(:find).with('456')
    end

    it "assigns the requested scrapbook" do
      expect(assigns[:scrapbook]).to eq(scrapbook)
    end

    it "fetches the requested memory" do
      expect(scrapbook.memories).to have_received(:find).with('123')
    end

    context "when record is found" do
      let(:memory_find_result) { memory }

      it "assigns fetched memory" do
        expect(assigns(:memory)).to eql(memory)
      end

      context 'and memory is visible' do
        let(:visible) { true }

        it "assigns page" do
          expect(assigns(:page)).to eql(page)
        end

        it_behaves_like 'a found memory'
      end

      context 'and the memory is not visible' do
        let(:visible) { false }

        context 'when there is no current user' do
          it_behaves_like 'a not found memory'
        end

        context 'and the current user' do
          context 'cannot modify the memory' do
            let(:can_modify) { false }

            it "does not assign page" do
              expect(assigns(:page)).to be_nil
            end

            it_behaves_like 'a not found memory'
          end

          context 'can modify the memory' do
            let(:can_modify) { true }

            it "assigns page" do
              expect(assigns(:page)).to eql(page)
            end

            it_behaves_like 'a found memory'
          end
        end
      end
    end

    context "when record is not found" do
      let(:memory_find_result) { raise ActiveRecord::RecordNotFound }

      it "does not assign page" do
        expect(assigns(:page)).to be_nil
      end

      it_behaves_like 'a not found memory'
    end
  end
end
