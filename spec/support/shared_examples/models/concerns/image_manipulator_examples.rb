RSpec.shared_examples 'an image manipulator' do
  describe 'image data' do
    it 'can have an image angle' do
      subject.image_angle = 270
      expect(subject.image_angle).to eql(270)
    end

    it 'can have an image scale' do
      subject.image_scale = 0.12345
      expect(subject.image_scale).to eql(0.12345)
    end

    it 'can have an image width' do
      subject.image_w = 90
      expect(subject.image_w).to eql(90)
    end

    it 'can have an image height' do
      subject.image_h = 90
      expect(subject.image_h).to eql(90)
    end

    it 'can have an image x coord' do
      subject.image_x = 5
      expect(subject.image_x).to eql(5)
    end

    it 'can have an image y coord' do
      subject.image_y = 12
      expect(subject.image_y).to eql(12)
    end
  end

  describe '#rotated?' do
    it 'is false if the image_angle is nil' do
      subject.image_angle = nil
      expect(subject).not_to be_rotated
    end

    it 'is false if the image_angle is blank' do
      subject.image_angle = ''
      expect(subject).not_to be_rotated
    end

    it 'is false if the image_angle is 0' do
      subject.image_angle = '0'
      expect(subject).not_to be_rotated
    end

    it 'is true if the image_angle is less than 0' do
      subject.image_angle = '-90'
      expect(subject).to be_rotated
    end

    it 'is true if the image_angle is greater than 0' do
      subject.image_angle = '90'
      expect(subject).to be_rotated
    end
  end

  describe '#scaled?' do
    it 'is false if the image_scale is nil' do
      subject.image_scale = nil
      expect(subject).not_to be_scaled
    end

    it 'is false if the image_scale is blank' do
      subject.image_scale = ''
      expect(subject).not_to be_scaled
    end

    it 'is false if the image_scale is 0' do
      subject.image_scale = '0'
      expect(subject).not_to be_scaled
    end

    it 'is false if the image_scale is less than 0' do
      subject.image_scale = '-0.00001'
      expect(subject).not_to be_scaled
    end

    it 'is true if the image_scale is greater than 0' do
      subject.image_scale = '0.00001'
      expect(subject).to be_scaled
    end
  end

  describe '#cropped?' do
    it 'is false if the image_w and the image_h are nil' do
      subject.image_w = nil
      subject.image_h = nil
      expect(subject).not_to be_cropped
    end

    it 'is false if the image_w is not nil but the image_h is nil' do
      subject.image_w = '1'
      subject.image_h = nil
      expect(subject).not_to be_cropped
    end

    it 'is false if the image_w is nil but the image_h is not nil' do
      subject.image_w = nil
      subject.image_h = '1'
      expect(subject).not_to be_cropped
    end

    it 'is false if the image_w and the image_h are blank' do
      subject.image_w = ''
      subject.image_h = ''
      expect(subject).not_to be_cropped
    end

    it 'is false if the image_w is not blank but the image_h is blank' do
      subject.image_w = '1'
      subject.image_h = ''
      expect(subject).not_to be_cropped
    end

    it 'is false if the image_w is blank but the image_h is not blank' do
      subject.image_w = ''
      subject.image_h = '1'
      expect(subject).not_to be_cropped
    end

    it 'is false if the image_w and the image_h are both 0' do
      subject.image_w = '0'
      subject.image_h = '0'
      expect(subject).not_to be_cropped
    end

    it 'is false if the image_w is not 0 but the image_h is 0' do
      subject.image_w = '1'
      subject.image_h = '0'
      expect(subject).not_to be_cropped
    end

    it 'is false if the image_w is 0 but the image_h is not 0' do
      subject.image_w = '0'
      subject.image_h = '1'
      expect(subject).not_to be_cropped
    end

    it 'is false if the image_w and the image_h are both less than 0' do
      subject.image_w = '-1'
      subject.image_h = '-1'
      expect(subject).not_to be_cropped
    end

    it 'is false if the image_w is not less than 0 but the image_h is less than 0' do
      subject.image_w = '1'
      subject.image_h = '-1'
      expect(subject).not_to be_cropped
    end

    it 'is false if the image_w is less than 0 but the image_h is not less than 0' do
      subject.image_w = '-1'
      subject.image_h = '1'
      expect(subject).not_to be_cropped
    end

    it 'is true if the image_w and the image_h are both greater than 0' do
      subject.image_w = '1'
      subject.image_h = '1'
      expect(subject).to be_cropped
    end
  end

  describe '#image_modified?' do
    it 'is false if the image has not been rotated, scaled or cropped' do
      subject.image_angle = '0'
      subject.image_scale = '0'
      subject.image_w     = '0'
      subject.image_h     = '0'

      expect(subject.image_modified?).to be_falsy
    end

    it 'is true if the image has been rotated' do
      subject.image_angle = '90'
      subject.image_scale = '0'
      subject.image_w     = '0'
      subject.image_h     = '0'

      expect(subject.image_modified?).to be_truthy
    end

    it 'is true if the image has been scaled' do
      subject.image_angle = '0'
      subject.image_scale = '0.12345'
      subject.image_w     = '0'
      subject.image_h     = '0'

      expect(subject.image_modified?).to be_truthy
    end

    it 'is true if the image has been cropped' do
      subject.image_angle = '0'
      subject.image_scale = '0'
      subject.image_w     = '5'
      subject.image_h     = '12'

      expect(subject.image_modified?).to be_truthy
    end
  end

  describe '#process_image' do
    let(:now)              { Time.now }
    let(:old)              { 2.days.ago }
    let(:image)            { nil }
    let(:previous_changes) { {} }
    let(:image_modified)   { false }

    subject { Fabricate(:user, avatar: image, updated_at: old) }

    before :each do
      allow(subject.avatar).to receive(:recreate_versions!)
      allow(subject).to receive(:save)
      allow(subject).to receive(:image_modified?).and_return(image_modified)
      allow(subject).to receive(:previous_changes).and_return(previous_changes)
    end

    context 'when image has been modified' do
      let(:image_modified) { true }

      context 'and there is not an attached image' do
        let(:image) { nil }

        before :each do
          Timecop.freeze(now) do
            @result = subject.process_image
          end
        end

        context 'and there were not previously changes to the image' do
          let(:previous_changes) { {} }

          it 'does not recreate the image versions' do
            expect(subject.avatar).not_to have_received(:recreate_versions!)
          end
        end

        context 'and there were previously changes to the image' do
          let(:previous_changes) { {avatar: []} }

          it 'does not recreate the image versions' do
            expect(subject.avatar).not_to have_received(:recreate_versions!)
          end
        end
      end

      context 'and there is already an attached image' do
        let(:image) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.jpg')) }

        before :each do
          Timecop.freeze(now) do
            @result = subject.process_image
          end
        end

        context 'and there were not previously changes to the image' do
          let(:previous_changes) { {} }

          it 'recreates the image versions' do
            expect(subject.avatar).to have_received(:recreate_versions!)
          end
        end

        context 'and there were previously changes to the image' do
          let(:previous_changes) { {avatar: []} }

          it 'does not recreate the image versions' do
            expect(subject.avatar).not_to have_received(:recreate_versions!)
          end
        end
      end

      it 'changes updated at' do
        Timecop.freeze(now) do
          @result = subject.process_image
        end
        expect(subject.updated_at).to eql(now)
      end

      it 'saves the record so that the image is properly updated' do
        Timecop.freeze(now) do
          @result = subject.process_image
        end
        expect(subject).to have_received(:save).once
      end

      context 'when the save is successful' do
        before :each do
          allow(subject).to receive(:save).and_return(true)
          Timecop.freeze(now) do
            @result = subject.process_image
          end
        end

        it 'returns true' do
          expect(@result).to be_truthy
        end
      end

      context 'when the save fails' do
        before :each do
          allow(subject).to receive(:save).and_return(false)
          Timecop.freeze(now) do
            @result = subject.process_image
          end
        end

        it 'returns false' do
          expect(@result).to be_falsy
        end
      end
    end

    context 'when image has not been modified' do
      let(:image_modified) { false }

      before :each do
        Timecop.freeze(now) do
          @result = subject.process_image
        end
      end

      context 'and there is not an attached image' do
        let(:image) { nil }

        context 'and there were not previously changes to the image' do
          let(:previous_changes) { {} }

          it 'does not recreate the image versions' do
            expect(subject.avatar).not_to have_received(:recreate_versions!)
          end
        end

        context 'and there were previously changes to the image' do
          let(:previous_changes) { {avatar: []} }

          it 'does not recreate the image versions' do
            expect(subject.avatar).not_to have_received(:recreate_versions!)
          end
        end
      end

      context 'and there is already an attached image' do
        let(:image) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'files', 'test.jpg')) }

        context 'and there were not previously changes to the image' do
          let(:previous_changes) { {} }

          it 'does not recreate the image versions' do
            expect(subject.avatar).not_to have_received(:recreate_versions!)
          end
        end

        context 'and there were previously changes to the image' do
          let(:previous_changes) { {avatar: []} }

          it 'does not recreate the image versions' do
            expect(subject.avatar).not_to have_received(:recreate_versions!)
          end
        end
      end

      it 'does not change updated at' do
        expect(subject.updated_at).to eql(old)
      end

      it 'does not recreate the image versions' do
        expect(subject.avatar).not_to have_received(:recreate_versions!)
      end

      it 'returns true' do
        expect(@result).to be_truthy
      end
    end
  end
end