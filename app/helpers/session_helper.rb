module SessionHelper
  DEFAULT_PATH = Rails.application.routes.url_helpers.memories_path

  def store_memory_index_path
    session[:current_memory_index_path] = request.original_fullpath
  end

  def current_memory_index_path
    return DEFAULT_PATH unless session[:current_memory_index_path].present?
    session[:current_memory_index_path]
  end
end

