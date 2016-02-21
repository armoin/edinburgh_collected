RSpec.shared_examples 'moderatable' do
  let(:moderatable_instance) { Fabricate(moderatable_factory) }
  let(:moderated_by)         { Fabricate.build(:approved_user, id: 789) }

  describe "logging moderation activity" do
    it { expect(subject).to have_many(:moderation_logs).dependent(:destroy) }
  end

  describe 'validation' do
    describe '#moderation_reason' do
      context 'when moderation state is not in states that require a reason' do
        before :each do
          moderatable_instance.moderation_state = 'not in list'
        end

        it 'is valid if present' do
          moderatable_instance.moderation_reason = 'a reason'
          expect(moderatable_instance).to be_valid
        end

        it 'is valid is blank' do
          moderatable_instance.moderation_reason = ''
          expect(moderatable_instance).to be_valid
        end

        it 'is valid if nil' do
          moderatable_instance.moderation_reason = nil
          expect(moderatable_instance).to be_valid
        end
      end

      context 'when moderation state is in states that require a reason' do
        ModerationStateMachine::REQUIRE_REASON.each do |state|
          before :each do
            moderatable_instance.moderation_state = state
          end

          it 'is valid if present' do
            moderatable_instance.moderation_reason = 'a reason'
            expect(moderatable_instance).to be_valid
          end

          it 'is valid is blank' do
            moderatable_instance.moderation_reason = ''
            expect(moderatable_instance).to be_invalid
            expect(moderatable_instance.errors[:moderation_reason]).to include("can't be blank")
          end

          it 'is valid if nil' do
            moderatable_instance.moderation_reason = nil
            expect(moderatable_instance).to be_invalid
            expect(moderatable_instance.errors[:moderation_reason]).to include("can't be blank")
          end
        end
      end
    end
  end

  ##
  # TODO: clean this up. Had to branch this "shared" example as User works differently from
  #       other moderatables
  describe "scopes" do
    let(:owner) { Fabricate(:approved_user) }
    let(:other) { Fabricate(:approved_user) }

    before :each do
      @no_moderation = Fabricate(moderatable_factory, moderation_state: nil)
      @unmoderated   = Fabricate(moderatable_factory, moderation_state: 'unmoderated')

      @approved_owner = Fabricate(moderatable_factory, user: owner, moderation_state: 'approved')
      @approved_other = Fabricate(moderatable_factory, user: other, moderation_state: 'approved')
      @reported       = Fabricate(moderatable_factory, user: owner, moderation_state: 'reported', moderation_reason: 'test')

      @blocked  = Fabricate(moderatable_factory, moderation_state: 'blocked')
      @rejected = Fabricate(moderatable_factory, moderation_state: 'rejected', moderation_reason: 'test')
    end

    describe '.in_state' do
      it 'returns records if there are any in the given state' do
        expect(moderatable_model.in_state('unmoderated').count).to eql(2)
        expect(moderatable_model.in_state('approved').count).to eql(2)
        expect(moderatable_model.in_state('rejected').count).to eql(1)
        expect(moderatable_model.in_state('reported').count).to eql(1)
        expect(moderatable_model.in_state('blocked').count).to eql(1)
      end

      it 'returns no records if there are none in the given state' do
        expect(moderatable_model.in_state('nonsense').count).to eql(0)
      end
    end

    describe '.moderated' do
      it 'returns all records that are not unmoderated' do
        moderated_records = moderatable_model.moderated
        expect(moderated_records.count).to eql(5)
        expect(moderated_records).to include(@approved_owner)
        expect(moderated_records).to include(@approved_other)
        expect(moderated_records).to include(@rejected)
        expect(moderated_records).to include(@reported)
        expect(moderated_records).to include(@blocked)
      end
    end

    describe '.unmoderated' do
      it 'only returns unmoderated records' do
        unmoderated_records = moderatable_model.unmoderated
        expect(unmoderated_records.count).to eql(2)
        expect(unmoderated_records).to include(@no_moderation)
        expect(unmoderated_records).to include(@unmoderated)
      end
    end

    describe '.rejected' do
      it 'returns just the rejected record' do
        rejected_records = moderatable_model.rejected
        expect(rejected_records.count).to eql(1)
        expect(rejected_records).to include(@rejected)
      end
    end

    describe '.reported' do
      it 'returns just the reported record' do
        reported_records = moderatable_model.reported
        expect(reported_records.count).to eql(1)
        expect(reported_records).to include(@reported)
      end
    end

    describe '.blocked' do
      it 'returns just the blocked record' do
        blocked_records = moderatable_model.blocked
        expect(blocked_records.count).to eql(1)
        expect(blocked_records).to include(@blocked)
      end
    end

    describe '.publicly_visible' do
      context 'when owner is pending' do
        let(:owner) { Fabricate(:pending_user) }

        it 'returns no records for owner' do
          publicly_visible_records = moderatable_model.publicly_visible
          expect(publicly_visible_records.count).to eql(1)
          expect(publicly_visible_records).to include(@approved_other)
          expect(publicly_visible_records).not_to include(@approved_owner)
        end
      end

      context 'when owner is active' do
        context 'but unmoderated' do
          let(:owner) { Fabricate(:unmoderated_user) }

          it 'returns no records for owner' do
            publicly_visible_records = moderatable_model.publicly_visible
            expect(publicly_visible_records.count).to eql(1)
            expect(publicly_visible_records).to include(@approved_other)
            expect(publicly_visible_records).not_to include(@approved_owner)
          end
        end

        context 'but blocked' do
          let(:owner) { Fabricate(:blocked_user) }

          it 'returns no records for owner' do
            publicly_visible_records = moderatable_model.publicly_visible
            expect(publicly_visible_records.count).to eql(1)
            expect(publicly_visible_records).to include(@approved_other)
            expect(publicly_visible_records).not_to include(@approved_owner)
          end
        end

        context 'and reported' do
          let(:owner) { Fabricate(:reported_user) }

          it 'returns all publicly visible records' do
            publicly_visible_records = moderatable_model.publicly_visible
            expect(publicly_visible_records.count).to eql(3)
            expect(publicly_visible_records).to include(@approved_other)
            expect(publicly_visible_records).to include(@approved_owner)
            expect(publicly_visible_records).to include(@reported)
          end
        end

        context 'and approved' do
          let(:owner) { Fabricate(:approved_user) }

          it 'returns all publicly visible records' do
            publicly_visible_records = moderatable_model.publicly_visible
            expect(publicly_visible_records.count).to eql(3)
            expect(publicly_visible_records).to include(@approved_other)
            expect(publicly_visible_records).to include(@approved_owner)
            expect(publicly_visible_records).to include(@reported)
          end
        end
      end
    end
  end

  describe 'ordering' do
    let!(:second_moderated) { Fabricate(moderatable_factory, last_moderated_at: 2.days.ago) }
    let!(:first_moderated)  { Fabricate(moderatable_factory, last_moderated_at: 3.days.ago) }
    let!(:last_moderated)   { Fabricate(moderatable_factory, last_moderated_at: 1.days.ago) }

    describe '.by_last_moderated' do
      it 'returns the scoped models in the order that they were moderated' do
        expect(moderatable_model.by_last_moderated.first).to eql(last_moderated)
        expect(moderatable_model.by_last_moderated.second).to eql(second_moderated)
        expect(moderatable_model.by_last_moderated.last).to eql(first_moderated)
      end
    end

    describe '.by_last_reported' do
      it 'returns the scoped models in the order that they were reported' do
        expect(moderatable_model.by_last_reported.first).to eql(last_moderated)
        expect(moderatable_model.by_last_reported.second).to eql(second_moderated)
        expect(moderatable_model.by_last_reported.last).to eql(first_moderated)
      end
    end
  end

  describe "moderation state" do
    describe "#approve!" do
      it "changes the moderation state to 'approved'" do
        moderatable_instance.approve!(moderated_by)
        expect(moderatable_instance.moderation_state).to eql('approved')
      end

      it "adds the given user as the moderated by user" do
        moderatable_instance.approve!(moderated_by)
        expect(moderatable_instance.moderated_by).to eql(moderated_by)
      end

      it "adds a last_moderated_at date" do
        expect(moderatable_instance.last_moderated_at).to be_nil
        moderatable_instance.approve!(moderated_by)
        expect(moderatable_instance.last_moderated_at).not_to be_nil
      end

      it "adds a moderation record to track the moderation" do
        expect {
          moderatable_instance.approve!(moderated_by)
        }.to change{moderatable_instance.moderation_logs.count}.by(1)
      end
    end

    describe "#reject!" do
      it "changes the moderation state to 'rejected'" do
        moderatable_instance.reject!(moderated_by, 'unsuitable')
        expect(moderatable_instance.moderation_state).to eql('rejected')
      end

      it "adds the given user as the moderated by user" do
        moderatable_instance.reject!(moderated_by)
        expect(moderatable_instance.moderated_by).to eql(moderated_by)
      end

      it "stores the reason if one is given" do
        moderatable_instance.reject!(moderated_by, 'unsuitable')
        expect(moderatable_instance.moderation_reason).to eql('unsuitable')
      end

      it "a blank reason if none is given" do
        moderatable_instance.reject!(moderated_by)
        expect(moderatable_instance.moderation_reason).to eql('')
      end

      it "adds a last_moderated_at date" do
        expect(moderatable_instance.last_moderated_at).to be_nil
        moderatable_instance.reject!(moderated_by)
        expect(moderatable_instance.last_moderated_at).not_to be_nil
      end

      it "adds a moderation record to track the moderation" do
        expect {
          moderatable_instance.reject!(moderated_by)
        }.to change{moderatable_instance.moderation_logs.count}.by(1)
      end
    end

    describe "#report!" do
      it "changes the moderation state to 'reported'" do
        moderatable_instance.report!(moderated_by, 'I am offended!')
        expect(moderatable_instance.moderation_state).to eql('reported')
      end

      it "adds the given user as the moderated by user" do
        moderatable_instance.report!(moderated_by)
        expect(moderatable_instance.moderated_by).to eql(moderated_by)
      end

      it "stores the reason if one is given" do
        moderatable_instance.report!(moderated_by, 'I am offended!')
        expect(moderatable_instance.moderation_reason).to eql('I am offended!')
      end

      it "a blank reason if none is given" do
        moderatable_instance.report!(moderated_by)
        expect(moderatable_instance.moderation_reason).to eql('')
      end

      it "adds a last_moderated_at date" do
        expect(moderatable_instance.last_moderated_at).to be_nil
        moderatable_instance.report!(moderated_by)
        expect(moderatable_instance.last_moderated_at).not_to be_nil
      end

      it "adds a moderation record to track the moderation" do
        expect {
          moderatable_instance.report!(moderated_by)
        }.to change{moderatable_instance.moderation_logs.count}.by(1)
      end
    end

    describe "#unmoderate!" do
      it "changes the moderation state to 'unmoderated'" do
        moderatable_instance.moderation_state = 'approved'
        expect(moderatable_instance.moderation_state).to eql('approved')
        moderatable_instance.unmoderate!(moderated_by)
        expect(moderatable_instance.moderation_state).to eql('unmoderated')
      end

      it "adds the given user as the moderated by user" do
        moderatable_instance.unmoderate!(moderated_by)
        expect(moderatable_instance.moderated_by).to eql(moderated_by)
      end

      it "adds a last_moderated_at date" do
        expect(moderatable_instance.last_moderated_at).to be_nil
        moderatable_instance.unmoderate!(moderated_by)
        expect(moderatable_instance.last_moderated_at).not_to be_nil
      end

      it "adds a moderation record to track the moderation" do
        expect {
          moderatable_instance.unmoderate!(moderated_by)
        }.to change{moderatable_instance.moderation_logs.count}.by(1)
      end
    end

    describe "#publicly_visible?" do
      let(:user_double) { double(User, publicly_visible?: visible) }

      before :each do
        allow(moderatable_instance).to receive(:user).and_return(user_double)
      end

      context 'when user is not publicly visible' do
        let(:visible) { false }

        context 'and moderatable is unmoderated' do
          it 'is not publicly visible' do
            moderatable_instance.moderation_state = 'unmoderated'
            expect(moderatable_instance.publicly_visible?).to be_falsy
          end
        end

        context 'and moderatable is approved' do
          it 'is not publicly visible' do
            moderatable_instance.moderation_state = 'approved'
            expect(moderatable_instance.publicly_visible?).to be_falsy
          end
        end

        context 'and moderatable is blocked' do
          it 'is not publicly visible' do
            moderatable_instance.moderation_state = 'blocked'
            expect(moderatable_instance.publicly_visible?).to be_falsy
          end
        end

        context 'and moderatable is rejected' do
          it 'is not publicly visible' do
            moderatable_instance.moderation_state = 'rejected'
            expect(moderatable_instance.publicly_visible?).to be_falsy
          end
        end

        context 'and moderatable is reported' do
          it 'is not publicly visible' do
            moderatable_instance.moderation_state = 'reported'
            expect(moderatable_instance.publicly_visible?).to be_falsy
          end
        end
      end

      context 'when user is publicly visible' do
        let(:visible) { true }

        context 'and moderatable is unmoderated' do
          it 'is not publicly visible' do
            moderatable_instance.moderation_state = 'unmoderated'
            expect(moderatable_instance.publicly_visible?).to be_falsy
          end
        end

        context 'and moderatable is approved' do
          it 'is publicly visible' do
            moderatable_instance.moderation_state = 'approved'
            expect(moderatable_instance.publicly_visible?).to be_truthy
          end
        end

        context 'and moderatable is blocked' do
          it 'is not publicly visible' do
            moderatable_instance.moderation_state = 'blocked'
            expect(moderatable_instance.publicly_visible?).to be_falsy
          end
        end

        context 'and moderatable is rejected' do
          it 'is not publicly visible' do
            moderatable_instance.moderation_state = 'rejected'
            expect(moderatable_instance.publicly_visible?).to be_falsy
          end
        end

        context 'and moderatable is reported' do
          it 'is publicly visible' do
            moderatable_instance.moderation_state = 'reported'
            expect(moderatable_instance.publicly_visible?).to be_truthy
          end
        end
      end
    end

    describe "#unmoderated?" do
      it 'is false when not unmoderated' do
        moderatable_instance.approve!(moderated_by)
        expect(moderatable_instance.unmoderated?).to be_falsy
      end

      it 'is true when unmoderated' do
        moderatable_instance.unmoderate!(moderated_by)
        expect(moderatable_instance.unmoderated?).to be_truthy
      end
    end

    describe "#blocked?" do
      it 'is false when not blocked' do
        moderatable_instance.approve!(moderated_by)
        expect(moderatable_instance.blocked?).to be_falsy
      end

      it 'is true when blocked' do
        moderatable_instance.block!(moderated_by)
        expect(moderatable_instance.blocked?).to be_truthy
      end
    end

    describe "#rejected?" do
      it 'is false when not rejected' do
        moderatable_instance.approve!(moderated_by)
        expect(moderatable_instance.rejected?).to be_falsy
      end

      it 'is true when rejected' do
        moderatable_instance.reject!(moderated_by, 'test')
        expect(moderatable_instance.rejected?).to be_truthy
      end
    end
  end
end

