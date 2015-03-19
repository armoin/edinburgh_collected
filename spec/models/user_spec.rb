require 'rails_helper'

describe User do
  describe 'validation' do
    it 'needs a first_name' do
      expect(subject).to be_invalid
      expect(subject.errors[:first_name]).to include("can't be blank")
    end

    it 'needs a last name if the user is an individual' do
      expect(subject).to be_invalid
      expect(subject.errors[:last_name]).to include("can't be blank")
    end

    it 'does not need a last name if the user is a group' do
      subject.is_group = true
      expect(subject).to be_invalid
      expect(subject.errors[:last_name]).not_to include("can't be blank")
    end

    it 'needs a screen_name' do
      expect(subject).to be_invalid
      expect(subject.errors[:screen_name]).to include("can't be blank")
    end

    it 'needs a unique screen_name' do
      Fabricate(:user, screen_name: 'bobby')
      subject.screen_name = 'bobby'
      subject.valid?
      expect(subject.errors[:screen_name]).to include("has already been taken")
    end

    it 'needs an email' do
      expect(subject).to be_invalid
      expect(subject.errors[:email]).to include("can't be blank")
    end

    it 'needs a unique email' do
      Fabricate(:user, email: 'bobby@example.com')
      subject.email = 'bobby@example.com'
      subject.valid?
      expect(subject.errors[:email]).to include("has already been taken")
    end

    it 'downcases the email before validating' do
      subject.email = 'Bobby@example.com'
      subject.valid?
      expect(subject.email).to eql('bobby@example.com')
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

    context "if password has not yet been set" do
      context "and password has not been given" do
        it 'must have the minimum number of characters' do
          subject.password = ''
          subject.valid?
          expect(subject.errors[:password]).to include("is too short (minimum is #{User::PASSWORD_LENGTH} characters)")
        end
      end

      context "and password has been given" do
        it 'must have the minimum number of characters' do
          subject.password = 'oo'
          subject.valid?
          expect(subject.errors[:password]).to include("is too short (minimum is #{User::PASSWORD_LENGTH} characters)")
        end

        it 'must match confirmation' do
          user = User.new(password: 'foo', password_confirmation: 'bar')
          user.valid?
          expect(user.errors[:password_confirmation]).to include("doesn't match Password")
        end
      end
    end

    context "if password has been set" do
      let(:user) { Fabricate(:user) }

      context "and password has been changed" do
        it 'must have the minimum number of characters' do
          user.password = 'oo'
          user.valid?
          expect(user.errors[:password]).to include("is too short (minimum is #{User::PASSWORD_LENGTH} characters)")
        end

        it 'must match confirmation' do
          user.password = 'foo'
          user.password_confirmation = 'bar'
          user.valid?
          expect(user.errors[:password_confirmation]).to include("doesn't match Password")
        end
      end

      context "and password has not been changed" do
        let(:user) { Fabricate(:user) }

        it 'does not check password length' do
          user.valid?
          expect(user.errors[:password]).to be_empty
        end

        it 'does not check password confirmation' do
          user.valid?
          expect(user.errors[:password_confirmation]).to be_empty
        end
      end
    end

    it "needs to have accepted the terms and conditions" do
      expect(subject).to be_invalid
      expect(subject.errors[:accepted_t_and_c]).to include("must be accepted")
    end
  end

  describe 'activation' do
    context 'when a new user is created' do
      let(:stub_mailer) { double('mailer', deliver: true) }

      before :each do
        allow(AuthenticationMailer).to receive(:activation_needed_email).and_return(stub_mailer)
        @user = Fabricate(:user)
      end

      it 'has an activation state of "pending"' do
        expect(@user.activation_state).to eql('pending')
      end

      it 'builds an activation needed email' do
        expect(AuthenticationMailer).to have_received(:activation_needed_email)
      end

      it 'sends the activation needed email' do
        expect(stub_mailer).to have_received(:deliver)
      end
    end

    context 'when an existing user changes their email' do
      let(:stub_mailer) { double('mailer', deliver: true) }

      before :each do
        @user = Fabricate(:active_user)
        allow(AuthenticationMailer).to receive(:activation_needed_email).and_return(stub_mailer)
        @user.update_attribute(:email, 'mary@example.com')
      end

      it 'changes the activation state to "pending"' do
        expect(@user.activation_state).to eql('pending')
      end

      it 'builds an activation needed email' do
        expect(AuthenticationMailer).to have_received(:activation_needed_email)
      end

      it 'sends the activation needed email' do
        expect(stub_mailer).to have_received(:deliver)
      end
    end

    context 'when an existing user changes something other than their email' do
      let(:stub_mailer) { double('mailer', deliver: true) }

      before :each do
        @user = Fabricate(:active_user)
        allow(AuthenticationMailer).to receive(:activation_needed_email).and_return(stub_mailer)
        @user.update_attribute(:first_name, 'mary')
      end

      it 'does not change the activation state to "pending"' do
        expect(@user.activation_state).not_to eql('pending')
      end

      it 'does not build an activation needed email' do
        expect(AuthenticationMailer).not_to have_received(:activation_needed_email)
      end

      it 'does not send the activation needed email' do
        expect(stub_mailer).not_to have_received(:deliver)
      end
    end
  end

  describe '.find_by_email' do
    let!(:user) { Fabricate(:user, email: 'bobby@example.com') }

    it 'provides the user if a lower case email is given' do
      email = 'bobby@example.com'
      expect(User.find_by_email(email)).to eql(user)
    end

    it 'provides the user if a capitalised email is given' do
      email = 'Bobby@example.com'
      expect(User.find_by_email(email)).to eql(user)
    end

    it 'provides the user if an upper case email is given' do
      email = 'BOBBY@EXAMPLE.COM'
      expect(User.find_by_email(email)).to eql(user)
    end

    it 'does not provide the user if an incorrect email is given' do
      email = 'mary@example.com'
      expect(User.find_by_email(email)).to be_nil
    end

    it 'does not provide the user if no email is given' do
      email = ''
      expect(User.find_by_email(email)).to be_nil
    end
  end

  describe '.active' do
    let!(:active_user)   { Fabricate(:active_user) }
    let!(:inactive_user) { Fabricate(:user) }

    it 'provides active users' do
      expect(User.active).to include(active_user)
    end

    it 'does not provide users that are not active' do
      expect(User.active).not_to include(inactive_user)
    end
  end

  describe '.blocked' do
    let!(:blocked_user)     { Fabricate(:blocked_user) }
    let!(:non_blocked_user) { Fabricate(:active_user) }

    it 'provides blocked users' do
      expect(User.blocked).to include(blocked_user)
    end

    it 'does not provide users that are not blocked' do
      expect(User.blocked).not_to include(non_blocked_user)
    end
  end

  describe '#can_modify?' do
    let(:user_id) { 123 }
    let(:thing)   { double('thing') }

    context 'when user is not an admin' do
      subject { Fabricate.build(:user, id: user_id, is_admin: false) }

      it "is false if no object given" do
        expect(subject.can_modify?(nil)).to be_falsy
      end

      it "is false if thing has no user_id" do
        expect(subject.can_modify?(thing)).to be_falsy
      end

      it "is false if thing is not theirs" do
        thing = double('thing', user_id: 999)
        expect(subject.can_modify?(thing)).to be_falsy
      end

      it "is true if thing is theirs" do
        thing = double('thing', user_id: user_id)
        expect(subject.can_modify?(thing)).to be_truthy
      end
    end

    context 'when user is an admin' do
      subject { Fabricate.build(:user, id: user_id, is_admin: true) }

      it "is false if no object given" do
        expect(subject.can_modify?(nil)).to be_falsy
      end

      it "is true if thing has no user_id" do
        expect(subject.can_modify?(thing)).to be_truthy
      end

      it "is true if thing belongs to someone else" do
        thing = double('thing', user_id: 999)
        expect(subject.can_modify?(thing)).to be_truthy
      end

      it "is true if thing is theirs" do
        thing = double('thing', user_id: user_id)
        expect(subject.can_modify?(thing)).to be_truthy
      end
    end
  end

  describe '#active?' do
    let(:user) { Fabricate.build(:user, activation_state: activation_state) }
    let(:inactive_user) { Fabricate.build(:user) }

    context 'when the activation_state is "active"' do
      let(:activation_state) { 'active' }

      it 'is true' do
        expect(user).to be_active
      end
    end

    context 'when the activation_state is "pending"' do
      let(:activation_state) { 'pending' }

      it 'is false' do
        expect(user).not_to be_active
      end
    end
  end

  describe '#name' do
    let(:user) { Fabricate.build(:active_user, first_name: 'Bobby', last_name: last_name)}

    context 'when user has a last name' do
      let(:last_name) { 'Tables' }

      it 'includes the first name and the last name' do
        expect(user.name).to eql('Bobby Tables')
      end
    end

    context 'when user has a nil last name' do
      let(:last_name) { nil }

      it 'includes the first name and the last name' do
        expect(user.name).to eql('Bobby')
      end
    end

    context 'when user has a blank last name' do
      let(:last_name) { '' }

      it 'includes the first name and the last name' do
        expect(user.name).to eql('Bobby')
      end
    end

    context 'when user has a last name with spaces' do
      let(:last_name) { '  ' }

      it 'includes the first name and the last name' do
        expect(user.name).to eql('Bobby')
      end
    end
  end

  it_behaves_like 'an image manipulator'

  describe 'links' do
    it 'accepts nested link attributes' do
      expect(subject).to accept_nested_attributes_for(:links).allow_destroy(true)
    end

    describe 'a user' do
      it 'can add a link to their profile' do
        name = 'My site'
        url = 'http://www.example.com'

        subject.links.build(name: name, url: url)

        expect(subject.links.length).to eql(1)

        expect(subject.links.first.name).to eql(name)
        expect(subject.links.first.url).to eql(url)
      end

      it 'can have more that one URL' do
        name_1 = 'My site'
        url_1 = 'http://www.example.com'

        name_2 = 'My other site'
        url_2 = 'http://www.other_example.com'

        subject.links.build(name: name_1, url: url_1)
        subject.links.build(name: name_2, url: url_2)

        expect(subject.links.length).to eql(2)

        expect(subject.links.first.name).to eql(name_1)
        expect(subject.links.first.url).to eql(url_1)

        expect(subject.links.last.name).to eql(name_2)
        expect(subject.links.last.url).to eql(url_2)
      end
    end
  end

  describe '#block!' do
    it 'marks the user as blocked' do
      user = Fabricate(:active_user)
      expect {
        user.block!
      }.to change{user.is_blocked?}.to(true)
    end
  end
end
