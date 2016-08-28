require('rails_helper')

describe DeleteUsers do
  describe ".run" do
    context 'with a single user' do
      let!(:user) do
        Fabricate(:approved_user, moderation_state: moderation_state, last_moderated_at: last_moderated_at)
      end

      before do
        expect(User.count).to eql 1
      end

      context 'when there are no users marked to be deleted' do
        let(:moderation_state) { 'approved' }
        let(:last_moderated_at) { nil }

        it 'does not delete any users' do
          expect { DeleteUsers.run }.not_to change{ User.count }
        end
      end

      context 'when there are users marked to be deleted' do
        let(:moderation_state) { 'deleted' }

        context 'but their last_moderated_at date is within the keep for time' do
          let(:last_moderated_at) { 1.hour.ago }

          it 'does not delete any users' do
            expect { DeleteUsers.run }.not_to change{ User.count }
          end
        end

        context 'and their last_moderated_at date is outwith the keep for time' do
          let(:last_moderated_at) { 2.days.ago }

          it 'deletes the user' do
            expect { DeleteUsers.run }.to change{ User.count }.by(-1)
          end
        end
      end
    end

    context 'with a mix of users' do
      let!(:unmarked)       { Fabricate(:approved_user) }
      let!(:marked_within)  { Fabricate(:deleted_user, last_moderated_at: 1.hour.ago) }
      let!(:marked_outwith) { Fabricate(:deleted_user, last_moderated_at: 2.days.ago) }

      it 'only deletes the marked user that is outwith the keep for time' do
        expect(User.count).to eql 3
        DeleteUsers.run
        users = User.all
        expect(users.count).to eql 2
        expect(users).to include(unmarked)
        expect(users).to include(marked_within)
      end
    end
  end
end
