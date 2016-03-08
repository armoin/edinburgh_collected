Fabricator(:home_page) do
  featured_memory               { featured_memory }
  featured_scrapbook            { featured_scrapbook }
  featured_scrapbook_memory_ids { featured_scrapbook.memories.map(&:id).join(',') }
end

Fabricator(:unpublished_home_page, from: :home_page) do
  published false
end

Fabricator(:published_home_page, from: :home_page) do
  published true
end

def featured_memory
  Fabricate(:approved_memory)
end

def featured_scrapbook
  scrapbook = Fabricate(:approved_scrapbook)
  memories = Fabricate.times(4, :approved_memory)
  scrapbook.memories << memories
  scrapbook
end
