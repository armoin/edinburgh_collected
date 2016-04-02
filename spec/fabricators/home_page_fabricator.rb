Fabricator(:home_page) do
  featured_memory               { Fabricate(:approved_photo_memory) }
  featured_scrapbook            { featured_scrapbook }
  featured_scrapbook_memory_ids { featured_scrapbook.scrapbook_memories.map(&:id).join(',') }
end

Fabricator(:unpublished_home_page, from: :home_page) do
  published false
end

Fabricator(:published_home_page, from: :home_page) do
  published true
end

def featured_scrapbook
  scrapbook = Fabricate(:approved_scrapbook)
  Fabricate.times(4, :scrapbook_photo_memory, scrapbook: scrapbook)
  scrapbook
end
