class HomePagePresenter < SimpleDelegator
  def has_featured_memory?
    try(:featured_memory)
  end

  def has_featured_scrapbook?
    try(:featured_scrapbook)
  end
end
