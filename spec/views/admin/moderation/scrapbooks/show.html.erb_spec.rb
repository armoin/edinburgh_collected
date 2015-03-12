require 'rails_helper'

describe "admin/moderation/scrapbooks/show.html.erb" do
  it_behaves_like 'a scrapbook page'

  describe 'moderation panel' do
    let(:user)      { Fabricate.build(:admin_user, id: 456) }
    let(:reason)    { nil }
    let(:scrapbook) { Fabricate.build(:scrapbook, id: 123, user: user, moderation_state: state, moderation_reason: reason) }
    let(:list_path) { 'test/path' }

    before :each do
      assign(:scrapbook, scrapbook)
      assign(:memories, [])
      allow(view).to receive(:current_scrapbook_index_path).and_return(list_path)
      render
    end

    context 'when the current state is "unmoderated"' do
      let(:state) { 'unmoderated'}

      it 'displays the current state' do
        expect(rendered).to have_css('.state', text: 'unmoderated')
      end

      it 'does not have an "unmoderate" button' do
        expect(rendered).not_to have_link('Unmoderate')
      end

      it 'has an "approve" button' do
        expect(rendered).to have_link('Approve', href: approve_admin_moderation_scrapbook_path(scrapbook.to_param, reason: nil))
      end

      it 'has a "reject - unsuitable"  button' do
        expect(rendered).to have_link('Reject - unsuitable', href: reject_admin_moderation_scrapbook_path(scrapbook.to_param, reason: 'unsuitable'))
      end

      it 'has a "reject - offensive"  button' do
        expect(rendered).to have_link('Reject - offensive', href: reject_admin_moderation_scrapbook_path(scrapbook.to_param, reason: 'offensive'))
      end

      it 'has a "back to list" button' do
        expect(rendered).to have_link('Back to list', href: list_path)
      end
    end

    context 'when the current state is "approved"' do
      let(:state) { 'approved'}

      it 'displays the current state' do
        expect(rendered).to have_css('.state', text: 'approved')
      end

      it 'has an "unmoderate" button' do
        expect(rendered).to have_link('Unmoderate', href: unmoderate_admin_moderation_scrapbook_path(scrapbook.to_param))
      end

      it 'does not have an "approve" button' do
        expect(rendered).not_to have_link('Approve')
      end

      it 'has a "reject - unsuitable"  button' do
        expect(rendered).to have_link('Reject - unsuitable', href: reject_admin_moderation_scrapbook_path(scrapbook.to_param, reason: 'unsuitable'))
      end

      it 'has a "reject - offensive"  button' do
        expect(rendered).to have_link('Reject - offensive', href: reject_admin_moderation_scrapbook_path(scrapbook.to_param, reason: 'offensive'))
      end

      it 'has a "back to list" button' do
        expect(rendered).to have_link('Back to list', href: list_path)
      end
    end

    context 'when the current state is "rejected"' do
      let(:state) { 'rejected' }

      context 'and the reason is "unsuitable"' do
        let(:reason) { 'unsuitable' }

        it 'displays the current state' do
          expect(rendered).to have_css('.state', text: 'rejected - unsuitable')
        end

        it 'has an "unmoderate" button' do
          expect(rendered).to have_link('Unmoderate', href: unmoderate_admin_moderation_scrapbook_path(scrapbook.to_param))
        end

        it 'has an "approve" button' do
          expect(rendered).to have_link('Approve', href: approve_admin_moderation_scrapbook_path(scrapbook.to_param))
        end

        it 'does not have a "reject - unsuitable"  button' do
          expect(rendered).not_to have_link('Reject - unsuitable')
        end

        it 'has a "reject - offensive"  button' do
          expect(rendered).to have_link('Reject - offensive', href: reject_admin_moderation_scrapbook_path(scrapbook.to_param, reason: 'offensive'))
        end

        it 'has a "back to list" button' do
          expect(rendered).to have_link('Back to list', href: list_path)
        end
      end

      context 'and the reason is "offensive"' do
        let(:reason) { 'offensive' }

        it 'displays the current state' do
          expect(rendered).to have_css('.state', text: 'rejected - offensive')
        end

        it 'has an "Unmoderate" button' do
          expect(rendered).to have_link('Unmoderate', href: unmoderate_admin_moderation_scrapbook_path(scrapbook.to_param))
        end

        it 'has an "Approve" button' do
          expect(rendered).to have_link('Approve', href: approve_admin_moderation_scrapbook_path(scrapbook.to_param))
        end

        it 'has a "Reject - unsuitable"  button' do
          expect(rendered).to have_link('Reject - unsuitable', href: reject_admin_moderation_scrapbook_path(scrapbook.to_param, reason: 'unsuitable'))
        end

        it 'does not have a "Reject - offensive"  button' do
          expect(rendered).not_to have_link('Reject - offensive')
        end

        it 'has a "Back to list" button' do
          expect(rendered).to have_link('Back to list', href: list_path)
        end
      end
    end
  end
end
