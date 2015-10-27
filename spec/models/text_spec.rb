require 'rails_helper'

describe Text do
  let(:test_user) { Fabricate.build(:user) }
  let!(:area)     { Fabricate(:area) }
  let(:memory)    { Fabricate.build(:text_memory, user: test_user, area: area) }

  it_behaves_like "a memory"

  it 'is a Memory of type "Text"' do
    expect(subject).to be_a(Memory)
    expect(subject.type).to eql('Text')
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
      expect(subject.source_url(:thumb)).to eql(Text::THUMBNAIL_IMAGE)
      expect(subject.source_url(:mini_thumb)).to eql(Text::THUMBNAIL_IMAGE)
      expect(subject.source_url(:big_thumb)).to eql(Text::THUMBNAIL_IMAGE)
      expect(subject.source_url(:other)).to eql(Text::THUMBNAIL_IMAGE)
    end
  end
end
