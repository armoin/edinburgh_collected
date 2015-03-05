require 'rails_helper'
require 'carrierwave/test/matchers'

describe AvatarUploader, slow: true do
  include CarrierWave::Test::Matchers

  let(:user)         { Fabricate.build(:user, id: 123) }
  let(:filename)     { 'test.jpg' }
  let(:path_to_file) { File.join(Rails.root, 'spec', 'fixtures', 'files', filename) }
  let(:uploader)     { AvatarUploader.new(user, :avatar) }
  let(:image_stub)   { double('image') }

  before :each do
    allow(uploader).to receive(:manipulate!).and_yield(image_stub)

    allow(image_stub).to receive(:rotate)
    allow(image_stub).to receive(:resize)
    allow(image_stub).to receive(:crop)
  end

  after do
    uploader.remove!
  end

  describe 'without processing' do
    let(:model_name)   { 'user' }
    it_behaves_like 'a base image uploader'

    describe '#default_url' do
      it 'fallsback to the default avatar image' do
        expect(uploader.default_url).to eql('fallback/default_avatar.png')
      end
    end

    describe "manipulation" do
      describe '#rotate' do
        it "rotates with the given image data" do
          user.image_angle = "90"
          uploader.rotate
          expect(image_stub).to have_received(:rotate).with("90")
        end
      end

      describe '#resize' do
        it "resizes with the given image data" do
          user.image_scale = "0.12345"
          uploader.resize
          expect(image_stub).to have_received(:resize).with("12.345%")
        end
      end

      describe '#crop' do
        it "crops with the given image data" do
          user.image_w = "90"
          user.image_h = "90"
          user.image_x =  "5"
          user.image_y = "12"
          uploader.crop
          expect(image_stub).to have_received(:crop).with("90x90+5+12")
        end
      end
    end
  end

  describe 'with processing' do
    let(:image_angle) { nil }
    let(:image_scale) { nil }
    let(:image_w)     { nil }
    let(:image_h)     { nil }
    let(:image_x)     { nil }
    let(:image_y)     { nil }

    before do
      AvatarUploader.enable_processing = true
    end

    after do
      AvatarUploader.enable_processing = false
    end

    describe 'processing' do
      before :each do
        user.image_angle = image_angle
        user.image_scale = image_scale
        user.image_w     = image_w
        user.image_h     = image_h
        user.image_x     = image_x
        user.image_y     = image_y

        uploader.process!
      end

      describe 'rotating' do
        context 'when an angle > 0 is given' do
          let(:image_angle) { '90' }

          it 'rotates the image' do
            expect(image_stub).to have_received(:rotate).with('90')
          end
        end

        context 'when an angle of 0 is given' do
          let(:image_angle) { '0' }

          it 'does not rotate the image' do
            expect(image_stub).not_to have_received(:rotate)
          end
        end

        context 'when an angle < 0 is given' do
          let(:image_angle) { '-90' }

          it 'rotates the image' do
            expect(image_stub).to have_received(:rotate).with('-90')
          end
        end

        context 'when a blank angle is given' do
          let(:image_angle) { '' }

          it 'does not rotate the image' do
            expect(image_stub).not_to have_received(:rotate)
          end
        end

        context 'when no angle is given' do
          let(:image_angle) { nil }

          it 'does not rotate the image' do
            expect(image_stub).not_to have_received(:rotate)
          end
        end
      end

      describe 'scaling' do
        context 'when a scale > 0 is given' do
          let(:image_scale) { '0.00001' }

          it 'scales the image' do
            expect(image_stub).to have_received(:resize).with('0.001%')
          end
        end

        context 'when a scale of 0 is given' do
          let(:image_scale) { '0.0' }

          it 'does not scale the image' do
            expect(image_stub).not_to have_received(:resize)
          end
        end

        context 'when a scale < 0 is given' do
          let(:image_scale) { '-0.00001' }

          it 'does not scale the image' do
            expect(image_stub).not_to have_received(:resize)
          end
        end

        context 'when a blank scale is given' do
          let(:image_scale) { '' }

          it 'does not scale the image' do
            expect(image_stub).not_to have_received(:resize)
          end
        end

        context 'when no scale is given' do
          let(:image_scale) { nil }

          it 'does not scale the image' do
            expect(image_stub).not_to have_received(:resize)
          end
        end
      end

      describe 'cropping' do
        context 'when all cropping values given' do
          let(:image_w) { '1' }
          let(:image_h) { '1' }
          let(:image_x) { '1' }
          let(:image_y) { '1' }

          it 'crops the image using the given values' do
            expect(image_stub).to have_received(:crop).with("1x1+1+1")
          end
        end

        context 'when width is 0' do
          let(:image_w) { '0' }
          let(:image_h) { '1' }

          it 'does not crop the image' do
            expect(image_stub).not_to have_received(:crop)
          end
        end

        context 'when height is 0' do
          let(:image_w) { '1' }
          let(:image_h) { '0' }

          it 'does not crop the image' do
            expect(image_stub).not_to have_received(:crop)
          end
        end

        context 'when both width and height are 0' do
          let(:image_w) { '0' }
          let(:image_h) { '0' }

          it 'does not crop the image' do
            expect(image_stub).not_to have_received(:crop)
          end
        end

        context 'when only width is given' do
          let(:image_w) { '1' }
          let(:image_h) { nil }
          let(:image_x) { nil }
          let(:image_y) { nil }

          it 'does not crop the image' do
            expect(image_stub).not_to have_received(:crop)
          end
        end

        context 'when only height is given' do
          let(:image_w) { nil }
          let(:image_h) { '1' }
          let(:image_x) { nil }
          let(:image_y) { nil }

          it 'does not crop the image' do
            expect(image_stub).not_to have_received(:crop)
          end
        end

        context 'when neither width and height are given' do
          let(:image_w) { nil }
          let(:image_h) { nil }

          context 'but x and y are given' do
            let(:image_x) { '1' }
            let(:image_y) { '1' }

            it 'does not crop the image' do
              expect(image_stub).not_to have_received(:crop)
            end
          end

          context 'but x is given' do
            let(:image_x) { '1' }
            let(:image_y) { nil }

            it 'does not crop the image' do
              expect(image_stub).not_to have_received(:crop)
            end
          end

          context 'but y is given' do
            let(:image_x) { nil }
            let(:image_y) { '1' }

            it 'does not crop the image' do
              expect(image_stub).not_to have_received(:crop)
            end
          end
        end

        context 'when both width and height are given' do
          let(:image_w) { '1' }
          let(:image_h) { '1' }

          context 'and x and y are not given' do
            let(:image_x) { nil }
            let(:image_y) { nil }

            it 'crops the image using default x and y coords' do
              expect(image_stub).to have_received(:crop).with("1x1+0+0")
            end
          end

          context 'and only x is given' do
            let(:image_x) { '1' }
            let(:image_y) { nil }

            it 'crops the image using default y coord' do
              expect(image_stub).to have_received(:crop).with("1x1+1+0")
            end
          end

          context 'and only y is given' do
            let(:image_x) { nil }
            let(:image_y) { '1' }

            it 'crops the image using default x coord' do
              expect(image_stub).to have_received(:crop).with("1x1+0+1")
            end
          end
        end
      end
    end
  end
end
