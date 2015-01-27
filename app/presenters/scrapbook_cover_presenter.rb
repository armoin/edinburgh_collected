class ScrapbookCoverPresenter
  attr_reader :scrapbook

  def initialize(scrapbook)
    @scrapbook = scrapbook
  end

  def path_to_scrapbook
    Rails.application.routes.url_helpers.scrapbook_path(@scrapbook)
  end

  def cover
    @cover ||= CoverMemoriesPresenter.new(@scrapbook.approved_ordered_memories)
  end
end