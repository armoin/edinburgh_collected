require 'rails_helper'

describe UserHelper do
  describe '#user_name_label' do
    it "returns 'Group name:' if the user is a group" do
      user = double(is_group?: true)
      expect(helper.user_name_label(user)).to eql('Group name:')
    end

    it "returns 'First name:' if the user is an individual" do
      user = double(is_group?: false)
      expect(helper.user_name_label(user)).to eql('First name:')
    end
  end
end

