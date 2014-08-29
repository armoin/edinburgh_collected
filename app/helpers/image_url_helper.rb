module ImageUrlHelper
  def cache_busted_url(model, version=nil)
    "#{model.source_url(version)}?#{model.updated_at.to_i}"
  end
end

