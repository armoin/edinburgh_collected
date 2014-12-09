module SessionHelper
  DEFAULT_MEMORY_PATH = '/memories'

  def store_memory_index_path
    session[:current_memory_index_path] = request.original_fullpath
  end

  def current_memory_index_path
    return DEFAULT_MEMORY_PATH unless session[:current_memory_index_path].present?
    session[:current_memory_index_path]
  end
end

