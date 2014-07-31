require 'rails_helper'

describe SessionsController do
  describe 'GET new' do
    it 'renders the login page' do
      get :new
      expect(response).to render_template(:new)
    end
  end
end
