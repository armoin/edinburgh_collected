RSpec.shared_examples 'requires logged in user' do
  context 'when request is html' do
    let(:format) { :html }

    context 'when user is not logged in' do
      it 'redirects to the sign in page' do
        expect(response).to redirect_to(signin_path)
      end

      it 'provides an error message' do
        expect(flash[:alert]).to eql("Please sign in first")
      end
    end
  end

  context 'when response is JSON' do
    let(:format) { :json }

    context 'when user is not logged in' do
      it 'is forbidden' do
        expect(response).to be_forbidden
      end

      it 'provides an error message' do
        expect(response.body).to eql({error: 'You must be signed in to do this.'}.to_json)
      end
    end
  end

  context 'when response is javascript' do
    let(:format) { :js }

    context 'when user is not logged in' do
      it 'is forbidden' do
        expect(response).to be_forbidden
      end

      it 'renders the authentication_error template' do
        expect(response).to render_template('shared/authentication_error')
      end
    end
  end
end