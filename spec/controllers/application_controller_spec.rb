require 'rails_helper'

describe ApplicationController do
  controller do
    def index
    end
  end

  describe '#logged_in?' do
    it 'returns false if there is not a currently signed in user' do
      expect(controller.logged_in?).to be_falsy
    end

    it 'returns true if there is a currently signed in user' do
      session[:auth_token] = '123abc'
      expect(controller.logged_in?).to be_truthy
    end
  end
end
