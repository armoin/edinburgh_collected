require 'rails_helper'

describe AuthorizationHelper do
  describe '#belongs_to_user' do
    let(:thing) { double('thing', user_id: @user.id) }

    before :each do
      @user = Fabricate.build(:user)
    end

    context "when user is not logged in" do
      it "is false" do
        expect(helper.belongs_to_user?(thing)).to be_falsy
      end
    end

    context "when user is logged in" do
      before :each do
        login_user
      end

      it "is false if no thing given" do
        thing = nil
        expect(helper.belongs_to_user?(thing)).to be_falsy
      end

      it "is false if thing has no user_id" do
        thing = double('thing')
        expect(helper.belongs_to_user?(thing)).to be_falsy
      end

      it "is false if thing is not theirs" do
        thing = double('thing', user_id: 999)
        expect(helper.belongs_to_user?(thing)).to be_falsy
      end

      it "is true if thing is theirs" do
        expect(helper.belongs_to_user?(thing)).to be_truthy
      end
    end
  end
end
