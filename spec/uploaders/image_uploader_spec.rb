require 'rails_helper'
require 'carrierwave/test/matchers'

describe ImageUploader, slow: true do
  include CarrierWave::Test::Matchers

  let(:memory)       { Fabricate.build(:photo_memory, id: 123) }
  let(:path_to_file) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.jpg') }
  let(:photo_width)  { 167 }
  let(:uploader)     { ImageUploader.new(memory, :source) }

  describe 'without manipulation' do
    before do
      uploader.store!(File.open(path_to_file))
    end

    after do
      uploader.remove!
    end

    describe '#store_dir' do
      before :each do
        @root, @model, @mounted_as, @id = uploader.store_dir.split('/')
      end

      it 'has a root of uploads' do
        expect(@root).to eql('uploads')
      end

      it 'has a model of memory' do
        expect(@model).to eql('memory')
      end

      it 'has a mounted_as of source' do
        expect(@mounted_as).to eql('source')
      end

      it 'has an id of 123' do
        expect(@id).to eql('123')
      end
    end

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

  describe 'with manipulation' do
    before do
      ImageUploader.enable_processing = true
      uploader.store!(File.open(path_to_file))
    end

    after do
      ImageUploader.enable_processing = false
      uploader.remove!
    end
  end

  context 'the thumb version' do
    it "should scale down an image to a width of 250 pixels" do
      expect(uploader.thumb).to be_no_larger_than(250, photo_width)
    end
  end
end
