class ModelWithImageUpdater
  def initialize(model, model_params)
    @model = model
    @model_params = model_params
  end

  def process
    remove_blank_remote_url
    @model.update(@model_params) && @model.process_image
  end

  private

  # If you give Carrierwave a blank remote url then it considers the
  # file changed. This causes issues when you only want to run a method
  # if there have been no changes to the file, as you will get a false
  # positive on <mounted_as>_changed?
  def remove_blank_remote_url

    # Ignore this check if the model hasn't got any uploaders
    return unless @model.class.respond_to?(:uploaders)

    # A model can have several uploaders so deal with each of them.
    @model.class.uploaders.each do |uploader|
      uploader_name = uploader.first
      @model_params.delete_if {|k,v| k == "remote_#{uploader_name}_url".to_sym && (v.nil? || v == '') }
    end

  end
end
