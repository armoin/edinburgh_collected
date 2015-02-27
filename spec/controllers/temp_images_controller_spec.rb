require 'rails_helper'

describe TempImagesController do
  describe "POST create" do
    let(:file_path)     { File.join(Rails.root, 'spec', 'fixtures', 'files') }
    let(:file_name)     { 'test.jpg' }
    let(:file)          { Rack::Test::UploadedFile.new(File.join(file_path, file_name)) }
    let(:created)       { TempImage.new(id: 123, file: file) }
    let(:strong_params) {{ file: file }}
    let(:given_params) {{
      temp_image: strong_params,
      controller: "temp_images",
      action: "create",
      format: :js
    }}

    context 'when user is logged in' do
      before :each do
        @user = Fabricate.build(:active_user)
        login_user
        allow(TempImage).to receive(:create).and_return(created)

        post :create, given_params
      end

      it "creates a new TempImage" do
        expect(TempImage).to have_received(:create).with(file: file)
      end

      it "responds with the JSON version of the created TempImage" do
        expect(response.body).to eql(created.to_json)
      end
    end
  end
end