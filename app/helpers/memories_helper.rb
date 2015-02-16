module MemoriesHelper
  # returns the list of month names with a blank at the start
  # for use in dropdowns
  def month_names
    Date::MONTHNAMES.map.with_index { |m,i| m.blank? ? ['',''] : [m,i] }
  end

  def sub_text(memory)
    [memory.address, memory.date_string].reject{|s| s.blank?}.join(', ')
  end

  def scrapbook_modal_data(logged_in, memory)
    if logged_in
      {toggle: "modal", target: "#add-to-scrapbook-modal", memory_id: memory.id, memory_title: memory.title}
    else
      signed_in_link = link_to('sign in', new_session_path, class: 'signin button green')
      {toggle: "popover", trigger: "click", title: "Please sign in ...", content: "Sorry you must #{signed_in_link} before you can do this."}
    end
  end
end

