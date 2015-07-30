require 'rails_helper'

describe 'users/memories/index.html.erb' do
  let(:requested_user) { Fabricate.build(:active_user, id: 456) }
  let(:user)           { Fabricate.build(:active_user, id: 123) }

  let(:memories)         { Array.new(memories_count) {|i| Fabricate.build(:memory, id: i+1)} }
  let(:paged_memories)   { Kaminari.paginate_array(memories).page(1) }
  let(:memories_count)   { 0 }

  let(:scrapbooks_count) { 0 }

  let(:links) { [] }

  before :each do
    allow(view).to receive(:current_user).and_return(user)

    requested_user.links << links

    assign(:requested_user, requested_user)
    assign(:memories, paged_memories)
    assign(:scrapbooks_count, scrapbooks_count)
  end

  it_behaves_like 'a reportable page'

  describe 'the profile header' do
    before { render }

    it 'displays the profile for the requested user' do
      expect(rendered).to have_css('#profileHeader')
    end

    it "does not contain a link to the user's profile" do
      expect(rendered).not_to have_link('View your profile', href: my_profile_path)
    end

    it "displays the requested user's avatar" do
      expect(rendered).to have_css('img.avatar')
    end

    it "displays the requested user's username" do
      expect(rendered).to have_css('h1.title', text: requested_user.screen_name)
    end

    it "does not display a link to edit the user's profile" do
      expect(rendered).not_to have_link('Edit', href: my_profile_edit_path)
    end

    it "displays the requested user's description" do
      expect(rendered).to have_css('.sub', text: requested_user.description)
    end

    context "when the user has no links" do
      let(:links) { [] }

      it "does not display the requested user's links" do
        expect(rendered).not_to have_css('p.link')
        expect(rendered).not_to have_css('p.link a')
      end
    end

    context "when the user has links" do
      let(:links) { build_array(2, :link) }

      it "displays the requested user's links" do
        links.each do |link|
          expect(rendered).to have_css("p.link a[href=\"#{link.url}\"]", text: link.name, count: 1)
        end
      end
    end
  end

  describe 'the action bar' do
    before { render }

    describe 'the total memories count' do
      context 'when there are 0 memories' do
        let(:memories_count) { 0 }

        it 'shows 0 memories' do
          expect(rendered).to have_css('.actions .button.memories', text: '0 memories')
        end
      end

      context 'when there is 1 memory' do
        let(:memories_count) { 1 }

        it 'shows 1 memory' do
          expect(rendered).to have_css('.actions .button.memories', text: '1 memory')
        end
      end

      context 'when there are 2 memories' do
        let(:memories_count) { 2 }

        it 'shows 2 memories' do
          expect(rendered).to have_css('.actions .button.memories', text: '2 memories')
        end
      end
    end

    describe 'the scrapbooks link' do
      it 'links to the scrapbooks for the current user' do
        expect(rendered).to have_link('scrapbooks', href: user_scrapbooks_path(user_id: requested_user.id))
      end

      describe 'the total scrapbooks count' do
        context 'when there are 0 scrapbooks' do
          let(:scrapbooks_count) { 0 }

          it 'shows 0 scrapbooks' do
            expect(rendered).to have_css('.actions .button.scrapbooks', text: '0 scrapbooks')
          end
        end

        context 'when there is 1 scrapbook' do
          let(:scrapbooks_count) { 1 }

          it 'shows 1 scrapbook' do
            expect(rendered).to have_css('.actions .button.scrapbooks', text: '1 scrapbook')
          end
        end

        context 'when there are 2 scrapbooks' do
          let(:scrapbooks_count) { 2 }

          it 'shows 2 scrapbooks' do
            expect(rendered).to have_css('.actions .button.scrapbooks', text: '2 scrapbooks')
          end
        end
      end
    end

    it 'does not show the Add a memory button' do
      expect(rendered).to_not have_link('Add a memory', href: new_my_memory_path)
    end
  end

  describe 'the memory index' do
    before { render }

    context 'when there are no memories' do
      let(:memories_count)   { 0 }

      it 'does not display any memories' do
        expect(rendered).not_to have_css('.memory')
      end

      it_behaves_like 'add to scrapbook'
    end

    context 'when there are memories' do
      let(:memories_count)   { 3 }

      let(:base_memory_path) { :user_memory_path }
      let(:path_attrs)       { { user_id: requested_user.id } }
      it_behaves_like 'a memory index'

      it_behaves_like 'paginated content'
      it_behaves_like 'add to scrapbook'

      let(:moderatable) { memories.first }
      it_behaves_like 'non state labelled content'
    end
  end
end
