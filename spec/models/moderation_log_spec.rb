require 'rails_helper'

RSpec.describe ModerationLog do
  it { expect(subject).to belong_to(:moderatable) }

  describe 'validation' do
    it 'must have a moderatable model' do
      subject.valid?
      expect(subject.errors[:moderatable]).to include("can't be blank")
    end

    it 'must have a moderated by user' do
      subject.valid?
      expect(subject.errors[:moderated_by]).to include("can't be blank")
      subject.moderated_by = Fabricate.build(:user, id: 123)
      subject.valid?
      expect(subject.errors[:moderated_by]).not_to include("can't be blank")
    end

    describe 'from_state' do
      it 'must be present' do
        subject.valid?
        expect(subject.errors[:from_state]).to include("can't be blank")
      end

      it 'must be a valid state' do
        subject.from_state = 'nonsense'
        subject.valid?
        expect(subject.errors[:from_state]).to include("is not a valid state")

        subject.from_state = 'unmoderated'
        subject.valid?
        expect(subject.errors[:from_state]).to be_empty
      end
    end

    describe 'to_state' do
      it 'must be present' do
        subject.valid?
        expect(subject.errors[:to_state]).to include("can't be blank")
      end

      it 'must be a valid state' do
        subject.to_state = 'nonsense'
        subject.valid?
        expect(subject.errors[:to_state]).to include("is not a valid state")

        subject.to_state = 'unmoderated'
        subject.valid?
        expect(subject.errors[:to_state]).to be_empty
      end
    end
  end
end
