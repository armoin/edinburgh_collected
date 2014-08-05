require 'rails_helper'

describe Asset do
  let(:id) { "1" }
  let(:asset_data) {
    {
      "title"       => "Arthur's Seat",
      "file_type"   => "img",
      "url"         => "/images/meadows.jpg",
      "description" => "Arthur's Seat is the plug of a long extinct volcano.",
      "updated_at"  => "2014-06-24T09:55:58.874Z",
      "created_at"  => "2014-06-24T09:55:58.874Z",
      "id"          => id
    }
  }
  let(:assets) { [asset_data] }

  describe 'fetching assets' do
    context 'fetch all' do
      before(:each) do
        allow(AssetWrapper).to receive(:fetchAll) { assets }
      end

      it 'fetches all assets' do
        Asset.all
        expect(AssetWrapper).to have_received(:fetchAll)
      end

      it 'converts them to Assets' do
        assets = Asset.all
        expect(assets.first).to be_a(Asset)
      end
    end

    context "fetch user's assets" do
      before(:each) do
        allow(AssetWrapper).to receive(:fetchUser) { assets }
      end

      it "fetches user's assets" do
        Asset.user(auth_token)
        expect(AssetWrapper).to have_received(:fetchUser).with(auth_token)
      end

      it 'converts them to Assets' do
        assets = Asset.user(auth_token)
        expect(assets.first).to be_a(Asset)
      end
    end

    context 'fetch one' do
      before(:each) do
        allow(AssetWrapper).to receive(:fetch) { asset_data }
      end

      it 'fetches the requested asset' do
        Asset.find(id)
        expect(AssetWrapper).to have_received(:fetch).with(id)
      end

      it 'converts it into an Asset' do
        asset = Asset.find(id)
        expect(asset).to be_a(Asset)
        expect(asset.id).to eql(id)
      end
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

  describe "saving" do
    before :each do
      allow(AssetWrapper).to receive(:create).and_return('123')
    end

    context "when valid" do
      before :each do
        allow(subject).to receive(:valid?).and_return(true)
      end

      it "returns true" do
        expect(subject.save).to be_truthy
      end

      context "when a file is attached" do
        let(:mock_source) { double('source', store!: true, url: 'thingy') }

        before :each do
          allow(subject).to receive(:source).and_return(mock_source)
          subject.save
        end

        it "stores the file" do
          expect(mock_source).to have_received(:store!)
        end

        it "attaches the URL to the asset" do
          expect(subject.url).to eql('thingy')
        end
      end

      it "saves the asset data via the API" do
        subject.save
        expect(AssetWrapper).to have_received(:create).with(subject)
      end

      it "assigns the returned id" do
        subject.save
        expect(subject.id).to eql('123')
      end
    end

    context "when invalid" do
      it "returns false" do
        expect(subject.save).to be_falsy
      end
    end
  end

  it "allows instantiation with attributes" do
    asset = Asset.new(asset_data)
    attrs = %w(id title file_type url description created_at updated_at)
    attrs.each do |attr|
      expect(asset.send(attr)).to eql(asset_data[attr])
    end
  end

  describe 'validation' do
    let(:valid_attrs) {{
      year: "2014",
      file_type: "image",
      title: "A test"
    }}
    let(:file_name) { 'test.jpg' }
    let(:asset)    { Asset.new(valid_attrs) }

    before :each do
      asset.source = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'files', file_name))
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

  describe "thumb" do
    it "returns an empty string if there is no URL" do
      expect(subject.thumb).to eq('')
    end

    it "returns the thumb version of the URL if there is a URL" do
      subject.url = "test.jpg"
      expect(subject.thumb).to eq('thumb_test.jpg')
    end

    it "takes the path into account" do
      subject.url = "/path/to/test.jpg"
      expect(subject.thumb).to eq('/path/to/thumb_test.jpg')
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
