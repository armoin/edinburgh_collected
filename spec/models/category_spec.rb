require 'rails_helper'

describe Category do
  describe 'validations' do
    it 'must have a name' do
      subject.valid?
      expect(subject).to be_invalid
      expect(subject.errors[:name]).to include("can't be blank")
    end
  end
end
