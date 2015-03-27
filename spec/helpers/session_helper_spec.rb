require 'rails_helper'

describe SessionHelper do
  describe '#store_memory_index_path' do
    it 'stores the current request url' do
      expect(session[:current_memory_index_path]).to be_nil
      allow(view).to receive(:request).and_return(double('request', original_fullpath: 'my/memories?page=2'))
      helper.store_memory_index_path
      expect(session[:current_memory_index_path]).to eql('my/memories?page=2')
    end
  end

  describe '#store_scrapbook_index_path' do
    it 'stores the current request url' do
      expect(session[:current_scrapbook_index_path]).to be_nil
      allow(view).to receive(:request).and_return(double('request', original_fullpath: 'my/scrapbooks?page=2'))
      helper.store_scrapbook_index_path
      expect(session[:current_scrapbook_index_path]).to eql('my/scrapbooks?page=2')
    end
  end

  describe '#current_memory_index_path' do
    context 'when session has no current_memory_index_path' do
      it 'returns the default path' do
        expect(helper.current_memory_index_path).to eql(SessionHelper::DEFAULT_MEMORY_PATH)
      end
    end

    context 'when session has a blank current_memory_index_path' do
      before :each do
        session[:current_memory_index_path] = ''
      end

      it 'returns the default path' do
        expect(helper.current_memory_index_path).to eql(SessionHelper::DEFAULT_MEMORY_PATH)
      end
    end

    context 'when session has a current_memory_index_path' do
      before :each do
        session[:current_memory_index_path] = 'my/memories'
      end

      it 'returns the current memory index path' do
        expect(helper.current_memory_index_path).to eql('my/memories')
      end
    end
  end

  describe '#current_scrapbook_index_path' do
    context 'when session has no current_scrapbook_index_path' do
      it 'returns the default path' do
        expect(helper.current_scrapbook_index_path).to eql(SessionHelper::DEFAULT_SCRAPBOOK_PATH)
      end
    end

    context 'when session has a blank current_scrapbook_index_path' do
      before :each do
        session[:current_scrapbook_index_path] = ''
      end

      it 'returns the default path' do
        expect(helper.current_scrapbook_index_path).to eql(SessionHelper::DEFAULT_SCRAPBOOK_PATH)
      end
    end

    context 'when session has a current_scrapbook_index_path' do
      before :each do
        session[:current_scrapbook_index_path] = 'my/scrapbooks'
      end

      it 'returns the current scrapbook index path' do
        expect(helper.current_scrapbook_index_path).to eql('my/scrapbooks')
      end
    end
  end

  describe '#landing_page_for' do
    let(:user) { Fabricate.build(:active_user) }

    before :each do
      allow(user).to receive(:is_admin?).and_return(is_admin)
    end

    context 'when the user is an admin' do
      let(:is_admin) { true }

      it "provides the path to the admin home page" do
        expect(helper.landing_page_for(user)).to eql(admin_home_path)
      end
    end

    context 'when the user is not an admin' do
      let(:is_admin) { false }

      before :each do
        allow(user).to receive(:is_starting?).and_return(is_starting)
      end

      context 'and the user is starting' do
        let(:is_starting) { true }

        context 'and they have not asked for getting started to be hidden' do
          it "provides the path to the getting started page" do
            allow(user).to receive(:hide_getting_started?).and_return(false)
            expect(helper.landing_page_for(user)).to eql(my_getting_started_path)
          end
        end

        context 'but they have asked getting started to be hidden' do
          it "provides the path to the user's memory page page" do
            allow(user).to receive(:hide_getting_started?).and_return(true)
            expect(helper.landing_page_for(user)).to eql(my_memories_path)
          end
        end
      end

      context 'and the user is not starting' do
        let(:is_starting) { false }

        it "provides the path to the user's memory page page" do
          expect(helper.landing_page_for(user)).to eql(my_memories_path)
        end
      end
    end
  end
end

