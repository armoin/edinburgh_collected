module AdminHelper
  def show_moderation_panel?
    current_index_path.match /\/moderation\//
  end
end

