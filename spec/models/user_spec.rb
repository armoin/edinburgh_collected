require 'rails_helper'

describe User do
  let(:moderatable_model)   { User }
  let(:moderatable_factory) { :user }
  it_behaves_like 'a moderatable user'

  describe '#user_id' do
    it 'is an alias for id' do
      user = Fabricate.build(:user, id: 123)
      expect(user.user_id).to eql(123)
    end
  end

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

  describe '#pending?' do
    let(:user) { Fabricate.build(:user, activation_state: state, activation_token: token) }

    context 'when the activation_state is "active"' do
      let(:state) { 'active' }

      context 'and activation token is present' do
        let(:token) { '123abc' }

        it 'is false' do
          expect(user).not_to be_pending
        end
      end

      context 'and no activation token is present' do
        let(:token) { nil }

        it 'is false' do
          expect(user).not_to be_pending
        end
      end
    end

    context 'when the activation_state is "pending"' do
      let(:state) { 'pending' }

      context 'and activation token is present' do
        let(:token) { '123abc' }

        it 'is true' do
          expect(user).to be_pending
        end
      end

      context 'and no activation token is present' do
        let(:token) { nil }

        it 'is false' do
          expect(user).not_to be_pending
        end
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

  describe '#show_getting_started?' do
    before :each do
      allow(subject).to receive(:hide_getting_started?).and_return(hide_getting_started)
      allow(subject).to receive(:is_starting?).and_return(is_starting)
    end

    context 'if the user does not want to hide getting started' do
      let(:hide_getting_started) { false }

      context 'and the user is starting' do
        let(:is_starting) { true }

        it 'is true' do
          expect(subject.show_getting_started?).to be_truthy
        end
      end

      context 'and the user is not starting' do
        let(:is_starting) { false }

        it 'is false' do
          expect(subject.show_getting_started?).to be_falsy
        end
      end
    end

    context 'if the user wants to hide getting started' do
      let(:hide_getting_started) { true }

      context 'and the user is starting' do
        let(:is_starting) { true }

        it 'is true' do
          expect(subject.show_getting_started?).to be_falsy
        end
      end

      context 'and the user is not starting' do
        let(:is_starting) { false }

        it 'is true' do
          expect(subject.show_getting_started?).to be_falsy
        end
      end
    end
  end

  describe '#is_starting?' do
    before :each do
      allow(subject).to receive(:has_profile?).and_return(has_profile)
      allow(subject).to receive(:has_memories?).and_return(has_memories)
      allow(subject).to receive(:has_scrapbooks?).and_return(has_scrapbooks)
    end

    context 'with unedited profile, no memory, no scrapbook' do
      let(:has_profile)    { false }
      let(:has_memories)   { false }
      let(:has_scrapbooks) { false }

      it 'is true' do
        expect(subject.is_starting?).to be_truthy
      end
    end

    context 'with unedited profile, a memory, no scrapbook' do
      let(:has_profile)    { false }
      let(:has_memories)   { true }
      let(:has_scrapbooks) { false }

      it 'is true' do
        expect(subject.is_starting?).to be_truthy
      end
    end

    context 'with unedited profile, no memory, a scrapbook' do
      let(:has_profile)    { false }
      let(:has_memories)   { false }
      let(:has_scrapbooks) { true }

      it 'is true' do
        expect(subject.is_starting?).to be_truthy
      end
    end

    context 'with unedited profile, a memory, a scrapbook' do
      let(:has_profile)    { false }
      let(:has_memories)   { true }
      let(:has_scrapbooks) { true }

      it 'is true' do
        expect(subject.is_starting?).to be_truthy
      end
    end

    context 'with edited profile, no memory, no scrapbook' do
      let(:has_profile)    { true }
      let(:has_memories)   { false }
      let(:has_scrapbooks) { false }

      it 'is true' do
        expect(subject.is_starting?).to be_truthy
      end
    end

    context 'with edited profile, a memory, no scrapbook' do
      let(:has_profile)    { true }
      let(:has_memories)   { true }
      let(:has_scrapbooks) { false }

      it 'is true' do
        expect(subject.is_starting?).to be_truthy
      end
    end

    context 'with edited profile, no memory, a scrapbook' do
      let(:has_profile)    { true }
      let(:has_memories)   { false }
      let(:has_scrapbooks) { true }

      it 'is true' do
        expect(subject.is_starting?).to be_truthy
      end
    end

    context 'with edited profile, a memory, a scrapbook' do
      let(:has_profile)    { true }
      let(:has_memories)   { true }
      let(:has_scrapbooks) { true }

      it 'is false' do
        expect(subject.is_starting?).to be_falsy
      end
    end
  end

  describe '#has_memories?' do
    it 'is false if the user has no memories' do
      expect(subject).not_to have_memories
    end

    it 'is true if the user has at least one memory' do
      subject.memories.build
      expect(subject).to have_memories
    end
  end

  describe '#has_scrapbooks?' do
    it 'is false if the user has no scrapbooks' do
      expect(subject).not_to have_scrapbooks
    end

    it 'is true if the user has at least one scrapbook' do
      subject.scrapbooks.build
      expect(subject).to have_scrapbooks
    end
  end

  describe '#has_profile?' do
    it 'is false if the user has no description, avatar and links' do
      expect(subject).not_to have_profile
    end

    it 'is true if the user has a description' do
      subject.description = 'a description'
      expect(subject).to have_profile
    end

    it 'is true if the user has an avatar' do
      subject.avatar = File.open(File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.jpg'))
      expect(subject).to have_profile
    end

    it 'is true if the user has a link' do
      subject.links.build
      expect(subject).to have_profile
    end
  end

  describe '#access_denied?' do
    subject { Fabricate.build(:active_user, moderation_state: moderation_state) }

    context 'when user is not blocked' do
      let(:moderation_state) { 'approved' }

      it 'is false' do
        expect(subject.access_denied?).to be_falsy
      end
    end

    context 'when the user is blocked' do
      let(:moderation_state) { 'blocked' }

      it 'is true' do
        expect(subject.access_denied?).to be_truthy
      end
    end
  end

  describe '#access_denied_reason' do
    it 'provides the access denied reason' do
      expected = 'Your account has been blocked. Please contact us if you would like more information.'
      expect(subject.access_denied_reason).to eql(expected)
    end
  end
end
