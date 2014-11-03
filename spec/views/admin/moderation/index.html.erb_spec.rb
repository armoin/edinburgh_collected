require 'rails_helper'

describe "admin/moderation/index.html.erb" do
  let(:stub_memories) { Array.new(3) {|n| Fabricate.build(:photo_memory, id: n+1) } }

  before :each do
    assign(:memories, stub_memories)
    render
  end

  it "shows each of the given memories" do
    expect(rendered).to have_css('.memory', count: 3)
  end

  describe 'a memory' do
    let(:memory) { stub_memories.first }

    it 'has an approve button' do
      expect(rendered).to have_link('Approve', href: admin_approve_memory_path(memory.id))
    end

    it 'has a reject button' do
      expect(rendered).to have_link('Reject', href: admin_reject_memory_path(memory.id))
    end

    context 'when photo memory' do
      it 'shows the image' do
        expect(rendered).to have_css('img', count: 3)
      end
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

