require 'rails_helper'

describe Written do
  let(:test_user) { Fabricate.build(:user) }
  let!(:area)     { Fabricate(:area) }
  let(:memory)    { Fabricate.build(:written_memory, user: test_user, area: area) }

  it_behaves_like "a memory"

  it 'is a Memory of type "Written"' do
    expect(subject).to be_a(Memory)
    expect(subject.type).to eql('Written')
  end

  it 'has a label of "written"' do
    expect(subject.label).to eq('written')
  end

  describe '#info_list' do
    it 'is empty' do
      expect(subject.info_list).to be_empty
    end
  end

  describe 'validation' do
    describe "source" do
      it "can be blank" do
        expect(memory.source).to be_nil
        expect(memory).to be_valid
      end
    end
  end

  describe 'source_url' do
    it 'returns nil when no version is given' do
      expect(subject.source_url).to be_nil
    end

    it 'returns the text memory thumbnail otherwise' do
      expect(subject.source_url(:thumb)).to eql(Written::THUMBNAIL_IMAGE)
      expect(subject.source_url(:mini_thumb)).to eql(Written::THUMBNAIL_IMAGE)
      expect(subject.source_url(:big_thumb)).to eql(Written::THUMBNAIL_IMAGE)
      expect(subject.source_url(:other)).to eql(Written::THUMBNAIL_IMAGE)
    end
  end
end
