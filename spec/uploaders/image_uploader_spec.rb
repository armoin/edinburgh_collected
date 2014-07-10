require 'rails_helper'

describe ImageUploader do
  describe '#store_dir' do
    it 'gives the same result each time for the same model' do
      asset = Asset.new
      allow(subject).to receive(:model) { asset }
      dir_1 = subject.store_dir
      dir_2 = subject.store_dir
      expect(dir_1).to eql(dir_2)
    end

    it 'gives a different result each time for different models' do
      allow(subject).to receive(:model) { Asset.new }
      dir_1 = subject.store_dir
      dir_2 = subject.store_dir
      expect(dir_1).not_to eql(dir_2)
    end
  end
end
