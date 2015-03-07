require 'rails_helper'

describe My::ProfileController do
  describe 'GET show' do
    context 'when not logged in' do
      it 'asks user to signin' do
        get :show
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      before :each do
        @user = Fabricate.build(:user, id: 123)
        login_user
        get :show
      end

      it 'assigns the current user' do
        expect(assigns[:user]).to eql(@user)
      end

      it 'renders the show page' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET edit' do
    context 'when not logged in' do
      it 'asks user to signin' do
        get :edit
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      let(:link_count) { 0 }
      let(:links)      { build_array(link_count, :link) }

      before :each do
        @user = Fabricate.build(:user, id: 123, links: links)
        login_user
        get :edit
      end

      it 'assigns the current user' do
        expect(assigns[:user]).to eql(@user)
      end

      context 'when the user has not got any links yet' do
        let(:link_count) { 0 }

        it 'builds a new link' do
          expect(@user.links.length).to eql(link_count + 1)
          expect(@user.links.last).to be_new_record
        end
      end

      context 'when the user has links already' do
        let(:link_count) { 2 }

        it 'does not build a new link' do
          expect(@user.links.length).to eql(link_count)
        end
      end

      it 'assigns a new TempImage for the file uploader' do
        expect(assigns[:temp_image]).to be_new_record
        expect(assigns[:temp_image]).to be_a(TempImage)
      end

      it 'renders the edit page' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PUT update' do
    context 'when not logged in' do
      it 'asks user to signin' do
        put :update
        expect(response).to redirect_to(:signin)
      end
    end

    context 'when logged in' do
      let(:link_count)      { 0 }
      let(:links)           { build_array(link_count, :link) }
      let(:updated)         { true }
      let(:image_processed) { true }

      before :each do
        @user = Fabricate.build(:user, id: 123, links: links)
        login_user
        allow(@user).to receive(:update).and_return(updated)
        allow(@user).to receive(:process_image).and_return(image_processed)
        put :update, user: {first_name: 'Mary'}
      end

      it 'assigns the current user' do
        expect(assigns[:user]).to eql(@user)
      end

      it 'updates the current user' do
        expect(@user).to have_received(:update).with(first_name: 'Mary')
      end

      context 'when successfully updated' do
        let(:updated) { true }

        it 'processes the attached avatar' do
          expect(@user).to have_received(:process_image)
        end

        context 'when image successfully processed' do
          let(:image_processed) { true }

          it 'redirects to the show page' do
            expect(response).to redirect_to(my_profile_path)
          end

          it 'shows a success notice' do
            expect(flash[:notice]).to eql('Successfully changed your details.')
          end
        end
      end

      context 'when not successfully updated' do
        let(:updated) { false }

        context 'when the user has not got any links yet' do
          let(:link_count) { 0 }

          it 'builds a new link' do
            expect(@user.links.length).to eql(link_count + 1)
            expect(@user.links.last).to be_new_record
          end
        end

        context 'when the user has links already' do
          let(:link_count) { 2 }

          it 'does not build a new link' do
            expect(@user.links.length).to eql(link_count)
          end
        end

        it 'assigns a new TempImage for the file uploader' do
          expect(assigns[:temp_image]).to be_new_record
          expect(assigns[:temp_image]).to be_a(TempImage)
        end

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when not image not successfully processed' do
        let(:image_processed) { false }

        context 'when the user has not got any links yet' do
          let(:link_count) { 0 }

          it 'builds a new link' do
            expect(@user.links.length).to eql(link_count + 1)
            expect(@user.links.last).to be_new_record
          end
        end

        context 'when the user has links already' do
          let(:link_count) { 2 }

          it 'does not build a new link' do
            expect(@user.links.length).to eql(link_count)
          end
        end

        it 'assigns a new TempImage for the file uploader' do
          expect(assigns[:temp_image]).to be_new_record
          expect(assigns[:temp_image]).to be_a(TempImage)
        end

        it 'renders the edit page' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end

