require 'rails_helper'

def scrapbook_allowed_params
  {
    title:        'A test',
    description:  'This is a test description',
  }
end

describe ScrapbookParamCleaner do
  subject { ScrapbookParamCleaner.clean(params) }

  context 'when params are allowed' do
    let(:params) { ActionController::Parameters.new({
      scrapbook: scrapbook_allowed_params
    })}

    it "keeps allowed params" do
      expect(subject.length).to eql(scrapbook_allowed_params.length)
    end

    scrapbook_allowed_params.each do |key,value|
      it "allows #{key}" do
        expect(subject).to have_key(key)
      end
    end
  end

  context 'when params are not allowed' do
    let(:params) { ActionController::Parameters.new({
      scrapbook: {
        not_allowed: 'This should not be allowed'
      }
    })}

    it "is empty" do
      result = ScrapbookParamCleaner.clean(params)
      expect(subject).to be_empty
    end
  end
end
