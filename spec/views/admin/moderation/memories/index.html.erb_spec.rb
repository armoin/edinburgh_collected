require 'rails_helper'

describe "admin/moderation/memories/index.html.erb" do
  let(:stub_memories) { Array.new(3) {|n| Fabricate.build(:photo_memory, id: n+1) } }

  before :each do
    assign(:memories, stub_memories)
  end

  context 'when viewing either action' do
    before :each do
      render
    end

    it "shows each of the given memories" do
      expect(rendered).to have_css('.memory', count: 3)
    end

    describe 'a memory' do
      let(:memory) { stub_memories.first }

      it 'has an id' do
        expect(rendered).to have_css(".memory[data-id=\"#{memory.id}\"]")
      end

      describe 'current status' do
        it 'shows the current status without a reason if there is no reason' do
          allow(memory).to receive(:current_state).and_return('unmoderated')
          allow(memory).to receive(:current_state_reason).and_return(nil)
          render
          expect(rendered).to have_css('.status.unmoderated', text: 'Unmoderated')
        end

        it 'shows the current status with a reason if there is a reason' do
          allow(memory).to receive(:current_state).and_return('rejected')
          allow(memory).to receive(:current_state_reason).and_return('unsuitable')
          render
          expect(rendered).to have_css('.status.rejected', text: /Rejected\n\s*\(unsuitable\)/m)
        end
      end

      context 'when photo memory' do
        it 'shows the image' do
          expect(rendered).to have_css('img', count: 3)
        end
      end

      it 'has a "View Details" button' do
        expect(rendered).to have_link('View details', href: admin_moderation_memory_path(memory.id))
      end

      it 'shows the title' do
        expect(rendered).to have_css('h2', text: stub_memories.first.title)
      end

      it 'shows the description' do
        expect(rendered).to have_css('p', text: stub_memories.first.description)
      end

      it 'shows the location' do
        expect(rendered).to have_css('p', text: stub_memories.first.location)
      end
    end
  end

  context 'when viewing from the index action' do
    before :each do
      allow(view).to receive(:action_name).and_return('index')
      render
    end

    it "has a link to the Moderated view" do
      expect(rendered).to have_link('Moderated', href: moderated_admin_moderation_memories_path)
    end

    it "does not have a link to the Unmoderated view" do
      expect(rendered).not_to have_link('Unmoderated', href: admin_moderation_memories_path)
    end

    describe 'a memory' do
      let(:memory) { stub_memories.first }

      it 'does not have an unmoderate button' do
        expect(rendered).not_to have_link('Unmoderate', href: unmoderate_admin_moderation_memory_path(memory.id))
      end

      it 'has an approve button' do
        expect(rendered).to have_link('Approve', href: approve_admin_moderation_memory_path(memory.id))
      end

      it 'has a reject - unsuitable button' do
        expect(rendered).to have_link('Reject - unsuitable', href: reject_admin_moderation_memory_path(memory.id))
      end

      it 'has a reject - offensive button' do
        expect(rendered).to have_link('Reject - offensive', href: reject_admin_moderation_memory_path(memory.id))
      end
    end
  end

  context 'when viewing from the moderated action' do
    before :each do
      allow(view).to receive(:action_name).and_return('moderated')
      render
    end

    it "does not have a link to the Moderated view" do
      expect(rendered).not_to have_link('Moderated', href: moderated_admin_moderation_memories_path)
    end

    it "has a link to the Unmoderated view" do
      expect(rendered).to have_link('Unmoderated', href: admin_moderation_memories_path)
    end

    describe 'a memory' do
      let(:memory) { stub_memories.first }

      it 'has an unmoderate button' do
        expect(rendered).to have_link('Unmoderate', href: unmoderate_admin_moderation_memory_path(memory.id))
      end

      it 'does not have an approve button' do
        expect(rendered).not_to have_link('Approve', href: approve_admin_moderation_memory_path(memory.id))
      end

      it 'does not have a reject - unsuitable button' do
        expect(rendered).not_to have_link('Reject - unsuitable', href: reject_admin_moderation_memory_path(memory.id))
      end

      it 'does not have a reject - offensive button' do
        expect(rendered).not_to have_link('Reject - offensive', href: reject_admin_moderation_memory_path(memory.id))
      end
    end
  end
end

