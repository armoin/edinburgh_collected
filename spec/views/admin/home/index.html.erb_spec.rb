require 'rails_helper'

describe "admin/home/index.html.erb" do
  describe 'Moderation Inbox' do
    describe 'memories' do
      describe 'has an Unmoderated memories link' do
        before :each do
          allow(Memory).to receive(:unmoderated).and_return( Array.new(memory_count) {|m| Fabricate.build(:memory)} )
          render
        end

        context 'when there are no unmoderated memories' do
          let(:memory_count) { 0 }

          it 'includes a memory count of 0' do
            expect(rendered).to have_link("Unmoderated (0)", href: admin_moderation_memories_path)
          end
        end

        context 'when there is one unmoderated memory' do
          let(:memory_count) { 1 }

          it 'includes a memory count of 1' do
            expect(rendered).to have_link("Unmoderated (1)", href: admin_moderation_memories_path)
          end
        end

        context 'when there are more than one unmoderated memories' do
          let(:memory_count) { 3 }

          it 'includes a memory count matching the number of memories' do
            expect(rendered).to have_link("Unmoderated (3)", href: admin_moderation_memories_path)
          end
        end
      end

      describe 'has a Reported memories link' do
        before :each do
          allow(Memory).to receive(:reported).and_return( Array.new(memory_count) {|m| Fabricate.build(:memory)} )
          render
        end

        context 'when there are no reported memories' do
          let(:memory_count) { 0 }

          it 'includes a memory count of 0' do
            expect(rendered).to have_link("Reported (0)", href: reported_admin_moderation_memories_path)
          end
        end

        context 'when there is one reported memory' do
          let(:memory_count) { 1 }

          it 'includes a memory count of 1' do
            expect(rendered).to have_link("Reported (1)", href: reported_admin_moderation_memories_path)
          end
        end

        context 'when there is more than one reported memory' do
          let(:memory_count) { 3 }

          it 'includes a memory count matching the number of memories' do
            expect(rendered).to have_link("Reported (3)", href: reported_admin_moderation_memories_path)
          end
        end
      end

      it "has a Moderated memories link" do
        render
        expect(rendered).to have_link("Moderated", href: moderated_admin_moderation_memories_path)
      end
    end

    describe 'scrapbooks' do
      describe 'has an Unmoderated scrapbooks link' do
        before :each do
          allow(Scrapbook).to receive(:unmoderated).and_return( Array.new(scrapbook_count) {|m| Fabricate.build(:scrapbook)} )
          render
        end

        context 'when there are no unmoderated scrapbooks' do
          let(:scrapbook_count) { 0 }

          it 'includes a scrapbook count of 0' do
            expect(rendered).to have_link("Unmoderated (0)", href: admin_moderation_scrapbooks_path)
          end
        end

        context 'when there is one unmoderated scrapbook' do
          let(:scrapbook_count) { 1 }

          it 'includes a scrapbook count of 1' do
            expect(rendered).to have_link("Unmoderated (1)", href: admin_moderation_scrapbooks_path)
          end
        end

        context 'when there are more than one unmoderated scrapbooks' do
          let(:scrapbook_count) { 3 }

          it 'includes a scrapbook count matching the number of scrapbooks' do
            expect(rendered).to have_link("Unmoderated (3)", href: admin_moderation_scrapbooks_path)
          end
        end
      end

      describe 'has a Reported scrapbooks link' do
        before :each do
          allow(Scrapbook).to receive(:reported).and_return( Array.new(scrapbook_count) {|m| Fabricate.build(:scrapbook)} )
          render
        end

        context 'when there are no reported scrapbooks' do
          let(:scrapbook_count) { 0 }

          it 'includes a scrapbook count of 0' do
            expect(rendered).to have_link("Reported (0)", href: reported_admin_moderation_scrapbooks_path)
          end
        end

        context 'when there is one reported scrapbook' do
          let(:scrapbook_count) { 1 }

          it 'includes a scrapbook count of 1' do
            expect(rendered).to have_link("Reported (1)", href: reported_admin_moderation_scrapbooks_path)
          end
        end

        context 'when there is more than one reported scrapbook' do
          let(:scrapbook_count) { 3 }

          it 'includes a scrapbook count matching the number of scrapbooks' do
            expect(rendered).to have_link("Reported (3)", href: reported_admin_moderation_scrapbooks_path)
          end
        end
      end

      it "has a Moderated scrapbooks link" do
        render
        expect(rendered).to have_link("Moderated", href: moderated_admin_moderation_scrapbooks_path)
      end
    end

    describe 'users' do
      describe 'has an All users link' do
        before :each do
          allow(User).to receive(:count).and_return(user_count)
          render
        end

        context 'when there are no users' do
          let(:user_count) { 0 }

          it 'includes a user count of 0' do
            expect(rendered).to have_link("All users (0)", href: admin_moderation_users_path)
          end
        end

        context 'when there is one user' do
          let(:user_count) { 1 }

          it 'includes a user count of 1' do
            expect(rendered).to have_link("All users (1)", href: admin_moderation_users_path)
          end
        end

        context 'when there is more than one user' do
          let(:user_count) { 3 }

          it 'includes a user count matching the number of memories' do
            expect(rendered).to have_link("All users (3)", href: admin_moderation_users_path)
          end
        end
      end
    end

    describe 'has a Blocked users link' do
      before :each do
        allow(User).to receive(:blocked).and_return(Array.new(user_count) {|i| Fabricate.build(:blocked_user)} )
        render
      end

      context 'when there are no blocked users' do
        let(:user_count) { 0 }

        it 'includes a user count of 0' do
          expect(rendered).to have_link("Blocked (0)", href: blocked_admin_moderation_users_path)
        end
      end

      context 'when there is one blocked user' do
        let(:user_count) { 1 }

        it 'includes a user count of 1' do
          expect(rendered).to have_link("Blocked (1)", href: blocked_admin_moderation_users_path)
        end
      end

      context 'when there is more than one blocked user' do
        let(:user_count) { 3 }

        it 'includes a user count matching the number of memories' do
          expect(rendered).to have_link("Blocked (3)", href: blocked_admin_moderation_users_path)
        end
      end
    end
  end
end

