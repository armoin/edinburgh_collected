require 'rails_helper'

describe Scrapbook do
  describe 'validation' do
    it 'must have a title' do
      expect(subject).to be_invalid
      expect(subject.errors[:title]).to include("can't be blank")
    end

    it 'must belong to a user' do
      expect(subject).to be_invalid
      expect(subject.errors[:user]).to include("can't be blank")
    end
  end
end
