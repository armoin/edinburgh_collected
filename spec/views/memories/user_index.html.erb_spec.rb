require 'rails_helper'

describe 'memories/user_index.html.erb' do
  let(:requested_user)   { Fabricate.build(:active_user, id: 123) }
  let(:current_user)     { nil }
  let(:memories_count)   { 0 }
  let(:scrapbooks_count) { 0 }
  let(:memories)         { Array.new(memories_count) {|i| Fabricate.build(:memory, id: i+1)} }
  let(:paged_memories)   { Kaminari.paginate_array(memories).page(1) }
  
  let(:presenter) { OpenStruct.new(
    requested_user:    requested_user,
    memories_count:    memories_count,
    scrapbooks_count:  scrapbooks_count,
    paged_memories:    paged_memories,
    page_title:        'Foo',
    can_add_memories?: current_user == requested_user
  )}

  before :each do
    allow(view).to receive(:current_user).and_return(current_user)
   
    assign(:presenter, presenter)
  end

  it_behaves_like 'a profile headed page'

  describe 'the action bar' do
    before :each do
      render
    end
    
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
      before :each do
        render
      end

      it 'links to the scrapbooks for the requested user' do
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

    describe 'the Add a memory button' do
      context 'when the requested user is the current user' do
        let(:current_user) { requested_user }

        it 'shows the Add a memory button' do
          expect(rendered).to have_link('Add a memory', href: new_my_memory_path)
        end
      end

      context 'when the requested user is not the current user' do
        let(:current_user) { Fabricate.build(:active_user, id: 456) }

        it 'does not show the Add a memory button' do
          expect(rendered).not_to have_link('Add a memory', href: new_my_memory_path)
        end
      end
    end
  end

  describe 'the memory index' do
    before :each do
      render
    end

    context 'when there are no memories' do
      let(:memories_count)   { 0 }

      it 'does not display any memories' do
        expect(rendered).not_to have_css('.memory')
      end

      it_behaves_like 'add to scrapbook'
    end
    
    context 'when there are memories' do
      let(:memories_count)   { 3 }

      it_behaves_like 'a memory index'
      it_behaves_like 'paginated content'
      it_behaves_like 'add to scrapbook'
    end
  end
end