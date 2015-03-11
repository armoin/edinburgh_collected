module AdminHelper
  def show_moderation_panel?
    current_memory_index_path.match /admin\/moderation/
  end
end

