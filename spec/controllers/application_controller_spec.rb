require 'rails_helper'

describe ApplicationController do
  controller do
    def index
      render text: 'index'
    end

    def show
      render text: 'show'
    end
  end

  describe 'setting the current index path' do
    it 'sets the current index path if action is index' do
      expect(session[:current_index_path]).to be_nil
      get :index
      expect(session[:current_index_path]).to eql('/anonymous')
    end

    it 'stores any given params' do
      expect(session[:current_index_path]).to be_nil
      get :index, query: 'test', page: '2'
      expect(session[:current_index_path]).to eql('/anonymous?page=2&query=test')
    end

    it 'does not set the current index path if action is not index' do
      expect(session[:current_index_path]).to be_nil
      get :show, id: 123
      expect(session[:current_index_path]).to be_nil
    end
  end
end

