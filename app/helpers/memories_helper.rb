module MemoriesHelper
  # returns the list of month names with a blank at the start
  # for use in dropdowns
  def month_names
    Date::MONTHNAMES.map.with_index { |m,i| m.blank? ? ['',''] : [m,i] }
  end

  def sub_text(memory)
    [memory.address, memory.date_string].reject{|s| s.blank?}.join(', ')
  end
end

