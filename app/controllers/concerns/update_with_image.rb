module UpdateWithImage
  extend ActiveSupport::Concern

  def update_and_process_image(model, model_params)
    ModelWithImageUpdater.new(model, model_params).process
  end
end
