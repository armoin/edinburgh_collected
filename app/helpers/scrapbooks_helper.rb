require "addressable/template"

module ScrapbooksHelper
  def path_to_scrapbook(scrapbook_path, scrapbook_id)
    return unless scrapbook_path
    return scrapbook_path unless scrapbook_id

    uri = Addressable::URI.parse(scrapbook_path)
    uri.path += "/#{scrapbook_id}"
    uri.to_s
  end
end
