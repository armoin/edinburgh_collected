class MemoryParamCleaner
  def self.clean(params)
    params.require(:memory).permit(
      :title,
      :type,
      :rotation,
      :source,
      :description,
      :year,
      :month,
      :day,
      :attribution,
      :area_id,
      :location,
      :category_ids => [],
    )
  end
end

