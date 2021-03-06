# let(:memory)    # must be declared in calling spec

RSpec.shared_examples "a memory" do
  let(:test_user) { Fabricate.build(:user) }
  let!(:area)     { Fabricate(:area) }

  describe 'validation' do
    it "is valid with valid attributes" do
      expect(memory).to be_valid
    end

    it "must have a user" do
      memory.user = nil
      expect(memory).to be_invalid
      expect(memory.errors[:user]).to include("can't be blank")
    end

    describe "type" do
      it "can't be blank" do
        memory.type = ''
        expect(memory).to be_invalid
        expect(memory.errors[:type]).to include("Please tell us what type of memory you want to add")
      end

      it "must be an allowed type" do
        memory.type = 'doodah'
        expect(memory).to be_invalid
        expect(memory.errors[:type]).to include("must be of type 'photo'")
      end
    end

    describe "title" do
      it "can't be blank" do
        memory.title = ""
        expect(memory).to be_invalid
        expect(memory.errors[:title]).to include("Please let us know what title you would like to give this")
      end

      it "can't be more than 200 characters long" do
        exact_size_text = Array.new(200, "a").join
        too_long_text = Array.new(201, "a").join
        memory.title = exact_size_text
        expect(memory).to be_valid
        memory.title = too_long_text
        expect(memory).to be_invalid
        expect(memory.errors[:title]).to include("text is too long (maximum is 200 characters)")
      end
    end

    describe "description" do
      it "can't be blank" do
        memory.description = ""
        expect(memory).to be_invalid
        expect(memory.errors[:description]).to include("Please tell us a little bit about this memory")
      end

      it "can't be more than 1500 characters long" do
        exact_size_text = Array.new(1500, "a").join
        too_long_text = Array.new(1501, "a").join
        memory.description = exact_size_text
        expect(memory).to be_valid
        memory.description = too_long_text
        expect(memory).to be_invalid
        expect(memory.errors[:description]).to include("text is too long (maximum is 1500 characters)")
      end
    end

    describe "categories" do
      it "is invalid with no categories" do
        memory.categories = []
        expect(memory).to be_invalid
        expect(memory.errors[:categories]).to include("must have at least one")
      end

      it "is valid with one category" do
        memory.categories = Fabricate.times(1, :category)
        expect(memory).to be_valid
      end

      it "is valid with multiple categories" do
        memory.categories = Fabricate.times(2, :category)
        expect(memory).to be_valid
      end
    end

    describe 'date' do
      let(:now) { Date.new(2014, 5, 4) }

      before :each do
        Timecop.freeze(now)
      end

      after :each do
        Timecop.return
      end

      describe "year" do
        it "is invalid if in the future" do
          memory.year = '2015'
          expect(memory).to be_invalid
          expect(memory.errors[:base]).to include("The date can't be in the future")
        end

        it "is valid if is the present" do
          memory.year = '2014'
          expect(memory).to be_valid
          expect(memory.errors[:base]).to be_empty
        end

        it "is valid if in the past" do
          memory.year = '1814'
          expect(memory).to be_valid
          expect(memory.errors[:base]).to be_empty
        end

        it "is invalid when not 4 digits long" do
          memory.year = '1'
          expect(memory).to be_invalid
          expect(memory.errors[:year]).to include('must be in the format YYYY')

          memory.year = '12'
          expect(memory).to be_invalid
          expect(memory.errors[:year]).to include('must be in the format YYYY')

          memory.year = '123'
          expect(memory).to be_invalid
          expect(memory.errors[:year]).to include('must be in the format YYYY')

          memory.year = '1234'
          expect(memory).to be_valid
          expect(memory.errors[:year]).to be_empty
        end

        it "is invalid when a string" do
          memory.year = 'NA'
          expect(memory).to be_invalid
          expect(memory.errors[:year]).to include('is not a valid year')
        end

        it "is invalid when 0" do
          memory.year = '0'
          expect(memory).to be_invalid
          expect(memory.errors[:year]).to include('is not a valid year')
        end

        it "is invalid when less than 0" do
          memory.year = '-1'
          expect(memory).to be_invalid
          expect(memory.errors[:year]).to include('is not a valid year')
        end

        it "is invalid when a float" do
          memory.year = '1.2'
          expect(memory).to be_invalid
          expect(memory.errors[:year]).to include('is not a valid year')
        end
      end

      describe "month" do
        before :each do
          memory.year = '2014'
        end

        it "is valid if not present" do
          memory.month = ""
          expect(memory).to be_valid
          expect(memory.errors[:base]).to be_empty
        end

        it "is invalid if in the future" do
          memory.month = '6'
          expect(memory).to be_invalid
          expect(memory.errors[:base]).to include("The date can't be in the future")
        end

        it "is valid if is the present" do
          memory.month = '5'
          expect(memory).to be_valid
          expect(memory.errors[:base]).to be_empty
        end

        it "is valid if in the past" do
          memory.month = '4'
          expect(memory).to be_valid
          expect(memory.errors[:base]).to be_empty
        end
      end

      describe "day" do
        before :each do
          memory.year = '2014'
          memory.month = '5'
        end

        it "is valid if not present" do
          memory.day = ""
          expect(memory).to be_valid
          expect(memory.errors[:base]).to be_empty
        end

        it "is invalid if in the future" do
          memory.day = '5'
          expect(memory).to be_invalid
          expect(memory.errors[:base]).to include("The date can't be in the future")
        end

        it "is valid if is the present" do
          memory.day = '4'
          expect(memory).to be_valid
          expect(memory.errors[:base]).to be_empty
        end

        it "is valid if in the past" do
          memory.day = '3'
          expect(memory).to be_valid
          expect(memory.errors[:base]).to be_empty
        end
      end
    end

    describe "attribution" do
      it "can't be more than 200 characters long" do
        exact_size_text = Array.new(200, "a").join
        too_long_text = Array.new(201, "a").join
        memory.attribution = exact_size_text
        expect(memory).to be_valid
        memory.attribution = too_long_text
        expect(memory).to be_invalid
        expect(memory.errors[:attribution]).to include("text is too long (maximum is 200 characters)")
      end
    end
  end
end

