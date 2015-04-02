require 'rails_helper'

describe UserHelper do
  describe '#greet' do
    it 'provides a welcome link' do
      expected = "<a href=\"#{my_profile_path}\">Welcome, bob</a>"
      expect(helper.greet('bob')).to eql(expected)
    end
  end

  describe '#user_name_label' do
    it "returns 'Group name' if the user is a group" do
      user = double(is_group?: true)
      expect(helper.user_name_label(user)).to eql('Group name')
    end

    it "returns 'First name' if the user is an individual" do
      user = double(is_group?: false)
      expect(helper.user_name_label(user)).to eql('First name')
    end
  end

  describe '#show_verification_warning?' do
    before :each do
      allow(helper).to receive(:current_user).and_return(user)
    end

    context 'when there is not a current user' do
      let(:user) { nil }

      it 'is false' do
        expect(helper.show_verification_warning?).to be_falsy
      end
    end

    context 'when there is a current user' do
      let(:user) { Fabricate.build(:user, id: 123) }

      before :each do
        allow(user).to receive(:pending?).and_return(is_pending)
      end

      context 'and the user does not need to verify' do
        let(:is_pending) { false }

        it 'is false' do
          expect(helper.show_verification_warning?).to be_falsy
        end
      end

      context 'and the user needs to verify' do
        let(:is_pending) { true }

        it 'is true' do
          expect(helper.show_verification_warning?).to be_truthy
        end
      end
    end
  end
end

