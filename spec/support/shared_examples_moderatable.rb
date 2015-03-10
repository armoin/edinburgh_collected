RSpec.shared_examples 'moderatable' do
  let(:moderatable_instance) { Fabricate(moderatable_factory) }

  describe "logging moderation activity" do
    it { expect(subject).to have_many(:moderation_logs) }
  end

  describe "scopes" do
    let!(:no_moderation) { Fabricate(moderatable_factory) }
    let!(:unmoderated)   { Fabricate(moderatable_factory) }
    let!(:approved)      { Fabricate(moderatable_factory) }
    let!(:rejected)      { Fabricate(moderatable_factory) }

    before :each do
      unmoderated.unmoderate!
      approved.approve!
      rejected.reject!('test')
    end

    describe '.in_state' do
      it 'returns records if there are any in the given state' do
        expect(moderatable_model.in_state('unmoderated').count).to eql(2)
        expect(moderatable_model.in_state('approved').count).to eql(1)
        expect(moderatable_model.in_state('rejected').count).to eql(1)
      end

      it 'returns no records if there are none in the given state' do
        expect(moderatable_model.in_state('nonsense').count).to eql(0)
      end
    end

    describe '.moderated' do
      it 'returns all records that are not unmoderated' do
        moderated_records = moderatable_model.moderated
        expect(moderated_records.count).to eql(2)
        expect(moderated_records).to include(approved)
        expect(moderated_records).to include(rejected)
      end
    end

    describe '.unmoderated' do
      it 'only returns unmoderated records' do
        unmoderated_records = moderatable_model.unmoderated
        expect(unmoderated_records.count).to eql(2)
        expect(unmoderated_records).to include(no_moderation)
        expect(unmoderated_records).to include(unmoderated)
      end
    end

    describe '.approved' do
      it 'only returns approved records' do
        approved_records = moderatable_model.approved
        expect(approved_records.count).to eql(1)
        expect(approved_records).to include(approved)
      end
    end

    describe '.rejected' do
      it 'only returns rejected records' do
        rejected_records = moderatable_model.rejected
        expect(rejected_records.count).to eql(1)
        expect(rejected_records).to include(rejected)
      end
    end
  end

  describe "moderation state" do
    describe "#approve!" do
      it "changes the moderation state to 'approved'" do
        moderatable_instance.approve!
        expect(moderatable_instance.moderation_state).to eql('approved')
      end

      it "adds a last_moderated_at date" do
        expect(moderatable_instance.last_moderated_at).to be_nil
        moderatable_instance.approve!
        expect(moderatable_instance.last_moderated_at).not_to be_nil
      end

      it "adds a moderation record to track the moderation" do
        expect {
          moderatable_instance.approve!
        }.to change{moderatable_instance.moderation_logs.count}.by(1)
      end
    end

    describe "#reject!" do
      it "changes the moderation state to 'rejected'" do
        moderatable_instance.reject!('unsuitable')
        expect(moderatable_instance.moderation_state).to eql('rejected')
      end

      it "stores the reason if one is given" do
        moderatable_instance.reject!('unsuitable')
        expect(moderatable_instance.moderation_reason).to eql('unsuitable')
      end

      it "a blank reason if none is given" do
        moderatable_instance.reject!
        expect(moderatable_instance.moderation_reason).to eql('')
      end

      it "adds a last_moderated_at date" do
        expect(moderatable_instance.last_moderated_at).to be_nil
        moderatable_instance.reject!
        expect(moderatable_instance.last_moderated_at).not_to be_nil
      end

      it "adds a moderation record to track the moderation" do
        expect {
          moderatable_instance.reject!
        }.to change{moderatable_instance.moderation_logs.count}.by(1)
      end
    end

    describe "#unmoderate!" do
      it "changes the moderation state to 'unmoderated'" do
        moderatable_instance.moderation_state = 'approved'
        expect(moderatable_instance.moderation_state).to eql('approved')
        moderatable_instance.unmoderate!
        expect(moderatable_instance.moderation_state).to eql('unmoderated')
      end

      it "adds a last_moderated_at date" do
        expect(moderatable_instance.last_moderated_at).to be_nil
        moderatable_instance.unmoderate!
        expect(moderatable_instance.last_moderated_at).not_to be_nil
      end

      it "adds a moderation record to track the moderation" do
        expect {
          moderatable_instance.unmoderate!
        }.to change{moderatable_instance.moderation_logs.count}.by(1)
      end
    end

    describe "#approved?" do
      it 'is false when not approved' do
        expect(moderatable_instance.approved?).to be_falsy
      end

      it 'is true when approved' do
        moderatable_instance.approve!
        expect(moderatable_instance.approved?).to be_truthy
      end
    end

    describe "#unmoderated?" do
      it 'is false when not unmoderated' do
        moderatable_instance.approve!
        expect(moderatable_instance.unmoderated?).to be_falsy
      end

      it 'is true when unmoderated' do
        expect(moderatable_instance.unmoderated?).to be_truthy
      end
    end
  end
end

