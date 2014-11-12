module MemoriesHelper
  # returns the list of month names with a blank at the start
  # for use in dropdowns
  def month_names
    Date::MONTHNAMES.map.with_index { |m,i| m.blank? ? ['',''] : [m,i] }
  end

  def sub_text(memory)
    [memory.address, memory.date].reject{|s| s.blank?}.join(', ')
  end

  def button_class(memory, button_state)
    if button_text == state_label(memory)
      "#{memory.current_state} btn btn-#{button_text.gsub(' ','')}"
    else
      "#{memory.current_state} btn btn-disabled"
    end
  end

  def state_label(memory)
    label = memory.current_state
    label += " - #{memory.current_state_reason}" if memory.current_state_reason
    label
  end
end
