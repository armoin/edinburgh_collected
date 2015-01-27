class OwnedScrapbookCoverPresenter
  attr_reader :scrapbook

  def initialize(scrapbook)
    @scrapbook = scrapbook
  end

  def path_to_scrapbook
    Rails.application.routes.url_helpers.my_scrapbook_path(@scrapbook)
  end

  def cover
    @cover ||= CoverMemoriesPresenter.new(@scrapbook.ordered_memories)
  end
end