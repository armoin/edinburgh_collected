require 'rails_helper'

describe 'MemoryQueryBuilder' do
  describe 'initializing' do
    it 'can not be initialized without scrapbook ids' do
      expect {
        MemoryQueryBuilder.new
      }.to raise_error(ArgumentError)
    end

    it 'can be initialized with one scrapbook id' do
      expect {
        MemoryQueryBuilder.new(1)
      }.not_to raise_error
      expect( MemoryQueryBuilder.new(1) ).to be_a(MemoryQueryBuilder)
    end

    it 'can be initialized with more than one scrapbook id' do
      expect {
        MemoryQueryBuilder.new([1,2])
      }.not_to raise_error
      expect( MemoryQueryBuilder.new(1) ).to be_a(MemoryQueryBuilder)
    end
  end

  describe 'queries' do
    let(:owner)                   { Fabricate(:active_user) }
    let(:other_user)              { Fabricate(:active_user) }

    let(:scrapbook_1)             { Fabricate.build(:scrapbook) }
    let(:scrapbook_2)             { Fabricate.build(:scrapbook) }

    let(:memory_pending)          { Fabricate(:pending_memory, user: owner) }
    let(:memory_approved_1)       { Fabricate(:approved_memory, user: owner) }
    let(:memory_approved_2)       { Fabricate(:approved_memory, user: owner) }
    let(:memory_rejected)         { Fabricate(:rejected_memory, user: owner) }
    let(:memory_reported)         { Fabricate(:reported_memory, user: owner) }
    let(:memory_other)            { Fabricate(:reported_memory, user: other_user) }

    let(:query_builder)           { MemoryQueryBuilder.new(scrapbook_ids) }

    describe '#all_query' do
      subject { query_builder.all_query.to_sql }

      context 'when one scrapbook is given' do
        let(:scrapbook_ids)   { [scrapbook_1.id] }

        let(:memories) { Memory.find_by_sql(subject) }

        it "provides pending memories that belong to the requested scrapbook" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_pending)

          expect(memories.count).to eql(1)
          expect(memories.first).to eql(memory_pending)
        end

        it "provides approved memories that belong to the requested scrapbook" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_1)

          expect(memories.count).to eql(1)
          expect(memories.first).to eql(memory_approved_1)
        end

        it "provides rejected memories that belong to the requested scrapbook" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_rejected)

          expect(memories.count).to eql(1)
          expect(memories.first).to eql(memory_rejected)
        end

        it "provides reported memories that belong to the requested scrapbook" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_reported)

          expect(memories.count).to eql(1)
          expect(memories.first).to eql(memory_reported)
        end

        it "does not provide memories that do not belong to the requested scrapbook" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_2, memory: memory_approved_1)

          expect(memories).to be_empty
        end

        it "provides the memories in the order that they were added" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_1)
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_2)

          expect(memories).to eql([ memory_approved_1, memory_approved_2 ])
        end

        it "provides the memories in the new order if the order is changed" do
          sbm1 = Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_1)
          sbm2 = Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_2)

          scrapbook_1.update({ ordering: "#{sbm2.id},#{sbm1.id}" })

          expect(memories).to eql([ memory_approved_2, memory_approved_1 ])
        end
      end

      context 'when more than one scrapbook is given' do
        let(:scrapbook_ids)   { [scrapbook_1.id, scrapbook_2.id] }

        context 'for memories' do
          let(:memories) { Memory.find_by_sql(subject) }

          it "provides approved memories that belong to the requested scrapbooks" do
            Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_pending)
            Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_1)
            Fabricate(:scrapbook_memory, scrapbook: scrapbook_2, memory: memory_approved_2)
            Fabricate(:scrapbook_memory, scrapbook: scrapbook_2, memory: memory_rejected)

            expect(memories.count).to eql(4)
            expect(memories).to include(memory_pending)
            expect(memories).to include(memory_approved_1)
            expect(memories).to include(memory_approved_2)
            expect(memories).to include(memory_rejected)
          end
        end
      end
    end

    describe '#approved_query' do
      let(:memories)        { Memory.find_by_sql(subject) }

      subject { query_builder.approved_query.to_sql }

      context "when one scrapbook is given" do
        let(:scrapbook_ids)   { [scrapbook_1.id] }

        it "does not provide pending memories that belong to the requested scrapbook" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_pending)

          expect(memories).to be_empty
        end

        it "provides approved memories that belong to the requested scrapbook" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_1)

          expect(memories.count).to eql(1)
          expect(memories.first).to eql(memory_approved_1)
        end

        it "does not provide rejected memories that belong to the requested scrapbook" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_rejected)

          expect(memories).to be_empty
        end

        it "does not provide reported memories that belong to the requested scrapbook" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_reported)

          expect(memories).to be_empty
        end

        it "does not provide memories that do not belong to the requested scrapbook" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_2, memory: memory_approved_1)

          expect(memories).to be_empty
        end

        it "provides the memories in the order that they were added" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_1)
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_2)

          expect(memories).to eql([ memory_approved_1, memory_approved_2 ])
        end

        it "provides the memories in the new order if the order is changed" do
          sbm1 = Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_1)
          sbm2 = Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_2)

          scrapbook_1.update({ ordering: "#{sbm2.id},#{sbm1.id}" })

          expect(memories).to eql([ memory_approved_2, memory_approved_1 ])
        end
      end

      context 'when more than one scrapbook is given' do
        let(:scrapbook_ids)   { [scrapbook_1.id, scrapbook_2.id] }
        let(:memories)        { Memory.find_by_sql(subject) }

        it "provides approved memories that belong to the requested scrapbooks" do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_pending)
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_1)
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_2, memory: memory_approved_2)
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_2, memory: memory_rejected)

          expect(memories.count).to eql(2)
          expect(memories).to include(memory_approved_1)
          expect(memories).to include(memory_approved_2)
          expect(memories).not_to include(memory_pending)
          expect(memories).not_to include(memory_rejected)
        end
      end
    end

    describe '#approved_or_owned_query' do
      let(:given_user) { other_user }

      subject { query_builder.approved_or_owned_by_query(given_user.id).to_sql }

      context 'when one scrapbook is given' do
        let(:scrapbook_ids)   { [scrapbook_1.id] }
        let(:memories) { Memory.find_by_sql(subject) }

        context 'when memory is pending' do
          before :each do
            Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_pending)
          end

          context "and it doesn't belong to the given user" do
            let(:given_user) { other_user }

            it "is not provided" do
              expect(memories).to be_empty
            end
          end

          context "and it belongs to the given user" do
            let(:given_user) { owner }

            it "is provided" do
              expect(memories.count).to eql(1)
              expect(memories.first).to eql(memory_pending)
            end
          end
        end

        context 'when memory is approved' do
          before :each do
            Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_1)
          end

          context "and it doesn't belong to the given user" do
            let(:given_user) { other_user }

            it "is provided" do
              expect(memories.count).to eql(1)
              expect(memories.first).to eql(memory_approved_1)
            end
          end

          context "and it belongs to the given user" do
            let(:given_user) { owner }

            it "is provided" do
              expect(memories.count).to eql(1)
              expect(memories.first).to eql(memory_approved_1)
            end
          end
        end

        context 'when memory is rejected' do
          before :each do
            Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_rejected)
          end

          context "and it doesn't belong to the given user" do
            let(:given_user) { other_user }

            it "is not provided" do
              expect(memories).to be_empty
            end
          end

          context "and it belongs to the given user" do
            let(:given_user) { owner }

            it "is provided" do
              expect(memories.count).to eql(1)
              expect(memories.first).to eql(memory_rejected)
            end
          end
        end

        context 'when memory is reported' do
          before :each do
            Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_reported)
          end

          context "and it doesn't belong to the given user" do
            let(:given_user) { other_user }

            it "is not provided" do
              expect(memories).to be_empty
            end
          end

          context "and it belongs to the given user" do
            let(:given_user) { owner }

            it "is provided" do
              expect(memories.count).to eql(1)
              expect(memories.first).to eql(memory_reported)
            end
          end
        end
      end

      context 'when more than one scrapbook is given' do
        let(:scrapbook_ids)   { [scrapbook_1.id, scrapbook_2.id] }

        before :each do
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_pending)
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_1, memory: memory_approved_1)
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_2, memory: memory_approved_2)
          Fabricate(:scrapbook_memory, scrapbook: scrapbook_2, memory: memory_other)
        end

        let(:memories) { Memory.find_by_sql(subject) }

        context 'when the given user is the owner' do
          let(:given_user) { owner }

          it "provides approved memories and unapproved memories that belong to the user" do
            expect(memories.count).to eql(3)
            expect(memories).to include(memory_approved_1)
            expect(memories).to include(memory_approved_2)
            expect(memories).to include(memory_pending)
            expect(memories).not_to include(memory_other)
          end
        end

        context 'when the given user is not the owner' do
          let(:given_user) { Fabricate(:active_user) }

          it "provides approved memories only" do
            expect(memories.count).to eql(2)
            expect(memories).to include(memory_approved_1)
            expect(memories).to include(memory_approved_2)
            expect(memories).not_to include(memory_pending)
            expect(memories).not_to include(memory_other)
          end
        end
      end
    end
  end
end