require 'rails_helper'

describe User do
  describe 'validation' do
    before :each do
      expect(subject).to be_invalid
    end

    it 'needs a first_name' do
      expect(subject.errors[:first_name]).to include("can't be blank")
    end

    it 'needs a last_name' do
      expect(subject.errors[:last_name]).to include("can't be blank")
    end

    it 'needs a screen_name' do
      expect(subject.errors[:screen_name]).to include("can't be blank")
    end

    it 'needs a unique screen_name' do
      Fabricate(:user, screen_name: 'bobby')
      subject.screen_name = 'bobby'
      subject.valid?
      expect(subject.errors[:screen_name]).to include("has already been taken")
    end

    it 'needs an email' do
      expect(subject.errors[:email]).to include("can't be blank")
    end

    it 'needs a unique email' do
      Fabricate(:user, email: 'bobby@example.com')
      subject.email = 'bobby@example.com'
      subject.valid?
      expect(subject.errors[:email]).to include("has already been taken")
    end

    context 'needs a valid email' do
      let(:user) { Fabricate.build(:user) }

      it "needs an @" do
        user.email = 'bobby'
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("is invalid")
      end

      it "needs a domain" do
        user.email = 'bobby@'
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("is invalid")
      end

      it "needs a TLD" do
        user.email = 'bobby@example'
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("is invalid")
      end

      it "is valid with valid email address" do
        user.email = 'bobby@example.com'
        expect(user).to be_valid
      end
    end

    it 'needs a password_confirmation' do
      expect(subject.errors[:password_confirmation]).to include("can't be blank")
    end

    it 'must have a password with at least 3 characters' do
      subject.password = 'oo'
      subject.valid?
      expect(subject.errors[:password]).to include("is too short (minimum is 3 characters)")
    end

    it 'must have a password that matches confirmation' do
      user = User.new(password: 'foo', password_confirmation: 'bar')
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end
end
