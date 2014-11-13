module StateHelper
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
    label = memory.current_state
    label += " - #{memory.current_state_reason}" if memory.current_state_reason
    label
  end
end

