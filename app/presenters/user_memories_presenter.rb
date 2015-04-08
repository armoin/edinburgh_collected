class UserMemoriesPresenter
  attr_reader :requested_user

  def initialize(requested_user, current_user, page)
    @requested_user = requested_user
    @current_user = current_user
    @page = page
  end

  def page_title
    title = requested_is_current? ? "Your" : @requested_user.screen_name.possessive
    title << " memories"
  end

  def memories_count
    memories.count
  end

  def scrapbooks_count
    scrapbooks.count
  end

  def paged_memories
    memories.page(@page)
  end

  def can_add_memories?
    requested_is_current?
  end

  private

  def memories
    @memories ||= if requested_is_current?
      @current_user.memories.by_last_created
    else
      @requested_user.memories.publicly_visible.by_last_created
    end
  end

  def scrapbooks
    @scrapbooks ||= if requested_is_current?
      @current_user.scrapbooks
    else
      @requested_user.scrapbooks.publicly_visible
    end
  end

  def requested_is_current?
    @requested_user == @current_user
  end
end
