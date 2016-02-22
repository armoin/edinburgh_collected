require 'rails_helper'

RSpec.describe ModerationListPresenter do
  let(:items)       { double(:items) }
  let(:item_name)   { 'the item' }
  let(:action_name) { 'index' }

  subject(:presenter) { described_class.new(items, item_name, action_name) }

  describe '#items' do
    it 'presents the given items as is' do
      expect(presenter.items).to eq(items)
    end
  end

  describe '#title' do
    it 'presents the given item_name capitalized' do
      expect(presenter.title).to eq('The item')
    end
  end

  describe '#show_memories?' do
    context 'when the items are scrapbooks' do
      let(:item_name) { 'scrapbooks' }

      it 'is true' do
        expect(presenter.show_memories?).to eq(true)
      end
    end

    context 'when the items are not scrapbooks' do
      let(:item_name) { 'memories' }

      it 'is true' do
        expect(presenter.show_memories?).to eq(false)
      end
    end
  end

  describe '#moderated_col_name' do
    context 'when the action name is "index"' do
      let(:action_name) { 'index' }

      it 'is "Moderated"' do
        expect(presenter.moderated_col_name).to eq('Moderated')
      end
    end

    context 'when the action name is "moderated"' do
      let(:action_name) { 'moderated' }

      it 'is "Moderated"' do
        expect(presenter.moderated_col_name).to eq('Moderated')
      end
    end

    context 'when action_name is "reported"' do
      let(:action_name) { 'reported' }

      it 'is "Reported"' do
        expect(presenter.moderated_col_name).to eq('Reported')
      end
    end
  end

  describe '#moderated_by_col_name' do
    context 'when the action name is "index"' do
      let(:action_name) { 'index' }

      it 'is "Moderated by"' do
        expect(presenter.moderated_by_col_name).to eq('Moderated by')
      end
    end

    context 'when the action name is "moderated"' do
      let(:action_name) { 'moderated' }

      it 'is "Moderated by"' do
        expect(presenter.moderated_by_col_name).to eq('Moderated by')
      end
    end

    context 'when action_name is "reported"' do
      let(:action_name) { 'reported' }

      it 'is "Reported by"' do
        expect(presenter.moderated_by_col_name).to eq('Reported by')
      end
    end
  end

  describe '#unmoderated_path' do
    context 'when the item name is "memories"' do
      let(:item_name) { 'memories' }

      it 'presents the unmoderated memories path' do
        expect(presenter.unmoderated_path).to eq('admin_moderation_memories_path')
      end
    end

    context 'when the action name is "scrapbooks"' do
      let(:item_name) { 'scrapbooks' }

      it 'presents the unmoderated scrapbooks path' do
        expect(presenter.unmoderated_path).to eq('admin_moderation_scrapbooks_path')
      end
    end
  end

  describe '#moderated_path' do
    context 'when the item name is "memories"' do
      let(:item_name) { 'memories' }

      it 'presents the moderated memories path' do
        expect(presenter.moderated_path).to eq('moderated_admin_moderation_memories_path')
      end
    end

    context 'when the action name is "scrapbooks"' do
      let(:item_name) { 'scrapbooks' }

      it 'presents the moderated scrapbooks path' do
        expect(presenter.moderated_path).to eq('moderated_admin_moderation_scrapbooks_path')
      end
    end
  end

  describe '#reported_path' do
    context 'when the item name is "memories"' do
      let(:item_name) { 'memories' }

      it 'presents the reported memories path' do
        expect(presenter.reported_path).to eq('reported_admin_moderation_memories_path')
      end
    end

    context 'when the action name is "scrapbooks"' do
      let(:item_name) { 'scrapbooks' }

      it 'presents the reported scrapbooks path' do
        expect(presenter.reported_path).to eq('reported_admin_moderation_scrapbooks_path')
      end
    end
  end

  describe '#show_path' do
    context 'when the item name is "memories"' do
      let(:item_name) { 'memories' }

      it 'presents the show memory path' do
        expect(presenter.show_path).to eq('admin_moderation_memory_path')
      end
    end

    context 'when the action name is "scrapbooks"' do
      let(:item_name) { 'scrapbooks' }

      it 'presents the show scrapbook path' do
        expect(presenter.show_path).to eq('admin_moderation_scrapbook_path')
      end
    end
  end

  describe '#unmoderated_page?' do
    context 'when the action name is "index"' do
      let(:action_name) { 'index' }

      it 'is true' do
        expect(presenter.unmoderated_page?).to eq(true)
      end
    end

    context 'when the action name is "moderated"' do
      let(:action_name) { 'moderated' }

      it 'is false' do
        expect(presenter.unmoderated_page?).to eq(false)
      end
    end

    context 'when action_name is "reported"' do
      let(:action_name) { 'reported' }

      it 'is false' do
        expect(presenter.unmoderated_page?).to eq(false)
      end
    end
  end

  describe '#moderated_page?' do
    context 'when the action name is "index"' do
      let(:action_name) { 'index' }

      it 'is false' do
        expect(presenter.moderated_page?).to eq(false)
      end
    end

    context 'when the action name is "moderated"' do
      let(:action_name) { 'moderated' }

      it 'is true' do
        expect(presenter.moderated_page?).to eq(true)
      end
    end

    context 'when action_name is "reported"' do
      let(:action_name) { 'reported' }

      it 'is false' do
        expect(presenter.moderated_page?).to eq(false)
      end
    end
  end

  describe '#reported_page?' do
    context 'when the action name is "index"' do
      let(:action_name) { 'index' }

      it 'is false' do
        expect(presenter.reported_page?).to eq(false)
      end
    end

    context 'when the action name is "moderated"' do
      let(:action_name) { 'moderated' }

      it 'is false' do
        expect(presenter.reported_page?).to eq(false)
      end
    end

    context 'when action_name is "reported"' do
      let(:action_name) { 'reported' }

      it 'is true' do
        expect(presenter.reported_page?).to eq(true)
      end
    end
  end
end
