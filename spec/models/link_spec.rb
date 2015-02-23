require 'rails_helper'

describe Link do
  describe 'validations' do
    describe 'name' do
      it 'must be present' do
        expect(subject).to be_invalid
        expect(subject.errors[:name]).to include("can't be blank")
      end
    end

    describe 'URL' do
      it 'must be present' do
        expect(subject).to be_invalid
        expect(subject.errors[:url]).to include("can't be blank")
      end

      it 'must be a valid URL' do
        expect(subject).to be_invalid
        expect(subject.errors[:url]).to include("is not a valid URL")
      end

      it 'cannot be a relative URL' do
        subject.url = 'my/relative/url'
        expect(subject).to be_invalid
        expect(subject.errors[:url]).to include("is not a valid URL")
      end

      it 'must include the protocol' do
        subject.url = 'www.example.com'
        expect(subject).to be_invalid
        expect(subject.errors[:url]).to include("is not a valid URL")
      end
    end
  end
end