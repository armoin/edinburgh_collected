require 'rails_helper'

describe My::ScrapbooksController do
  let(:scrapbook) { Fabricate.build(:scrapbook, id: 123, user: @user) }
  let(:stub_scrapbooks) { double('scrapbooks', find: scrapbook) }

  before :each do
    @user = Fabricate.build(:user)
    allow(@user).to receive(:scrapbooks).and_return(stub_scrapbooks)
  end

  describe 'POST create' do
    let(:strong_params) {{ title: 'A title' }}
    let(:given_params) {{
      scrapbook: strong_params,
      controller: 'my/scrapbooks',
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
        allow(ScrapbookParamCleaner).to receive(:clean).and_return(strong_params)
        allow(Scrapbook).to receive(:new).and_return(scrapbook)
        allow(scrapbook).to receive(:user=)
        allow(scrapbook).to receive(:save).and_return(true)
        post :create, given_params
      end

      it "cleans the given params" do
        expect(ScrapbookParamCleaner).to have_received(:clean).with(given_params)
      end

      it "builds a new Scrapbook with the given params" do
        expect(Scrapbook).to have_received(:new).with(strong_params)
      end

      it "assigns the scrapbook" do
        expect(assigns(:scrapbook)).to eql(scrapbook)
      end

      it "assigns the current user" do
        expect(scrapbook).to have_received('user=').with(@user)
      end

      it "saves the scrapbook" do
        expect(scrapbook).to have_received(:save)
      end

      context "save is successful" do
        it "is successful" do
          expect(response.status).to eql(200)
        end

        it "returns the scrapbook" do
          expect(response.body).to eql(scrapbook.to_json)
        end
      end

      context "save is not successful" do
        let(:errors) { {title: 'is invalid'} }

        before :each do
          allow(scrapbook).to receive(:save).and_return(false)
          allow(scrapbook).to receive(:errors).and_return(errors)
          post :create, given_params
        end

        it "is not successful" do
          expect(response.status).to eql(422)
        end

        it "returns the scrapbook with errors" do
          expect(response.body).to eql(errors.to_json)
        end
      end
    end
  end
end
