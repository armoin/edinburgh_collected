require 'rails_helper'

def scrapbook_memory_allowed_params
  {
    scrapbook_id: '123',
    memory_id:    '456',
  }
end

describe ScrapbookMemoryParamCleaner do
  subject { ScrapbookMemoryParamCleaner.clean(params) }

  context 'when params are allowed' do
    let(:params) { ActionController::Parameters.new({
      scrapbook_memory: scrapbook_memory_allowed_params
    })}

    it "keeps allowed params" do
      expect(subject.length).to eql(scrapbook_memory_allowed_params.length)
    end

    scrapbook_memory_allowed_params.each do |key,value|
      it "allows #{key}" do
        expect(subject).to have_key(key)
      end
    end
  end

  context 'when params are not allowed' do
    let(:params) { ActionController::Parameters.new({
      scrapbook_memory: {
        not_allowed: 'This should not be allowed'
      }
    })}

    it "is empty" do
      result = ScrapbookMemoryParamCleaner.clean(params)
      expect(subject).to be_empty
    end
  end
end

