RSpec.shared_examples 'moderatable' do
  let(:moderatable_instance) { Fabricate(moderatable_factory) }

  describe "scopes" do
    let!(:no_moderation) { Fabricate(moderatable_factory) }
    let!(:unmoderated)   { Fabricate(moderatable_factory) }
    let!(:approved)      { Fabricate(moderatable_factory) }
    let!(:rejected)      { Fabricate(moderatable_factory) }

    before :each do
      unmoderated.unmoderate!
      approved.approve!
      rejected.reject!
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
    describe "#current_state" do
      it "provides the default state if no moderation records are found" do
        expect(moderatable_instance.current_state).to eql(ModerationStateMachine::DEFAULT_STATE)
      end

      it "provides the to_state of the moderation record if one is found" do
        MemoryModeration.create!(memory: moderatable_instance, from_state: 'unmoderated', to_state: 'approved')
        expect(moderatable_instance.current_state).to eql('approved')
      end

      it "provides the to_state of the latest moderation record if more than one is found" do
        MemoryModeration.create!(memory: moderatable_instance, from_state: 'unmoderated', to_state: 'approved')
        MemoryModeration.create!(memory: moderatable_instance, from_state: 'approved', to_state: 'rejected')
        expect(moderatable_instance.current_state).to eql('rejected')
      end
    end

    describe "#approve!" do
      it "changes the moderation state to 'approved'" do
        moderatable_instance.approve!
        expect(moderatable_instance.current_state).to eql('approved')
      end
    end

    describe "#reject!" do
      it "changes the moderation state to 'rejected'" do
        moderatable_instance.reject!
        expect(moderatable_instance.current_state).to eql('rejected')
      end
    end

    describe "#unmoderate!" do
      it "changes the moderation state to 'unmoderated'" do
        moderatable_instance.unmoderate!
        expect(moderatable_instance.current_state).to eql('unmoderated')
      end
    end
  end
end

