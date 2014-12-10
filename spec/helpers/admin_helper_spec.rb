require 'rails_helper'

describe AdminHelper do
  describe '#show_moderation_panel?' do
    it 'is true if the current index path is admin/moderated' do
      allow(helper).to receive(:current_memory_index_path).and_return('/admin/moderated')
      expect(helper.show_moderation_panel?).to be_truthy
    end

    it 'is true if the current index path is admin/unmoderated' do
      allow(helper).to receive(:current_memory_index_path).and_return('/admin/unmoderated')
      expect(helper.show_moderation_panel?).to be_truthy
    end

    it 'is false if the current controller is not a moderation one' do
      allow(helper).to receive(:current_memory_index_path).and_return('/memories')
      expect(helper.show_moderation_panel?).to be_falsy
    end
  end
end

