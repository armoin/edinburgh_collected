require 'rails_helper'

RSpec.shared_examples 'a base image uploader' do  
  describe '#store_dir' do
    before :each do
      uploader.store!(File.open(path_to_file))
      @root, @model, @mounted_as, @id = uploader.store_dir.split('/')
    end

    it 'has a root of uploads' do
      expect(@root).to eql('uploads')
    end

    it 'includes the model name' do
      expect(@model).to eql(model_name)
    end

    it 'includes the mounted as' do
      expect(@mounted_as).to eql(uploader.mounted_as.to_s)
    end

    it 'has an id of 123' do
      expect(@id).to eql('123')
    end
  end

  describe '#filename' do
    context 'when file is valid' do
      before :each do
        allow(SecureRandom).to receive(:uuid).and_return('random_sample')
        uploader.store!(File.open(path_to_file))
      end

      it "randomly generates a filename" do
        expect(uploader.filename).to eql('random_sample.jpg')
      end

      context 'when the extension is valid' do
        let(:filename) { 'test.jpg' }

        it 'provides the file name with the given extension' do
          expect(File.extname(uploader.filename)).to eql('.jpg')
        end
      end

      context 'when the extension is invalid but the file is of the right type' do
        let(:filename) { 'test.oops' }

        it 'provides the file name with the filetype extension' do
          expect(File.extname(uploader.filename)).to eql('.jpeg')
        end
      end
    end

    context 'when extension is invalid and the file is not of the right type' do
      let(:filename) { 'test.txt' }

      it 'raises an error' do
        expect{
          uploader.store!(File.open(path_to_file))
        }.to raise_error(CarrierWave::IntegrityError)
      end
    end
  end
end