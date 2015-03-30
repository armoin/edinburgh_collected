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
      @unapproved_with_terms   = Fabricate(:scrapbook, user: @active_user, title: 'Edinburgh Castle test')
      @pending_user_with_terms = Fabricate(:approved_scrapbook, user: @pending_user, title: 'Edinburgh Castle test')
    end

    let(:results) { Scrapbook.text_search(terms) }

    context 'when no terms are given' do
      let(:terms) { nil }

      it 'returns all approved records' do
        expect(results.count(:all)).to eql(3)
      end
    end

    context 'when blank terms are given' do
      let(:terms) { '' }

      it 'returns all approved records' do
        expect(results.count(:all)).to eql(3)
      end
    end

    context 'text fields' do
      let(:terms) { 'castle' }

      it 'returns all approved records matching the given query' do
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
    describe '.by_recent' do
      it 'sorts them by reverse created at date' do
        scrapbook1 = Fabricate(:scrapbook)
        scrapbook2 = Fabricate(:scrapbook)
        sorted = Scrapbook.by_recent
        expect(sorted.first).to eql(scrapbook2)
        expect(sorted.last).to eql(scrapbook1)
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

  describe '#ordered_memories' do
    let(:user)       { Fabricate.build(:active_user, id: 123) }
    let(:other_user) { Fabricate.build(:active_user, id: 456) }

    subject { Fabricate(:scrapbook, user: user) }

    context 'when the scrapbook has no memories' do
      it 'provides an empty collection' do
        expect(subject.ordered_memories).to be_empty
      end
    end

    context 'when the scrapbook has one memory' do
      let!(:scrapbook_memory) { Fabricate(:scrapbook_memory, scrapbook: subject, memory: memory) }

      context 'and it is not approved' do
        context 'and it belongs to the scrapbook user' do
          let(:memory) { Fabricate(:memory, user: user) }

          it 'provides a collection with just that memory' do
            expect(subject.ordered_memories.length).to eql(1)
            expect(subject.ordered_memories).to eql([memory])
          end
        end

        context 'and it does not belong to the scrapbook user' do
          let(:memory) { Fabricate(:memory, user: other_user) }

          it 'provides an empty collection' do
            expect(subject.ordered_memories).to be_empty
          end
        end
      end

      context 'and it is approved' do
        context 'and it belongs to the scrapbook user' do
          let(:memory) { Fabricate(:approved_memory, user: user) }

          it 'provides a collection with just that memory' do
            expect(subject.ordered_memories.length).to eql(1)
            expect(subject.ordered_memories).to eql([memory])
          end
        end

        context 'and it does not belong to the scrapbook user' do
          let(:memory) { Fabricate(:approved_memory, user: other_user) }

          it 'provides a collection with just that memory' do
            expect(subject.ordered_memories.length).to eql(1)
            expect(subject.ordered_memories).to eql([memory])
          end
        end
      end
    end

    context 'when the scrapbook has more than one memory' do
      let!(:sm_1)    { Fabricate(:scrapbook_memory, scrapbook: subject, memory: memory_1) }
      let!(:sm_2)    { Fabricate(:scrapbook_memory, scrapbook: subject, memory: memory_2) }
      let!(:sm_3)    { Fabricate(:scrapbook_memory, scrapbook: subject, memory: memory_3) }

      context 'and the memories are approved' do
        context 'and the memories belong to the scrapbook user' do
          let(:memory_1) { Fabricate(:approved_memory, user: user) }
          let(:memory_2) { Fabricate(:approved_memory, user: user) }
          let(:memory_3) { Fabricate(:approved_memory, user: user) }


          it 'provides a collection with all memories in order' do
            expect(subject.ordered_memories.length).to eql(3)
            expect(subject.ordered_memories).to eql([memory_1, memory_2, memory_3])
          end

          it 'includes any memories that are not approved' do
            memory_2.report!(other_user, 'test')
            expect(subject.ordered_memories.length).to eql(3)
            expect(subject.ordered_memories).to eql([memory_1, memory_2, memory_3])
          end

          it 'provides a collection with all memories in order if the order is changed' do
            subject.update({ordering: "#{sm_2.id},#{sm_3.id},#{sm_1.id}"})
            expect(subject.ordered_memories.length).to eql(3)
            expect(subject.ordered_memories).to eql([memory_2, memory_3, memory_1])
          end
        end

        context 'and the memories do not belong to the scrapbook user' do
          let(:memory_1) { Fabricate(:approved_memory, user: other_user) }
          let(:memory_2) { Fabricate(:approved_memory, user: other_user) }
          let(:memory_3) { Fabricate(:approved_memory, user: other_user) }

          context 'when no memories are unapproved' do
            it 'provides a collection with all memories in order' do
              expect(subject.ordered_memories.length).to eql(3)
              expect(subject.ordered_memories).to eql([memory_1, memory_2, memory_3])
            end

            it 'provides a collection with all memories in order if the order is changed' do
              subject.update({ordering: "#{sm_2.id},#{sm_3.id},#{sm_1.id}"})
              expect(subject.ordered_memories.length).to eql(3)
              expect(subject.ordered_memories).to eql([memory_2, memory_3, memory_1])
            end
          end

          context 'when one of the memories is unapproved' do
            before :each do
              memory_2.report!(user, 'test')
            end

            it 'ignores the unapproved memory' do
              expect(subject.ordered_memories.length).to eql(2)
              expect(subject.ordered_memories).to eql([memory_1, memory_3])
            end

            context 'and the order is changed' do
              before :each do
                subject.update({ordering: "#{sm_2.id},#{sm_3.id},#{sm_1.id}"})
              end

              it 'ignores the unapproved memory but keeps changed ordering' do
                expect(subject.ordered_memories.length).to eql(2)
                expect(subject.ordered_memories).to eql([memory_3, memory_1])
              end

              context 'then the memory is reapproved' do
                before :each do
                  memory_2.approve!(user)
                end

                it 'provides a collection with all memories in changed order' do
                  expect(subject.ordered_memories.length).to eql(3)
                  expect(subject.ordered_memories).to eql([memory_2, memory_3, memory_1])
                end
              end
            end
          end
        end
      end
    end
  end

  describe '#approved_ordered_memories' do
    let(:user)       { Fabricate.build(:active_user, id: 123) }
    let(:other_user) { Fabricate.build(:active_user, id: 456) }

    subject { Fabricate(:scrapbook, user: user) }

    context 'when the scrapbook has no memories' do
      it 'provides an empty collection' do
        expect(subject.approved_ordered_memories).to be_empty
      end
    end

    context 'when the scrapbook has one memory' do
      let!(:scrapbook_memory) { Fabricate(:scrapbook_memory, scrapbook: subject, memory: memory) }

      context 'and it is not approved' do
        context 'and it belongs to the scrapbook user' do
          let(:memory) { Fabricate(:memory, user: user) }

          it 'provides an empty collection' do
            expect(subject.approved_ordered_memories).to be_empty
          end
        end

        context 'and it belongs to another user' do
          let(:memory) { Fabricate(:memory, user: other_user) }

          it 'provides an empty collection' do
            expect(subject.approved_ordered_memories).to be_empty
          end
        end
      end

      context 'and it is approved' do
        context 'and it belongs to the scrapbook user' do
          let(:memory) { Fabricate(:approved_memory, user: user) }

          it 'provides a collection with that memory' do
            expect(subject.approved_ordered_memories).to eql([memory])
          end
        end

        context 'and it belongs to another user' do
          let(:memory) { Fabricate(:approved_memory, user: other_user) }

          it 'provides a collection with that memory' do
            expect(subject.approved_ordered_memories).to eql([memory])
          end
        end
      end
    end

    context 'when the scrapbook has more than one memory and not all are approved' do
      let(:memory_1) { Fabricate(:memory) }
      let(:memory_2) { Fabricate(:approved_memory) }
      let(:memory_3) { Fabricate(:approved_memory) }
      let!(:sm_1)    { Fabricate(:scrapbook_memory, scrapbook: subject, memory: memory_1) }
      let!(:sm_2)    { Fabricate(:scrapbook_memory, scrapbook: subject, memory: memory_2) }
      let!(:sm_3)    { Fabricate(:scrapbook_memory, scrapbook: subject, memory: memory_3) }

      it 'provides a collection with only approved memories in order' do
        expect(subject.approved_ordered_memories.length).to eql(2)
        expect(subject.approved_ordered_memories).to eql([memory_2, memory_3])
      end

      it 'provides a collection with only approved memories in order if the order is changed' do
        subject.update({ordering: "#{sm_3.id},#{sm_2.id},#{sm_1.id}"})
        expect(subject.approved_ordered_memories.length).to eql(2)
        expect(subject.approved_ordered_memories).to eql([memory_3, memory_2])
      end
    end
  end
end
