require 'rails_helper'

def memory_allowed_params
  {
    title:              'A test',
    type:               'Photo',
    image_angle:        '90',
    source:             'test.jpg',
    description:        'This is a test description',
    year:               '2014',
    month:              '5',
    day:                '4',
    attribution:        'Bobby Tables',
    area_id:            '1',
    location:           'Portobello',
    moderation_reason:  'Some reason',
    category_ids:       ['category_1', 'category_2'],
  }
end

describe MemoryParamCleaner do
  subject { MemoryParamCleaner.clean(params) }

  context 'when params are allowed' do
    let(:params) { ActionController::Parameters.new({
      memory: memory_allowed_params
    })}

    it "keeps allowed params" do
      expect(subject.length).to eql(memory_allowed_params.length)
    end

    memory_allowed_params.each do |key,value|
      it "allows #{key}" do
        expect(subject).to have_key(key)
      end
    end
  end

  context 'when params are not allowed' do
    let(:params) { ActionController::Parameters.new({
      memory: {
        not_allowed: 'This should not be allowed'
      }
    })}

    it "is empty" do
      result = MemoryParamCleaner.clean(params)
      expect(subject).to be_empty
    end
  end
end
