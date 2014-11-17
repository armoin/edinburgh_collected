require 'rails_helper'

describe StaticController do
  describe 'GET t_and_c' do
    it 'renders the terms and conditions page' do
      get :t_and_c
      expect(response).to render_template('t_and_c')
    end
  end
end

