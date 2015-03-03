require 'rails_helper'
require 'carrierwave/test/matchers'

describe TempImageFileUploader, slow: true do
  include CarrierWave::Test::Matchers

  let(:temp_image)   { TempImage.new(id: 123) }
  let(:model_name)   { 'temp_image' }
  let(:filename)     { 'test.jpg' }
  let(:path_to_file) { File.join(Rails.root, 'spec', 'fixtures', 'files', filename) }
  let(:uploader)     { TempImageFileUploader.new(temp_image, :file) }

  after do
    uploader.remove!
  end

  describe 'without processing' do
    it_behaves_like 'a base image uploader'

    describe "#fix_exif_rotation" do
      let(:image_stub) { double('image') }

      it "calls auto_orient" do
        allow(uploader).to receive(:manipulate!).and_yield(image_stub)
        allow(image_stub).to receive(:auto_orient)
        uploader.fix_exif_rotation
        expect(image_stub).to have_received(:auto_orient).with(no_args)
      end
    end
  end

  describe 'with processing' do
    before do
      TempImageFileUploader.enable_processing = true

      allow(uploader).to receive(:fix_exif_rotation)
      allow(uploader).to receive(:set_content_type)

      uploader.process!
    end

    after do
      TempImageFileUploader.enable_processing = false
    end

    
    it 'fixes the EXIF rotation' do
      expect(uploader).to have_received(:fix_exif_rotation)
    end

    it 'sets the content type' do
      expect(uploader).to have_received(:set_content_type)
    end
  end
end
