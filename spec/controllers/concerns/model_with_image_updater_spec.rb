require 'spec_helper'
require 'carrierwave'
require_relative '../../../app/controllers/concerns/model_with_image_updater'

class FirstUploader < CarrierWave::Uploader::Base; end

class SecondUploader < CarrierWave::Uploader::Base; end

module InactiveRecord
  class Base
    def update(params); end

    def process_image; end
  end
end

class NoUploader < InactiveRecord::Base; end

class OneUploader < InactiveRecord::Base
  extend CarrierWave::Mount
  mount_uploader :first, FirstUploader
end

class TwoUploaders < InactiveRecord::Base
  extend CarrierWave::Mount
  mount_uploader :first, FirstUploader
  mount_uploader :second, SecondUploader
end

describe ModelWithImageUpdater do
  let(:model)        { OneUploader.new }
  let(:base_params)  { {'first_name' => 'Mary'} }
  let(:model_params) { base_params }
  let(:updated)      { true }
  let(:processed)    { true }

  subject { ModelWithImageUpdater.new(model, model_params) }

  describe '#process' do
    before :each do
      allow(model).to receive(:update).and_return(updated)
      allow(model).to receive(:process_image).and_return(processed)

      @result = subject.process
    end

    describe 'updating the model' do
      describe 'when model has no uploaders' do
        let(:model) { NoUploader.new }

        context 'and a non-blank remote url is given' do
          let(:model_params) { base_params.merge('remote_first_url' => 'test/path') }

          it 'updates the model with the given params' do
            expect(model).to have_received(:update).with({'first_name' => 'Mary', 'remote_first_url' => 'test/path'})
          end
        end

        context 'and a blank remote url is given' do
          let(:model_params) { base_params.merge('remote_first_url' => '') }

          it 'updates the model with the given params' do
            expect(model).to have_received(:update).with({'first_name' => 'Mary', 'remote_first_url' => ''})
          end
        end

        context 'and a nil remote url is given' do
          let(:model_params) { base_params.merge('remote_first_url' => nil) }

          it 'updates the model with the given params' do
            expect(model).to have_received(:update).with({'first_name' => 'Mary', 'remote_first_url' => nil})
          end
        end
      end

      describe 'when model has one uploader' do
        let(:model) { OneUploader.new }

        context 'and a remote url for that uploader is given' do
          context 'that is not blank' do
            let(:model_params) { base_params.merge('remote_first_url' => 'test/path') }

            it 'updates the model with the given params' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary', 'remote_first_url' => 'test/path'})
            end
          end

          context 'that is empty' do
            let(:model_params) { base_params.merge('remote_first_url' => '') }

            it 'updates the model without the remote url for the uploader' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary'})
            end
          end

          context 'that is nil' do
            let(:model_params) { base_params.merge('remote_first_url' => nil) }

            it 'updates the model without the remote url for the uploader' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary'})
            end
          end
        end

        context 'and a remote url that is not for that uploader is given' do
          context 'that is not blank' do
            let(:model_params) { base_params.merge('remote_other_url' => 'test/path') }

            it 'updates the model with the given params' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary', 'remote_other_url' => 'test/path'})
            end
          end

          context 'that is empty' do
            let(:model_params) { base_params.merge('remote_other_url' => '') }

            it 'updates the model with the given params' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary', 'remote_other_url' => ''})
            end
          end

          context 'that is nil' do
            let(:model_params) { base_params.merge('remote_other_url' => nil) }

            it 'updates the model with the given params' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary', 'remote_other_url' => nil})
            end
          end
        end
      end

      describe 'when model has more than one uploader' do
        let(:model) { TwoUploaders.new }

        context 'and a remote url for the first uploader is given' do
          context 'that is not blank' do
            let(:model_params) { base_params.merge('remote_first_url' => 'test/path') }

            it 'updates the model with the given params' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary', 'remote_first_url' => 'test/path'})
            end
          end

          context 'that is empty' do
            let(:model_params) { base_params.merge('remote_first_url' => '') }

            it 'updates the model without the remote url for the uploader' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary'})
            end
          end

          context 'that is nil' do
            let(:model_params) { base_params.merge('remote_first_url' => nil) }

            it 'updates the model without the remote url for the uploader' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary'})
            end
          end
        end

        context 'and a remote url for the second uploader is given' do
          context 'that is not blank' do
            let(:model_params) { base_params.merge('remote_second_url' => 'test/path') }

            it 'updates the model with the given params' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary', 'remote_second_url' => 'test/path'})
            end
          end

          context 'that is empty' do
            let(:model_params) { base_params.merge('remote_second_url' => '') }

            it 'updates the model without the remote url for the uploader' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary'})
            end
          end

          context 'that is nil' do
            let(:model_params) { base_params.merge('remote_second_url' => nil) }

            it 'updates the model without the remote url for the uploader' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary'})
            end
          end
        end

        context 'and a remote url that is not for any uploader is given' do
          context 'that is not blank' do
            let(:model_params) { base_params.merge('remote_other_url' => 'test/path') }

            it 'updates the model with the given params' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary', 'remote_other_url' => 'test/path'})
            end
          end

          context 'that is empty' do
            let(:model_params) { base_params.merge('remote_other_url' => '') }

            it 'updates the model with the given params' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary', 'remote_other_url' => ''})
            end
          end

          context 'that is nil' do
            let(:model_params) { base_params.merge('remote_other_url' => nil) }

            it 'updates the model with the given params' do
              expect(model).to have_received(:update).with({'first_name' => 'Mary', 'remote_other_url' => nil})
            end
          end
        end
      end
    end

    describe 'processing the image' do
      context 'when model was successfully updated' do
        let(:updated) { true }

        it 'processes the attached image' do
          expect(model).to have_received(:process_image)
        end
      end

      context 'when model was not successfully updated' do
        let(:updated) { false }

        it 'does not process the attached image' do
          expect(model).not_to have_received(:process_image)
        end
      end
    end

    context 'when model is not successfully updated' do
      let(:updated) { false }

      it 'returns false' do
        expect(@result).to be_falsy
      end
    end

    context 'when model is successfully updated' do
      let(:updated) { true }

      context 'but image is not successfully processed' do
        let(:processed) { false }

        it 'returns false' do
          expect(@result).to be_falsy
        end
      end

      context 'and image is successfully processed' do
        let(:processed) { true }

        it 'returns true' do
          expect(@result).to be_truthy
        end
      end
    end
  end
end