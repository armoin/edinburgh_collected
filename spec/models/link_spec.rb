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

  describe 'url_without_protocol' do
    subject { Fabricate.build(:link) }

    it 'supplies the URL without an http protocol' do
      subject.url = 'http://www.example.com'
      expect(subject.url_without_protocol).to eql('www.example.com')
    end

    it 'supplies the URL without an https protocol' do
      subject.url = 'https://www.example.com'
      expect(subject.url_without_protocol).to eql('www.example.com')
    end

    # this is to make it easy to see when people are adding links with
    # bad protocols
    context 'when URL does not begin with http/https' do
      it 'shows ftp' do
        subject.url = 'ftp://www.example.com'
        expect(subject.url_without_protocol).to eql('ftp://www.example.com')
      end

      it 'shows git' do
        subject.url = 'git://www.example.com'
        expect(subject.url_without_protocol).to eql('git://www.example.com')
      end
    end
  end
end