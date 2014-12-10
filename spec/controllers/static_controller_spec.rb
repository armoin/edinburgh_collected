require 'rails_helper'

describe StaticController do
  describe 'GET about' do
    it 'renders the about page' do
      get :about
      expect(response).to render_template('about')
    end
  end

  describe 'GET contact' do
    it 'renders the contact us page' do
      get :contact
      expect(response).to render_template('contact')
    end
  end

  describe 'GET p_and_c' do
    it 'renders the privacy and cookies page' do
      get :p_and_c
      expect(response).to render_template('p_and_c')
    end
  end

  describe 'GET t_and_c' do
    it 'renders the terms and conditions page' do
      get :t_and_c
      expect(response).to render_template('t_and_c')
    end
  end
end

