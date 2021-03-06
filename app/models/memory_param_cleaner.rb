class MemoryParamCleaner
  def self.clean(params)
    params.require(:memory).permit(
      :title,
      :type,
      :image_angle,
      :source,
      :source_cache,
      :description,
      :year,
      :month,
      :day,
      :attribution,
      :area_id,
      :location,
      :tag_list,
      :moderation_reason,
      :category_ids => [],
    )
  end
end

