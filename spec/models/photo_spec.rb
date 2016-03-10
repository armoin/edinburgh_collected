require 'rails_helper'

describe Photo do
  let(:test_user) { Fabricate.build(:user) }
  let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'files') }
  let(:file_name) { 'test.jpg' }
  let(:source)    { Rack::Test::UploadedFile.new(File.join(file_path, file_name)) }
  let!(:area)     { Fabricate(:area) }
  let(:memory)    { Fabricate.build(:photo_memory, user: test_user, source: source, area: area) }

  it_behaves_like "a memory"
  # it_behaves_like 'an image manipulator'

  it 'is a Memory of type "Photo"' do
    expect(subject).to be_a(Memory)
    expect(subject.type).to eql('Photo')
  end

  it 'has a label of "picture"' do
    expect(subject.label).to eq('picture')
  end

  describe '#info_list' do
    it 'includes info on acceptable file types' do
      expect(subject.info_list).to include('We currently support files of type .gif, .jpg, .jpeg or .png')
    end

    it 'includes info on not storing original size' do
      expect(subject.info_list).to include('We do not store image files at their original size. Please make sure that you store your own copy.')
    end

    it 'includes info on uploading from mobile' do
      expect(subject.info_list).to include('Please be aware the uploading files from a mobile device may incur charges from your mobile service provider.')
    end
  end

  describe 'validation' do
    describe "source" do
      it "can't be blank" do
        memory.source.remove!
        expect(memory).to be_invalid
        expect(memory.errors[:source]).to include("You need to choose a photo to upload")
      end

      describe 'must have an allowed file extension' do
        context "file is a .jpg" do
          let(:file_name) { 'test.jpg' }

          it "is valid" do
            expect(memory).to be_valid
          end
        end

        context "file is a .jpeg" do
          let(:file_name) { 'test.jpeg' }

          it "is valid" do
            expect(memory).to be_valid
          end
        end

        context "file is a .png" do
          let(:file_name) { 'test.png' }

          it "is valid" do
            expect(memory).to be_valid
          end
        end

        context "file is a .gif" do
          let(:file_name) { 'test.gif' }

          it "is valid" do
            expect(memory).to be_valid
          end
        end

        context "file is a .txt" do
          let(:file_name) { 'test.txt' }

          it "is invalid" do
            expect(memory).to be_invalid
            expect(memory.errors[:source]).to include("You are not allowed to upload \"txt\" files, allowed types: JPG, JPEG, GIF, PNG, jpg, jpeg, gif, png")
          end
        end
      end
    end

    describe 'year' do
      it "can't be blank" do
        memory.year = ""
        expect(memory).to be_invalid
        expect(memory.errors[:year]).to include("Please tell us when this dates from")
      end
    end
  end

  describe 'updating' do
    let(:now) { Time.now }
    let(:old) { 2.days.ago }

    before :each do
      allow(memory.source).to receive(:recreate_versions!)
      memory.updated_at = old
      memory.save!
    end

    context 'when photo has been rotated' do
      before :each do
        Timecop.freeze(now) do
          memory.update(image_angle: '90')
        end
      end

      it 'recreates the photo versions' do
        expect(memory.source).to have_received(:recreate_versions!)
      end

      it 'changes updated at' do
        expect(memory.updated_at).to eql(now)
      end
    end

    context 'when image has not been rotated' do
      context 'when image_angle is nil' do
        before :each do
          Timecop.freeze(now) do
            memory.update(image_angle: nil)
          end
        end

        it 'does not change updated at' do
          expect(memory.updated_at).to eql(old)
        end

        it 'does not recreate the photo versions' do
          expect(memory.source).not_to have_received(:recreate_versions!)
        end
      end

      context 'when image_angle is 0' do
        before :each do
          Timecop.freeze(now) do
            memory.update(image_angle: '0')
          end
        end

        it 'does not change updated at' do
          expect(memory.updated_at).to eql(old)
        end

        it 'does not recreate the photo versions' do
          expect(memory.source).not_to have_received(:recreate_versions!)
        end
      end
    end
  end

  describe "image_angle" do
    describe "when setting" do
      it "provides an integer when given a string" do
        subject.image_angle = "90"
        expect(subject.image_angle).to eql(90)
      end

      it "provides an integer when given an integer" do
        subject.image_angle = 90
        expect(subject.image_angle).to eql(90)
      end

      it "provides an integer when given a float" do
        subject.image_angle = "90.2"
        expect(subject.image_angle).to eql(90)
      end

      it "provides 0 when given nil" do
        subject.image_angle = nil
        expect(subject.image_angle).to eql(0)
      end

      it "provides nil when not set" do
        expect(subject.image_angle).to be_nil
      end
    end

    describe "when checking" do
      it "is false when image has no image_angle" do
        memory.image_angle = nil
        expect(memory.rotated?).to be_falsy
      end

      it "is false when image has image_angle of 0" do
        memory.image_angle = "0"
        expect(memory.rotated?).to be_falsy
      end

      it "is true when image is rotated by > 0" do
        memory.image_angle = "90"
        expect(memory.rotated?).to be_truthy
      end

      it "is true when image is rotated by < 0" do
        memory.image_angle = "-90"
        expect(memory.rotated?).to be_truthy
      end
    end
  end
end
