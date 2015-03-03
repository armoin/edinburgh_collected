require 'rails_helper'
require 'carrierwave/test/matchers'

describe AvatarUploader, slow: true do
  include CarrierWave::Test::Matchers

  let(:image_data)   { {} }
  let(:user)         { Fabricate.build(:user, id: 123, image_data: image_data) }
  let(:model_name)   { 'user' }
  let(:filename)     { 'test.jpg' }
  let(:path_to_file) { File.join(Rails.root, 'spec', 'fixtures', 'files', filename) }
  let(:uploader)     { AvatarUploader.new(user, :avatar) }

  after do
    uploader.remove!
  end

  describe 'without processing' do
    it_behaves_like 'a base image uploader'

    describe "manipulation" do
      let(:image_data) {
        {
          angle: 90,
          scale: 0.12345,
          w:     90,
          h:     90,
          x:      5,
          y:     12
        }
      }
      let(:image_stub) { double('image') }

      before :each do
        allow(uploader).to receive(:manipulate!).and_yield(image_stub)

        allow(image_stub).to receive(:rotate)
        allow(image_stub).to receive(:resize)
        allow(image_stub).to receive(:crop)
      end

      describe '#rotate' do
        it "rotates with the given image data" do
          uploader.rotate
          expect(image_stub).to have_received(:rotate).with("90")
        end
      end

      describe '#resize' do
        it "resizes with the given image data" do
          uploader.resize
          expect(image_stub).to have_received(:resize).with("12.345%")
        end
      end

      describe '#crop' do
        it "crops with the given image data" do
          uploader.crop
          expect(image_stub).to have_received(:crop).with("90x90+5+12")
        end
      end
    end
  end

  describe 'with processing' do
    before do
      AvatarUploader.enable_processing = true
    end

    after do
      AvatarUploader.enable_processing = false
    end

    describe 'processing' do
      before :each do
        allow(uploader).to receive(:rotate)
        allow(uploader).to receive(:resize)
        allow(uploader).to receive(:crop)

        uploader.process!
      end

      describe 'rotating' do
        context 'when an angle is given' do
          let(:image_data) { { angle: '90' } }

          it 'rotates the image' do
            expect(uploader).to have_received(:rotate)
          end
        end

        context 'when a blank angle is given' do
          let(:image_data) { { angle: '' } }

          it 'does not rotate the image' do
            expect(uploader).not_to have_received(:rotate)
          end
        end

        context 'when no angle is given' do
          let(:image_data) { {} }

          it 'does not rotate the image' do
            expect(uploader).not_to have_received(:rotate)
          end
        end
      end

      describe 'scaling' do
        context 'when scaling data is given' do
          let(:image_data) { {scale: '0.12345'} }

          it 'scales the image' do
            expect(uploader).to have_received(:resize)
          end
        end

        context 'when blank scaling data is given' do
          let(:image_data) { {scale: ''} }

          it 'does not scale the image' do
            expect(uploader).not_to have_received(:resize)
          end
        end

        context 'when no scaling data is given' do
          let(:image_data) { {} }

          it 'does not scale the image' do
            expect(uploader).not_to have_received(:resize)
          end
        end
      end

      describe 'cropping' do
        context 'when cropping data is given' do
          let(:image_data) {
            {
              w:     90,
              h:     90,
              x:      5,
              y:     12
            }
          }

          it 'crops the image' do
            expect(uploader).to have_received(:crop)
          end
        end

        context 'when blank cropping data is given' do
          let(:image_data) {
            {
              w:     '',
              h:     '',
              x:     '',
              y:     ''
            }
          }

          it 'does not crop the image' do
            expect(uploader).not_to have_received(:crop)
          end
        end

        context 'when no cropping data is given' do
          let(:image_data) { {} }

          it 'does not crop the image' do
            expect(uploader).not_to have_received(:crop)
          end
        end
      end
    end
  end
end
