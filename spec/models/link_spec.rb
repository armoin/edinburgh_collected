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
    end
  end

  describe "#url=" do
    subject { Fabricate.build(:link) }

    it "makes no changes to the url if the url has an HTTP protocol" do
      subject.url = 'http://www.example.com'
      expect(subject.url).to eql('http://www.example.com')
      expect(subject).to be_valid
    end

    it "makes no changes to the url if the url has an HTTPS protocol" do
      subject.url = 'https://www.example.com'
      expect(subject.url).to eql('https://www.example.com')
      expect(subject).to be_valid
    end

    it "prepends HTTP if the url has no protocol" do
      subject.url = 'www.example.com'
      expect(subject.url).to eql('http://www.example.com')
      expect(subject).to be_valid
    end

    it "prepends HTTP if the url has an invalid protocol" do
      subject.url = 'ftp://www.example.com'
      expect(subject.url).to eql('http://www.example.com')
      expect(subject).to be_valid
    end

    it "prepends HTTP if the url has a relative protocol" do
      subject.url = '//www.example.com'
      expect(subject.url).to eql('http://www.example.com')
      expect(subject).to be_valid
    end

    # These tests are here to show that we know about this behaviour but are
    # igorning for now as all links are currently moderated
    it "prepends HTTP if the url has no protocol or host and is a relative url" do
      subject.url = 'my/local/path'
      expect(subject.url).to eql('http://my/local/path')
      expect(subject).to be_valid
    end

    it "prepends HTTP if the url has no protocol or host and is an absolute url" do
      subject.url = '/my/local/path'
      expect(subject.url).to eql('http://my/local/path')
      expect(subject).to be_valid
    end

    it 'permits nonsense URLs' do
      subject.url = '1,2.3'
      expect(subject.url).to eql('http://1,2.3')
      expect(subject).to be_valid
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
  end
end