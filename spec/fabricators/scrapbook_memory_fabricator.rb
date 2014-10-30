Fabricator(:scrapbook_memory) do
  scrapbook
  memory    { Fabricate(:photo_memory) }
end
