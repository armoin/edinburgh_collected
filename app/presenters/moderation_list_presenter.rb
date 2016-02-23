class ModerationListPresenter
  attr_reader :items

  def initialize(items, item_name, action_name)
    @items = items
    @item_name = item_name
    @action_name = action_name
  end

  def title
    @item_name.capitalize
  end

  def show_memories?
    @item_name == 'scrapbooks'
  end

  def moderated_col_name
    @action_name == 'reported' ? 'Reported' : 'Moderated'
  end

  def moderated_by_col_name
    @action_name == 'reported' ? 'Reported by' : 'Moderated by'
  end

  def unmoderated_path
    "admin_moderation_#{@item_name}_path"
  end

  def moderated_path
    "moderated_admin_moderation_#{@item_name}_path"
  end

  def reported_path
    "reported_admin_moderation_#{@item_name}_path"
  end

  def show_path
    "admin_moderation_#{@item_name.singularize}_path"
  end

  def unmoderated_page?
    @action_name == 'index'
  end

  def moderated_page?
    @action_name == 'moderated'
  end

  def reported_page?
    @action_name == 'reported'
  end
end
