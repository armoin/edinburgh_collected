require 'rails_helper'

RSpec.describe Styleguide::BaseController do
  describe '#index' do
    it 'successfully renders the index template' do
      get :index
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end
end
