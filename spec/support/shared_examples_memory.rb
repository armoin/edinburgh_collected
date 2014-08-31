# let(:memory)    # must be declared in calling spec
# let(:file_name) # must be declared in calling spec

RSpec.shared_examples "a memory" do
  let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'files') }
  let(:source)    { Rack::Test::UploadedFile.new(File.join(file_path, file_name)) }
  let(:test_user) { Fabricate.build(:user) }
  let!(:area)     { Fabricate(:area) }

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

      context "when type is image" do
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
            expect(memory.errors[:source]).to include("You are not allowed to upload \"txt\" files, allowed types: JPG, JPEG, GIF, PNG, jpg, jpeg, gif, png")
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

    context "type" do
      it "can't be blank" do
        memory.type = ''
        expect(memory).to be_invalid
        expect(memory.errors[:type]).to include('You can only add image files.')
      end

      it "must be an allowed type" do
        memory.type = 'doodah'
        expect(memory).to be_invalid
        expect(memory.errors[:type]).to include('You can only add image files.')
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
  end
end

