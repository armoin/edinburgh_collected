require 'rails_helper'

describe Scrapbook do

  let(:moderatable_model)   { Scrapbook }
  let(:moderatable_factory) { :scrapbook }
  it_behaves_like 'moderatable'

  describe 'validation' do
    it 'must belong to a user' do
      expect(subject).to be_invalid
      expect(subject.errors[:user]).to include("can't be blank")
    end

    describe 'title' do
      it 'must be present' do
        expect(subject).to be_invalid
        expect(subject.errors[:title]).to include("can't be blank")
      end

      it "can't be longer than 200 characters" do
        scrapbook = Fabricate.build(:scrapbook)
        exact_size_text = Array.new(200, "a").join
        too_long_text = Array.new(201, "a").join
        scrapbook.title = exact_size_text
        expect(scrapbook).to be_valid
        scrapbook.title = too_long_text
        expect(scrapbook).to be_invalid
        expect(scrapbook.errors[:title]).to include("text is too long (maximum is 200 characters)")
      end
    end

    describe 'description' do
      it "can't be more than 1000 characters long" do
        scrapbook = Fabricate.build(:scrapbook)
        exact_size_text = Array.new(1000, "a").join
        too_long_text = Array.new(1001, "a").join
        scrapbook.description = exact_size_text
        expect(scrapbook).to be_valid
        scrapbook.description = too_long_text
        expect(scrapbook).to be_invalid
        expect(scrapbook.errors[:description]).to include("text is too long (maximum is 1000 characters)")
      end
    end
  end

  describe 'searching' do
    before :each do
      @active_user             = Fabricate(:active_user)
      @pending_user            = Fabricate(:pending_user)

      @term_in_title           = Fabricate(:approved_scrapbook, user: @active_user, title: 'Edinburgh Castle test')
      @term_in_description     = Fabricate(:approved_scrapbook, user: @active_user, description: 'This is an Edinburgh Castle test')
      @terms_not_found         = Fabricate(:approved_scrapbook, user: @active_user, title: 'test', description: 'test')

      @pending_user_with_terms = Fabricate(:approved_scrapbook, user: @pending_user, title: 'Edinburgh Castle test')

      @unapproved_with_terms   = Fabricate(:scrapbook, user: @active_user, title: 'Edinburgh Castle test')
    end

    let(:results) { Scrapbook.text_search(terms) }

    context 'when no terms are given' do
      let(:terms) { nil }

      it 'returns all publicly visible records' do
        expect(results.count(:all)).to eql(3)
      end
    end

    context 'when blank terms are given' do
      let(:terms) { '' }

      it 'returns all publicly visible records' do
        expect(results.count(:all)).to eql(3)
      end
    end

    context 'text fields' do
      let(:terms) { 'castle' }

      it 'returns all publicly visible records matching the given query' do
        expect(results.count(:all)).to eql(2)
      end

      it "includes records where title matches" do
        expect(results).to include(@term_in_title)
      end

      it "includes records where description matches" do
        expect(results).to include(@term_in_description)
      end

      it "does not include records where no matches are found" do
        expect(results).not_to include(@terms_not_found)
      end

      it "does not include unapproved records even if matches are found" do
        expect(results).not_to include(@unapproved_with_terms)
      end

      it "does not include records belonging to inactive users even if approved and matches are found" do
        expect(results).not_to include(@pending_user_with_terms)
      end
    end
  end

  describe 'ordering' do
    describe '.by_last_created' do
      it 'sorts them by reverse created at date' do
        scrapbook1 = Fabricate(:scrapbook)
        scrapbook2 = Fabricate(:scrapbook)
        sorted = Scrapbook.by_last_created
        expect(sorted.first).to eql(scrapbook2)
        expect(sorted.last).to eql(scrapbook1)
      end
    end

    describe '.by_last_updated' do
      it 'sorts them by reverse updated at date' do
        scrapbook1 = Fabricate(:scrapbook)
        scrapbook2 = Fabricate(:scrapbook)
        scrapbook1.update(title: 'testing update')
        sorted = Scrapbook.by_last_updated
        expect(sorted.first).to eql(scrapbook1)
        expect(sorted.last).to eql(scrapbook2)
      end
    end
  end

  describe '#cover' do
    it 'provides a ScrapbookCover for the scrapbook' do
      allow(ScrapbookCover).to receive(:new)
      subject.cover
      expect(ScrapbookCover).to have_received(:new).with(subject)
    end
  end

  describe '#update' do
    let(:initial_params) {{ title: 'new title' }}
    let(:params)         { initial_params }

    subject { Fabricate(:scrapbook) }

    before :each do
      allow(ScrapbookMemory).to receive(:reorder_for_scrapbook)
      allow(ScrapbookMemory).to receive(:remove_from_scrapbook)
      subject.update(params)
    end

    describe "ordering" do
      context 'when there is no ordering' do
        it 'does not update the ordering' do
          expect(ScrapbookMemory).not_to have_received(:reorder_for_scrapbook)
        end
      end

      context 'when there is an empty ordering' do
        let(:params) { initial_params.merge({ordering: ''}) }

        it 'does not update the ordering' do
          expect(ScrapbookMemory).not_to have_received(:reorder_for_scrapbook)
        end
      end

      context 'when there is an ordering' do
        let(:params) { initial_params.merge({ordering: '1,2,3'}) }

        it 'updates the ordering' do
          expect(ScrapbookMemory).to have_received(:reorder_for_scrapbook).with(subject, %w(1 2 3))
        end
      end
    end

    describe "deleted" do
      context 'when there are no deleted' do
        it 'does not remove the deleted' do
          expect(ScrapbookMemory).not_to have_received(:remove_from_scrapbook)
        end
      end

      context 'when there is an empty deleted' do
        let(:params) { initial_params.merge({deleted: ''}) }

        it 'does not remove the deleted' do
          expect(ScrapbookMemory).not_to have_received(:remove_from_scrapbook)
        end
      end

      context 'when there is a deleted' do
        let(:params) { initial_params.merge({deleted: '4,5'}) }

        it 'removes the deleted' do
          expect(ScrapbookMemory).to have_received(:remove_from_scrapbook).with(subject, %w(4 5))
        end
      end
    end

    context "when there is ordering and deleted" do
      let(:params) { initial_params.merge({
        ordering: '1,2,3',
        deleted: '4,5'
      })}


      it 'passes the rest of the params upstream' do
        subject.update(params)
        expect(subject.title).to eql('new title')
      end

      it "is false if invalid" do
        params[:title] = nil
        expect(subject.update(params)).to be_falsy
      end

      it "is false if there are errors" do
        stub_errors = double(messages: ['test error'], clear: true, empty?: true)
        allow(subject).to receive(:errors).and_return(stub_errors)
        expect(subject.update(params)).to be_falsy
      end

      it "is true if valid and there are no errors" do
        expect(subject.update(params)).to be_truthy
      end
    end
  end

  describe 'fetching memories' do
    let(:query_builder_double)                  { double('query builder') }

    let(:approved_query_double)                 { double('approved_query', to_sql: 'approved query sql') }
    let(:approved_or_owned_query_double)        { double('approved_or_owned_query', to_sql: 'approved or owned query sql') }

    let(:approved_memories_double)              { double('approved memories') }
    let(:approved_or_owned_memories_double)     { double('approved or owned memories') }

    before :each do
      allow(MemoryQueryBuilder).to receive(:new).and_return(query_builder_double)

      allow(query_builder_double).to receive(:approved_query).and_return(approved_query_double)
      allow(query_builder_double).to receive(:approved_or_owned_by_query).and_return(approved_or_owned_query_double)

      allow(Memory).to receive(:find_by_sql)
        .with(approved_query_double.to_sql)
        .and_return(approved_memories_double)

      allow(Memory).to receive(:find_by_sql)
        .with(approved_or_owned_query_double.to_sql)
        .and_return(approved_or_owned_memories_double)
    end

    describe '#ordered_memories' do
      it 'provides only memories that are approved or that belong to the owner of the scrapbook' do
        result = subject.ordered_memories

        expect(Memory).to have_received(:find_by_sql).with(approved_or_owned_query_double.to_sql)
        expect(result).to eql(approved_or_owned_memories_double)
      end
    end

    describe '#approved_ordered_memories' do
      it 'provides only memories that are approved' do
        result = subject.approved_ordered_memories

        expect(Memory).to have_received(:find_by_sql).with(approved_query_double.to_sql)
        expect(result).to eql(approved_memories_double)
      end
    end
  end

  describe 'fetching scrapbook_memories' do
    let(:query_builder_double)                  { double('query builder') }

    let(:approved_query_double)                 { double('approved_query', to_sql: 'approved query sql') }
    let(:approved_or_owned_query_double)        { double('approved_or_owned_query', to_sql: 'approved or owned query sql') }

    let(:approved_sb_memories_double)           { double('approved scrapbook memories') }
    let(:approved_or_owned_sb_memories_double)  { double('approved or owned scrapbook memories') }

    before :each do
      allow(ScrapbookMemoryQueryBuilder).to receive(:new).and_return(query_builder_double)

      allow(query_builder_double).to receive(:approved_query).and_return(approved_query_double)
      allow(query_builder_double).to receive(:approved_or_owned_by_query).and_return(approved_or_owned_query_double)

      allow(ScrapbookMemory).to receive(:find_by_sql)
        .with(approved_query_double.to_sql)
        .and_return(approved_sb_memories_double)

      allow(ScrapbookMemory).to receive(:find_by_sql)
        .with(approved_or_owned_query_double.to_sql)
        .and_return(approved_or_owned_sb_memories_double)
    end

    describe '#approved_or_owned_scrapbook_memories' do
      it 'provides only scrapbook memories that are approved or that belong to the owner of the scrapbook' do
        result = subject.approved_or_owned_scrapbook_memories

        expect(ScrapbookMemory).to have_received(:find_by_sql).with(approved_or_owned_query_double.to_sql)
        expect(result).to eql(approved_or_owned_sb_memories_double)
      end
    end

    describe '#approved_scrapbook_memories' do
      it 'provides only memories that are approved' do
        result = subject.approved_scrapbook_memories

        expect(ScrapbookMemory).to have_received(:find_by_sql).with(approved_query_double.to_sql)
        expect(result).to eql(approved_sb_memories_double)
      end
    end
  end
end
