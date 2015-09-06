class FakeMemory
  attr_reader :id, :title, :user, :year

  def initialize(attrs)
    @id        = attrs[:id]
    @image_url = attrs[:image_url]
    @title     = attrs[:title]
    @user      = OpenStruct.new(attrs[:user]) if attrs.key?(:user)
    @year      = attrs[:year]
  end

  def source_url(version)
    return unless @image_url
    "#{BASE_CDN_URL}//uploads/memory/source/#{@id}/#{version}_#{@image_url}"
  end
end

class HomePagePresenter
  attr_reader :hero_image_path, :featured_memory, :featured_scrapbook, :featured_scrapbook_memories

  def initialize(homepage_data)
    @hero_image_path = homepage_data.hero_image
    @featured_memory = featured_memory_for(homepage_data.featured_memory_data)
    @featured_scrapbook = featured_scrapbook_for(homepage_data.featured_scrapbook_data)
    @featured_scrapbook_memories = featured_scrapbook_memories_for(homepage_data.featured_scrapbook_data)
  end

  def memory_url(memory_id)
    [host, :memories, memory_id].join('/')
  end

  def scrapbook_url
    [host, :scrapbooks, @featured_scrapbook.id].join('/')
  end

  def user_memories_url
    [host, :users, @featured_memory.user.id, :memories].join('/')
  end

  def user_scrapbooks_url
    [host, :users, @featured_scrapbook.user.id, :scrapbooks].join('/')
  end

  private

  def featured_memory_for(data)
    if production?
      Memory.find(data[:id])
    else
      FakeMemory.new(data)
    end
  end

  def featured_scrapbook_for(data)
    if production?
      scrapbook(data[:id])
    else
      OpenStruct.new(
        id: data[:id],
        title: data[:title],
        user: OpenStruct.new(data[:user])
      )
    end
  end

  def featured_scrapbook_memories_for(data)
    if production?
      scrapbook(data[:id]).memories.where(id: data[:memory_ids])#.uniq
    else
      data[:memories].map do |memory|
        FakeMemory.new(memory)
      end
    end
  end

  def scrapbook(id)
    @scrapbook ||= Scrapbook.find(id)
  end

  def production?
    ENV['HOST'] == production_host
  end

  def production_host
    'https://edinburghcollected.org'
  end

  def host
    production? ? nil : production_host
  end
end
