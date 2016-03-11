require 'rails_helper'
require 'carrierwave/test/matchers'

describe HeroImageUploader, slow: true do
  include CarrierWave::Test::Matchers

  let(:home_page) do
    HomePage.new(
      id: 123,
      featured_memory:    Fabricate(:approved_photo_memory),
      featured_scrapbook: Fabricate(:approved_scrapbook)
    )
  end
  let(:filename)     { 'test.jpg' }
  let(:path_to_file) { File.join(Rails.root, 'spec', 'fixtures', 'files', filename) }
  let(:uploader)     { HeroImageUploader.new(home_page, :hero_image) }
  let(:image_stub)   { double('image') }

  before :each do
    allow(uploader).to receive(:manipulate!).and_yield(image_stub)

    allow(image_stub).to receive(:resize)
    allow(image_stub).to receive(:crop)
  end

  after do
    uploader.remove!
  end

  describe 'without processing' do
    let(:model_name)   { 'home_page' }
    it_behaves_like 'a base image uploader'

    describe "manipulation" do
      describe '#resize' do
        it "resizes with the given image data" do
          home_page.image_scale = '0.12345'
          uploader.resize
          expect(image_stub).to have_received(:resize).with('12.345%')
        end
      end

      describe '#crop' do
        it "crops with the given image data" do
          home_page.image_w = '90'
          home_page.image_h = '90'
          home_page.image_x =  '5'
          home_page.image_y = '12'
          uploader.crop
          expect(image_stub).to have_received(:crop).with('90x90+5+12')
        end
      end
    end
  end

  describe 'with processing' do
    let(:image_scale) { nil }
    let(:image_w)     { nil }
    let(:image_h)     { nil }
    let(:image_x)     { nil }
    let(:image_y)     { nil }

    before do
      HeroImageUploader.enable_processing = true
    end

    after do
      HeroImageUploader.enable_processing = false
    end

    describe 'processing' do
      before :each do
        home_page.image_scale = image_scale
        home_page.image_w     = image_w
        home_page.image_h     = image_h
        home_page.image_x     = image_x
        home_page.image_y     = image_y

        uploader.process!
      end

      describe 'scaling' do
        context 'when a scale > 0 is given' do
          let(:image_scale) { '0.00001' }

          it 'scales the image' do
            expect(image_stub).to have_received(:resize)#.with('0.001%')
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
