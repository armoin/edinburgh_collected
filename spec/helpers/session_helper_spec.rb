require 'rails_helper'

describe SessionHelper do
  describe '#store_index_path' do
    it 'stores the current request url' do
      expect(session[:current_index_path]).to be_nil
      allow(view).to receive(:request).and_return(double('request', original_fullpath: 'my/memories?page=2'))
      helper.store_index_path
      expect(session[:current_index_path]).to eql('my/memories?page=2')
    end
  end

  describe '#current_index_path' do
    context 'when session has no current_index_path' do
      it 'returns the default path' do
        expect(helper.current_index_path).to eql(SessionHelper::DEFAULT_PATH)
      end
    end

    context 'when session has a blank current_index_path' do
      before :each do
        session[:current_index_path] = ''
      end

      it 'returns the default path' do
        expect(helper.current_index_path).to eql(SessionHelper::DEFAULT_PATH)
      end
    end

    context 'when session has a current_index_path' do
      before :each do
        session[:current_index_path] = 'my/memories'
      end

      it 'returns the current index path' do
        expect(helper.current_index_path).to eql('my/memories')
      end
    end
  end
end

