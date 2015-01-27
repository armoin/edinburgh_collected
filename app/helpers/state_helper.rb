module StateHelper
  VIEWABLE_STATE_PATHS = [
    'my/memories',
    'my/scrapbooks',
  ]

  def button_for_state(action, state, memory, reason=nil)
    link_name = action
    if reason
      state += " - #{reason}"
      link_name += " - #{reason}"
    end

    unless state_label(memory) == state
      url = send("#{action}_admin_moderation_memory_path", memory, reason: reason)
      content_tag(:li, link_to(link_name.capitalize, url, class: "btn #{action}", method: :put))
    end
  end

  def state_label(memory)
    label = memory.moderation_state
    label += " - #{memory.moderation_reason}" unless memory.moderation_reason.blank?
    label
  end

  def show_state?
    VIEWABLE_STATE_PATHS.include? controller_path
  end
end

