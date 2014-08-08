require 'rails_helper'

describe Asset do
  let(:file_path)  { File.join(Rails.root, 'spec', 'fixtures', 'files') }
  let(:file_name)  { 'test.jpg' }
  let(:source)     { Rack::Test::UploadedFile.new(File.join(file_path, file_name)) }
  let(:asset_data) {
    {
      title:       "Arthur's Seat",
      file_type:   "image",
      year:        "2014",
      description: "Arthur's Seat is the plug of a long extinct volcano.",
      source:      source
    }
  }

  describe 'ordering' do
    it 'sorts them by reverse created at date' do
      asset1 = Asset.create(asset_data)
      asset2 = Asset.create(asset_data)
      expect(Asset.first).to eql(asset2)
      expect(Asset.last).to eql(asset1)
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
        expect(Asset.current_year).to eql(2014)
      end
    end

    describe 'furthest_year' do
      it 'returns the year 120 years before the current year' do
        expect(Asset.furthest_year).to eql(1894)
      end
    end
  end

  describe 'validation' do
    let(:valid_attrs) {{
      year: "2014",
      file_type: "image",
      title: "A test"
    }}
    let(:asset)    { Asset.new(valid_attrs) }

    before :each do
      asset.source = source
    end

    it "is valid with valid attributes" do
      expect(asset).to be_valid
    end

    describe "year" do
      it "can't be blank" do
        asset.year = ""
        expect(asset).to be_invalid
        expect(asset.errors.messages.values.first).to include("Please tell us when this dates from.")
      end

      it "is invalid if in the future" do
        asset.year = 1.year.from_now.year.to_s
        expect(asset).to be_invalid
        expect(asset.errors.messages.values.first).to include("must be within the last 120 years.")
      end

      it "is invalid if too far in the past" do
        asset.year = (Asset::MAX_YEAR_RANGE+1).years.ago.year.to_s
        expect(asset).to be_invalid
        expect(asset.errors.messages.values.first).to include("must be within the last 120 years.")
      end

      it "is valid at earliest boundary" do
        asset.year = Asset::MAX_YEAR_RANGE.years.ago.year.to_s
        expect(asset).to be_valid
        expect(asset.errors.messages.values.first).to be_nil
      end

      it "is valid at latest boundary" do
        asset.year = Time.now.year.to_s
        expect(asset).to be_valid
        expect(asset.errors.messages.values.first).to be_nil
      end
    end

    context "source" do
      it "can't be blank" do
        asset.source.remove!
        expect(asset).to be_invalid
        expect(asset.errors.messages.values.first).to include("You need to choose a file to upload.")
      end

      context "when file type is image" do
        context "and file is a .jpg" do
          let(:file_name) { 'test.jpg' }

          it "is valid" do
            expect(asset).to be_valid
          end
        end

        context "and file is a .jpeg" do
          let(:file_name) { 'test.jpeg' }

          it "is valid" do
            expect(asset).to be_valid
          end
        end

        context "and file is a .png" do
          let(:file_name) { 'test.png' }

          it "is valid" do
            expect(asset).to be_valid
          end
        end

        context "and file is a .gif" do
          let(:file_name) { 'test.gif' }

          it "is valid" do
            expect(asset).to be_valid
          end
        end

        context "and file is a .txt" do
          let(:file_name) { 'test.txt' }

          it "is invalid" do
            expect(asset).to be_invalid
            expect(asset.errors.messages.values.first).to include('must be of type .jpg, .jpeg, .png, .gif')
          end
        end

        # context "and remote_source_url is given instead of file" do
        #   let(:file_name) { 'test.txt' }
        #
        #   it "is ignores validation for just now" do
        #     asset.remote_source_url = 'test/url'
        #     expect(asset).to be_valid
        #   end
        # end
      end
    end

    context "file type" do
      it "can't be blank" do
        asset.file_type = ''
        expect(asset).to be_invalid
        expect(asset.errors.messages.values.first).to include('You can only add image files.')
      end

      it "must be an allowed file type" do
        asset.file_type = 'doodah'
        expect(asset).to be_invalid
        expect(asset.errors.messages.values.first).to include('You can only add image files.')
      end
    end

    it "title can't be blank" do
      asset.title = ""
      expect(asset).to be_invalid
      expect(asset.errors.messages.values.first).to include("Please let us know what you would like to call this.")
    end
  end

  describe "date" do
    it "provides the year when asset only has a year" do
      expect(Asset.new(year: "2014").date).to eql("2014")
    end

    it "provides the month and year when asset has a month" do
      expect(Asset.new(year: "2014", month: "05").date).to eql("May 2014")
    end

    it "provides the day, month and year when asset has a month and a day" do
      expect(Asset.new(year: "2014", month: "05", day: "04").date).to eql("4th May 2014")
    end

    it "handles blanks" do
      expect(Asset.new(year: "2014", month: "", day: "").date).to eql("2014")
      expect(Asset.new(year: "2014", month: "05", day: "").date).to eql("May 2014")
      expect(Asset.new(year: "2014", month: "", day: "04").date).to eql("2014")
    end
  end
end
