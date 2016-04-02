module AdminHelper
  DEFAULT_DATE_FORMAT = '%d-%b-%Y'

  def date_sortable_cell(date, format=nil)
    content_tag :td, sorttable_customkey: date.try(:to_formatted_s, :number) do
      formatted_date(date, format)
    end
  end

  def formatted_date(date, format=nil)
    format ||= DEFAULT_DATE_FORMAT
    date.try(:strftime, format)
  end

  def class_for_tab(current_tab, active_tab)
    current_tab == active_tab ? 'active' : nil
  end
end
