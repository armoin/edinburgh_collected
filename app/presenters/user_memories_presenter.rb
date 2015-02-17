class UserMemoriesPresenter
  attr_reader :requested_user

  def initialize(requested_user, current_user, page)
    @requested_user = requested_user
    @current_user = current_user
    @page = page
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

  private

  def memories
    @memories ||= if @requested_user == @current_user
      @current_user.memories.by_recent
    else
      @requested_user.memories.approved.by_recent
    end
  end

  def scrapbooks
    @scrapbooks ||= if @requested_user == @current_user
      @current_user.scrapbooks
    else
      @requested_user.scrapbooks.approved
    end
  end
end
