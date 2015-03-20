require 'rails_helper'
require 'carrierwave/test/matchers'

describe ImageUploader, slow: true do
  include CarrierWave::Test::Matchers

  let(:memory)       { Fabricate.build(:photo_memory, id: 123) }
  let(:model_name)   { 'memory' }
  let(:filename)     { 'test.jpg' }
  let(:path_to_file) { File.join(Rails.root, 'spec', 'fixtures', 'files', filename) }
  let(:uploader)     { ImageUploader.new(memory, :source) }

  after do
    uploader.remove!
  end

  describe 'without processing' do
    it_behaves_like 'a base image uploader'

    describe "#is_rotated?" do
      let(:file) { nil }
      let(:model) { Fabricate.build(:photo_memory) }

      before :each do
        allow(uploader).to receive(:model).and_return(model)
      end

      it "is false when image has no rotation" do
        model.rotation = nil
        expect(uploader.is_rotated?(file)).to be_falsy
      end

      it "is false when image has rotation of 0" do
        model.rotation = "0"
        expect(uploader.is_rotated?(file)).to be_falsy
      end

      it "is true when image is rotated by > 0" do
        model.rotation = "90"
        expect(uploader.is_rotated?(file)).to be_truthy
      end
    end
  end

  describe 'with processing' do
    before do
      ImageUploader.enable_processing = true
      uploader.store!(File.open(path_to_file))
    end

    after do
      ImageUploader.enable_processing = false
    end

    it "should scale down a mini thumb image to 90x90 pixels" do
      expect(uploader.mini_thumb).to have_dimensions(90, 90)
    end

    it "should scale down a thumb image to a width of 250 pixels" do
      expect(uploader.thumb).to be_no_larger_than(250, 167)
    end

    it "should scale down a big thumb image to a width of 350 pixels" do
      expect(uploader.big_thumb).to be_no_larger_than(350, 233)
    end
  end
end
