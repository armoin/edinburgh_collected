require 'rails_helper'

describe TempImagesController do
  describe "POST create" do
    let(:file_path)     { File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.jpg') }
    let(:file)          { Rack::Test::UploadedFile.new(File.join(file_path)) }
    let(:temp_image)    { TempImage.new(id: 123, file: file) }
    let(:strong_params) {{ file: file }}
    let(:saved)         { true }
    let(:errors)        { {} }

    context 'when user is logged in' do
      before :each do
        @user = Fabricate.build(:active_user)
        login_user

        allow(TempImage).to receive(:new).and_return(temp_image)
        allow(temp_image).to receive(:save).and_return(saved)
        allow(temp_image).to receive(:errors).and_return(errors)

        post :create, temp_image: strong_params, format: :js
      end

      it "builds a new TempImage" do
        expect(TempImage).to have_received(:new).with(strong_params)
      end

      it "saves the new TempImage" do
        expect(temp_image).to have_received(:save)
      end

      context 'when save is successful' do
        let(:saved) { true }

        it "responds with the JSON version of the temp_image TempImage" do
          expect(response.status).to eql(200)
          expect(response.body).to eql(temp_image.to_json)
        end
      end

      context 'when save is not successful' do
        let(:saved)  { false }
        let(:errors) {
          { file: [ "Only images allowed" ] }
        }

        it "responds with a JSON error message" do
          expect(response.status).to eql(422)
          expect(response.body).to eql({errors: errors}.to_json)
        end
      end
    end
  end
end