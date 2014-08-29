require 'rails_helper'

describe ImageUrlHelper do
  describe '#cache_busted_url' do
    let(:memory_stub) { Fabricate.build(:photo_memory, updated_at: '2014-05-04 13:14:15') }

    context "when not specifying a version" do
      subject { helper.cache_busted_url(memory_stub).split('/').last }

      it "provides the URL with a timestamp afterwards" do
        expect(subject).to eql("test.jpg?1399209255")
      end
    end

    context "when specifying a version" do
      subject { helper.cache_busted_url(memory_stub, version).split('/').last }

      context "when specifying nil version" do
        let(:version) { nil }

        it "provides the URL with a timestamp afterwards" do
          expect(subject).to eql("test.jpg?1399209255")
        end
      end

      context "when asking for the thumb version" do
        let(:version) { :thumb }

        it "provides the thumb URL with a timestamp afterwards" do
          expect(subject).to eql("thumb_test.jpg?1399209255")
        end
      end
    end
  end
end
