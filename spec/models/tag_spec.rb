require 'rails_helper'

describe Tag do
  describe 'validation' do
    it "must have a name" do
      subject.valid?
      expect(subject.errors[:name]).to include("can't be blank")
    end
  end
end
