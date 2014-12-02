require 'rails_helper'

describe AdminHelper do
  describe '#show_moderation_panel?' do
    it 'is true if the current controller is a moderation one' do
      allow(helper).to receive(:current_index_path).and_return('/admin/moderation/memories')
      expect(helper.show_moderation_panel?).to be_truthy
    end

    it 'is false if the current controller is not a moderation one' do
      allow(helper).to receive(:current_index_path).and_return('/memories')
      expect(helper.show_moderation_panel?).to be_falsy
    end
  end
end

