require 'rails_helper'

describe Memory do
  let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'files') }
  let(:file_name) { 'test.jpg' }
  let(:source)    { Rack::Test::UploadedFile.new(File.join(file_path, file_name)) }
  let(:test_user) { Fabricate.build(:user) }
  let(:memory)     { Fabricate.build(:memory, user: test_user, source: source, area: area) }

  let!(:area) { Fabricate(:area) }

  describe 'ordering' do
    it 'sorts them by reverse created at date' do
      memory1 = Fabricate(:memory, user: test_user, area: area)
      memory2 = Fabricate(:memory, user: test_user, area: area)
      expect(Memory.first).to eql(memory2)
      expect(Memory.last).to eql(memory1)
    end
  end

  describe 'year calculators' do
    before :each do
      Timecop.freeze('2014-01-01')
    end

    after :each do
      Timecop.return
    end

    describe 'current_year' do
      it 'returns the current year' do
        expect(Memory.current_year).to eql(2014)
      end
    end

    describe 'furthest_year' do
      it 'returns the year 120 years before the current year' do
        expect(Memory.furthest_year).to eql(1894)
      end
    end
  end

  describe 'validation' do
    it "is valid with valid attributes" do
      expect(memory).to be_valid
    end

    describe "year" do
      it "can't be blank" do
        memory.year = ""
        expect(memory).to be_invalid
        expect(memory.errors[:year]).to include("Please tell us when this dates from.")
      end

      it "is invalid if in the future" do
        memory.year = 1.year.from_now.year.to_s
        expect(memory).to be_invalid
        expect(memory.errors[:year]).to include("must be within the last 120 years.")
      end

      context "when in the past" do
        it "is invalid on create" do
          memory.year = (Memory::MAX_YEAR_RANGE+1).years.ago.year.to_s
          expect(memory).to be_invalid
          expect(memory.errors[:year]).to include("must be within the last 120 years.")
        end

        it "is invalid on update if changed" do
          memory.save!
          memory.year = (Memory::MAX_YEAR_RANGE+1).years.ago.year.to_s
          expect(memory).to be_invalid
          expect(memory.errors[:year]).to include("must be within the last 120 years.")
        end

        # this is to protect against future changes when
        # a date in the past is now invalid even though
        # it was valid on creation
        it "is valid on update if not changed" do
          memory.year = Memory::MAX_YEAR_RANGE.years.ago.year.to_s
          memory.save!
          Timecop.freeze(12.years.from_now) do
            expect(memory).to be_valid
          end
        end
      end

      it "is valid at earliest boundary" do
        memory.year = Memory::MAX_YEAR_RANGE.years.ago.year.to_s
        expect(memory).to be_valid
        expect(memory.errors[:year]).to be_empty
      end

      it "is valid at latest boundary" do
        memory.year = Time.now.year.to_s
        expect(memory).to be_valid
        expect(memory.errors[:year]).to be_empty
      end
    end

    context "source" do
      it "can't be blank" do
        memory.source.remove!
        expect(memory).to be_invalid
        expect(memory.errors[:source]).to include("You need to choose a file to upload.")
      end

      context "when file type is image" do
        context "and file is a .jpg" do
          let(:file_name) { 'test.jpg' }

          it "is valid" do
            expect(memory).to be_valid
          end
        end

        context "and file is a .jpeg" do
          let(:file_name) { 'test.jpeg' }

          it "is valid" do
            expect(memory).to be_valid
          end
        end

        context "and file is a .png" do
          let(:file_name) { 'test.png' }

          it "is valid" do
            expect(memory).to be_valid
          end
        end

        context "and file is a .gif" do
          let(:file_name) { 'test.gif' }

          it "is valid" do
            expect(memory).to be_valid
          end
        end

        context "and file is a .txt" do
          let(:file_name) { 'test.txt' }

          it "is invalid" do
            expect(memory).to be_invalid
            expect(memory.errors[:source]).to include('must be of type .jpg, .jpeg, .png, .gif')
          end
        end

        # context "and remote_source_url is given instead of file" do
        #   let(:file_name) { 'test.txt' }
        #
        #   it "is ignores validation for just now" do
        #     memory.remote_source_url = 'test/url'
        #     expect(memory).to be_valid
        #   end
        # end
      end
    end

    context "file type" do
      it "can't be blank" do
        memory.file_type = ''
        expect(memory).to be_invalid
        expect(memory.errors[:file_type]).to include('You can only add image files.')
      end

      it "must be an allowed file type" do
        memory.file_type = 'doodah'
        expect(memory).to be_invalid
        expect(memory.errors[:file_type]).to include('You can only add image files.')
      end
    end

    it "title can't be blank" do
      memory.title = ""
      expect(memory).to be_invalid
      expect(memory.errors[:title]).to include("Please let us know what you would like to call this.")
    end

    it "must have a user" do
      memory.user = nil
      expect(memory).to be_invalid
      expect(memory.errors[:user]).to include("can't be blank")
    end

    context "area_id" do
      it "can't be blank" do
        memory.area_id = nil
        expect(memory).to be_invalid
        expect(memory.errors[:area]).to include("can't be blank")
      end

      it "must be valid" do
        memory.area_id = 2
        expect(memory).to be_invalid
        expect(memory.errors[:area]).to include("can't be blank")
      end
    end

    context "location" do
      before :each do
        allow(subject).to receive(:geocode).and_return(true)
      end

      it "fetches the lat and long after validation if a location is given" do
        subject.location = 'test street'
        subject.valid?
        expect(subject).to have_received(:geocode)
      end

      it "does not fetch the lat and long after validation if no location is given" do
        subject.valid?
        expect(subject).not_to have_received(:geocode)
      end
    end

    context "categories" do
      it "is invalid with no categories" do
        memory = Fabricate.build(:memory, categories: [])
        expect(memory).to be_invalid
        expect(memory.errors[:categories]).to include("must have at least one")
      end

      it "is valid with one category" do
        memory = Fabricate.build(:memory, categories: Fabricate.times(1, :category))
        expect(memory).to be_valid
      end

      it "is valid with multiple categories" do
        memory = Fabricate.build(:memory, categories: Fabricate.times(2, :category))
        expect(memory).to be_valid
      end
    end
  end

  describe "date" do
    it "provides the year when memory only has a year" do
      expect(Memory.new(year: "2014").date).to eql("2014")
    end

    it "provides the month and year when memory has a month" do
      expect(Memory.new(year: "2014", month: "05").date).to eql("May 2014")
    end

    it "provides the day, month and year when memory has a month and a day" do
      expect(Memory.new(year: "2014", month: "05", day: "04").date).to eql("4th May 2014")
    end

    it "handles blanks" do
      expect(Memory.new(year: "2014", month: "", day: "").date).to eql("2014")
      expect(Memory.new(year: "2014", month: "05", day: "").date).to eql("May 2014")
      expect(Memory.new(year: "2014", month: "", day: "04").date).to eql("2014")
    end
  end

  describe "address" do
    it "provides an empty string if there is no area" do
      memory.area = nil
      expect(memory.address).to eql('')
    end

    it "provides the area name if there is an area but no location" do
      memory.location = nil
      expect(memory.address).to eql('Portobello')
    end

    it "provides the area name if there is an area but blank location" do
      memory.location = ""
      expect(memory.address).to eql('Portobello')
    end

    it "provides the location and area name if there is an area and location" do
      expect(memory.address).to eql('Kings Road, Portobello')
    end
  end

  describe "#category_list" do
    before :each do
      memory.categories.destroy_all
    end

    it "provides an empty string if there are no categories" do
      expect(memory.category_list).to eql('')
    end

    it "provides a single category string if there is one category" do
      memory.categories.build(name: 'Home')
      expect(memory.category_list).to eql('Home')
    end

    it "provides a comma separated list of categories if there are two categories" do
      memory.categories.build(name: 'Home')
      memory.categories.build(name: 'Transport')
      expect(memory.category_list).to eql('Home, Transport')
    end
  end
end
