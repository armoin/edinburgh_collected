module AdminHelper
  DEFAULT_DATE_FORMAT = '%d-%b-%Y'

  def date_sortable_cell(date, format=nil)
    format ||= DEFAULT_DATE_FORMAT
    content_tag :td, sorttable_customkey: date.try(:to_formatted_s, :number) do
      date.try(:strftime, format)
    end
  end
end
