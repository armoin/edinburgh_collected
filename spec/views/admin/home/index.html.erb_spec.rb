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

      it "has a Moderated memories link" do
        render
        expect(rendered).to have_link("Moderated", href: moderated_admin_moderation_memories_path)
      end
    end
  end
end

