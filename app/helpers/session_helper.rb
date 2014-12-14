module SessionHelper
  DEFAULT_MEMORY_PATH = '/memories'
  DEFAULT_SCRAPBOOK_PATH = '/scrapbooks'

  def store_memory_index_path
    store_current_path_in(:current_memory_index_path)
  end

  def store_scrapbook_index_path
    store_current_path_in(:current_scrapbook_index_path)
  end

  def current_memory_index_path
    path_or_default(:current_memory_index_path, DEFAULT_MEMORY_PATH)
  end

  def current_scrapbook_index_path
    path_or_default(:current_scrapbook_index_path, DEFAULT_SCRAPBOOK_PATH)
  end

  private

  def store_current_path_in(path)
    session[path] = request.original_fullpath
  end

  def path_or_default(path, default_path)
    return default_path unless session[path].present?
    session[path]
  end
end

