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
      rejected.reject!('test')
    end

    describe '.by_state' do
      it 'returns records if there are any in the given state' do
        expect(moderatable_model.by_state('unmoderated').count).to eql(2)
        expect(moderatable_model.by_state('approved').count).to eql(1)
        expect(moderatable_model.by_state('rejected').count).to eql(1)
      end

      it 'returns rno ecords if there are none in the given state' do
        expect(moderatable_model.by_state('nonsense').count).to eql(0)
      end
    end

    describe '.moderated' do
      it 'returns all records that are not moderated' do
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
    describe "#previous_state" do
      it "provides the default state if no moderation records are found" do
        expect(moderatable_instance.previous_state).to eql(ModerationStateMachine::DEFAULT_STATE)
      end

      it "provides the from_state of the moderation record if one is found" do
        MemoryModeration.create!(memory: moderatable_instance, from_state: 'unmoderated', to_state: 'approved')
        expect(moderatable_instance.previous_state).to eql('unmoderated')
      end

      it "provides the from_state of the latest moderation record if more than one is found" do
        MemoryModeration.create!(memory: moderatable_instance, from_state: 'unmoderated', to_state: 'approved')
        MemoryModeration.create!(memory: moderatable_instance, from_state: 'approved', to_state: 'rejected')
        expect(moderatable_instance.previous_state).to eql('approved')
      end
    end

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

    describe "#current_state_reason" do
      it "is nil if no moderation records are found" do
        expect(moderatable_instance.current_state_reason).to be_nil
      end

      it "is nil if the moderation record found has no comment" do
        MemoryModeration.create!(memory: moderatable_instance, from_state: 'unmoderated', to_state: 'approved')
        expect(moderatable_instance.current_state_reason).to be_nil
      end

      it "provides the to_state of the moderation record if one is found" do
        MemoryModeration.create!(memory: moderatable_instance, from_state: 'unmoderated', to_state: 'approved', comment: 'test comment')
        expect(moderatable_instance.current_state_reason).to eql('test comment')
      end

      it "provides the to_state of the latest moderation record if more than one is found" do
        MemoryModeration.create!(memory: moderatable_instance, from_state: 'unmoderated', to_state: 'approved', comment: 'first comment')
        MemoryModeration.create!(memory: moderatable_instance, from_state: 'approved', to_state: 'rejected', comment: 'last comment')
        expect(moderatable_instance.current_state_reason).to eql('last comment')
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
        moderatable_instance.reject!('unsuitable')
        expect(moderatable_instance.current_state).to eql('rejected')
      end

      it "stores the given reason" do
        moderatable_instance.reject!('unsuitable')
        expect(moderatable_instance.moderation_records.last.comment).to eql('unsuitable')
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

