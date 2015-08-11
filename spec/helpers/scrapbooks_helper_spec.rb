require 'rails_helper'

RSpec.describe ScrapbooksHelper, type: :helper do
  describe '#path_to_scrapbook' do
    let(:scrapbook_path) { "my/test/path#{query_string}" }
    let(:query_string)   { nil }
    let(:scrapbook_id)   { 123 }

    subject { helper.path_to_scrapbook(scrapbook_path, scrapbook_id) }

    context 'with no query string' do
      let(:query_string) { nil }

      it 'returns the given URL with scrapbook ID appended' do
        expect(subject).to eql('my/test/path/123')
      end
    end

    context 'with query string' do
      let(:query_string) { '?query=string' }

      it 'returns the given URL with scrapbook ID inserted' do
        expect(subject).to eql('my/test/path/123?query=string')
      end
    end

    describe 'guarding against bad data' do
      context 'when path is nil' do
        let(:scrapbook_path) { nil }

        it 'returns an empty string' do
          expect(subject).to be_nil
        end
      end

      context 'when scrapbook_id is nil' do
        let(:scrapbook_id) { nil }

        it 'returns the original path' do
          expect(subject).to eql(scrapbook_path)
        end
      end
    end
  end
end
