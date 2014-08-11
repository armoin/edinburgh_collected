class MemoriesController < ApplicationController
  def index
    @memories = Memory.all
  end

  def show
    @memory = Memory.find(params[:id])
  rescue Exception => e
    render 'memories/not_found'
  end
end
