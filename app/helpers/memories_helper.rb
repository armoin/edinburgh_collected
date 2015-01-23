module MemoriesHelper
  # returns the list of month names with a blank at the start
  # for use in dropdowns
  def month_names
    Date::MONTHNAMES.map.with_index { |m,i| m.blank? ? ['',''] : [m,i] }
  end

  def scrapbook_modal_data(logged_in, memory)
    if logged_in
      {toggle: "modal", target: "#add-to-scrapbook-modal", memory_id: memory.id, memory_title: memory.title}
    else
      {toggle: "popover", trigger: "click", title: "Please sign in ...", content: "Sorry you can't do this unless you're signed in."}
    end
  end
end

