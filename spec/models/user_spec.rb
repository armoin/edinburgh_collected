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

  describe 'attached image' do
    describe 'image data' do
      it 'can have an image angle' do
        subject.image_angle = 270
        expect(subject.image_angle).to eql(270)
      end

      it 'can have an image scale' do
        subject.image_scale = 0.12345
        expect(subject.image_scale).to eql(0.12345)
      end

      it 'can have an image width' do
        subject.image_w = 90
        expect(subject.image_w).to eql(90)
      end

      it 'can have an image height' do
        subject.image_h = 90
        expect(subject.image_h).to eql(90)
      end

      it 'can have an image x coord' do
        subject.image_x = 5
        expect(subject.image_x).to eql(5)
      end

      it 'can have an image y coord' do
        subject.image_y = 12
        expect(subject.image_y).to eql(12)
      end
    end

    describe '#rotated?' do
      it 'is false if the image_angle is nil' do
        subject.image_angle = nil
        expect(subject).not_to be_rotated
      end

      it 'is false if the image_angle is blank' do
        subject.image_angle = ''
        expect(subject).not_to be_rotated
      end

      it 'is false if the image_angle is 0' do
        subject.image_angle = '0'
        expect(subject).not_to be_rotated
      end

      it 'is true if the image_angle is less than 0' do
        subject.image_angle = '-90'
        expect(subject).to be_rotated
      end

      it 'is true if the image_angle is greater than 0' do
        subject.image_angle = '90'
        expect(subject).to be_rotated
      end
    end

    describe '#scaled?' do
      it 'is false if the image_scale is nil' do
        subject.image_scale = nil
        expect(subject).not_to be_scaled
      end

      it 'is false if the image_scale is blank' do
        subject.image_scale = ''
        expect(subject).not_to be_scaled
      end

      it 'is false if the image_scale is 0' do
        subject.image_scale = '0'
        expect(subject).not_to be_scaled
      end

      it 'is false if the image_scale is less than 0' do
        subject.image_scale = '-0.00001'
        expect(subject).not_to be_scaled
      end

      it 'is true if the image_scale is greater than 0' do
        subject.image_scale = '0.00001'
        expect(subject).to be_scaled
      end
    end

    describe '#cropped?' do
      it 'is false if the image_w and the image_h are nil' do
        subject.image_w = nil
        subject.image_h = nil
        expect(subject).not_to be_cropped
      end

      it 'is false if the image_w is not nil but the image_h is nil' do
        subject.image_w = '1'
        subject.image_h = nil
        expect(subject).not_to be_cropped
      end

      it 'is false if the image_w is nil but the image_h is not nil' do
        subject.image_w = nil
        subject.image_h = '1'
        expect(subject).not_to be_cropped
      end

      it 'is false if the image_w and the image_h are blank' do
        subject.image_w = ''
        subject.image_h = ''
        expect(subject).not_to be_cropped
      end

      it 'is false if the image_w is not blank but the image_h is blank' do
        subject.image_w = '1'
        subject.image_h = ''
        expect(subject).not_to be_cropped
      end

      it 'is false if the image_w is blank but the image_h is not blank' do
        subject.image_w = ''
        subject.image_h = '1'
        expect(subject).not_to be_cropped
      end

      it 'is false if the image_w and the image_h are both 0' do
        subject.image_w = '0'
        subject.image_h = '0'
        expect(subject).not_to be_cropped
      end

      it 'is false if the image_w is not 0 but the image_h is 0' do
        subject.image_w = '1'
        subject.image_h = '0'
        expect(subject).not_to be_cropped
      end

      it 'is false if the image_w is 0 but the image_h is not 0' do
        subject.image_w = '0'
        subject.image_h = '1'
        expect(subject).not_to be_cropped
      end

      it 'is false if the image_w and the image_h are both less than 0' do
        subject.image_w = '-1'
        subject.image_h = '-1'
        expect(subject).not_to be_cropped
      end

      it 'is false if the image_w is not less than 0 but the image_h is less than 0' do
        subject.image_w = '1'
        subject.image_h = '-1'
        expect(subject).not_to be_cropped
      end

      it 'is false if the image_w is less than 0 but the image_h is not less than 0' do
        subject.image_w = '-1'
        subject.image_h = '1'
        expect(subject).not_to be_cropped
      end

      it 'is true if the image_w and the image_h are both greater than 0' do
        subject.image_w = '1'
        subject.image_h = '1'
        expect(subject).to be_cropped
      end
    end

    describe '#image_modified?' do
      it 'is false if the image has not been rotated, scaled or cropped' do
        subject.image_angle = '0'
        subject.image_scale = '0'
        subject.image_w     = '0'
        subject.image_h     = '0'

        expect(subject.image_modified?).to be_falsy
      end

      it 'is true if the image has been rotated' do
        subject.image_angle = '90'
        subject.image_scale = '0'
        subject.image_w     = '0'
        subject.image_h     = '0'

        expect(subject.image_modified?).to be_truthy
      end

      it 'is true if the image has been scaled' do
        subject.image_angle = '0'
        subject.image_scale = '0.12345'
        subject.image_w     = '0'
        subject.image_h     = '0'

        expect(subject.image_modified?).to be_truthy
      end

      it 'is true if the image has been cropped' do
        subject.image_angle = '0'
        subject.image_scale = '0'
        subject.image_w     = '5'
        subject.image_h     = '12'

        expect(subject.image_modified?).to be_truthy
      end
    end

    describe '#process_image' do
      let(:now)              { Time.now }
      let(:old)              { 2.days.ago }
      let(:image)            { nil }
      let(:previous_changes) { {} }
      let(:image_modified)   { false }

      subject { Fabricate(:user, avatar: image, updated_at: old) }

      before :each do
        allow(subject.avatar).to receive(:recreate_versions!)
        allow(subject).to receive(:save)
        allow(subject).to receive(:image_modified?).and_return(image_modified)
        allow(subject).to receive(:previous_changes).and_return(previous_changes)
      end

      context 'when image has been modified' do
        let(:image_modified) { true }

        context 'and there is not an attached image' do
          let(:image) { nil }

          before :each do
            Timecop.freeze(now) do
              @result = subject.process_image
            end
          end

          context 'and there were not previously changes to the image' do
            let(:previous_changes) { {} }

            it 'does not recreate the image versions' do
              expect(subject.avatar).not_to have_received(:recreate_versions!)
            end
          end

          context 'and there were previously changes to the image' do
            let(:previous_changes) { {avatar: []} }

            it 'does not recreate the image versions' do
              expect(subject.avatar).not_to have_received(:recreate_versions!)
            end
          end
        end

        context 'and there is already an attached image' do
          let(:image) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.jpg')) }

          before :each do
            Timecop.freeze(now) do
              @result = subject.process_image
            end
          end

          context 'and there were not previously changes to the image' do
            let(:previous_changes) { {} }

            it 'recreates the image versions' do
              expect(subject.avatar).to have_received(:recreate_versions!)
            end
          end

          context 'and there were previously changes to the image' do
            let(:previous_changes) { {avatar: []} }

            it 'does not recreate the image versions' do
              expect(subject.avatar).not_to have_received(:recreate_versions!)
            end
          end
        end

        it 'changes updated at' do
          Timecop.freeze(now) do
            @result = subject.process_image
          end
          expect(subject.updated_at).to eql(now)
        end

        it 'saves the record so that the image is properly updated' do
          Timecop.freeze(now) do
            @result = subject.process_image
          end
          expect(subject).to have_received(:save).once
        end

        context 'when the save is successful' do
          before :each do
            allow(subject).to receive(:save).and_return(true)
            Timecop.freeze(now) do
              @result = subject.process_image
            end
          end

          it 'returns true' do
            expect(@result).to be_truthy
          end
        end

        context 'when the save fails' do
          before :each do
            allow(subject).to receive(:save).and_return(false)
            Timecop.freeze(now) do
              @result = subject.process_image
            end
          end

          it 'returns false' do
            expect(@result).to be_falsy
          end
        end
      end

      context 'when image has not been modified' do
        let(:image_modified) { false }

        before :each do
          Timecop.freeze(now) do
            @result = subject.process_image
          end
        end

        context 'and there is not an attached image' do
          let(:image) { nil }

          context 'and there were not previously changes to the image' do
            let(:previous_changes) { {} }

            it 'does not recreate the image versions' do
              expect(subject.avatar).not_to have_received(:recreate_versions!)
            end
          end

          context 'and there were previously changes to the image' do
            let(:previous_changes) { {avatar: []} }

            it 'does not recreate the image versions' do
              expect(subject.avatar).not_to have_received(:recreate_versions!)
            end
          end
        end

        context 'and there is already an attached image' do
          let(:image) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.jpg')) }

          context 'and there were not previously changes to the image' do
            let(:previous_changes) { {} }

            it 'does not recreate the image versions' do
              expect(subject.avatar).not_to have_received(:recreate_versions!)
            end
          end

          context 'and there were previously changes to the image' do
            let(:previous_changes) { {avatar: []} }

            it 'does not recreate the image versions' do
              expect(subject.avatar).not_to have_received(:recreate_versions!)
            end
          end
        end

        it 'does not change updated at' do
          expect(subject.updated_at).to eql(old)
        end

        it 'does not recreate the image versions' do
          expect(subject.avatar).not_to have_received(:recreate_versions!)
        end

        it 'returns true' do
          expect(@result).to be_truthy
        end
      end
    end
  end

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
end
