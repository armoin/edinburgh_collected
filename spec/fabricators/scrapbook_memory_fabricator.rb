Fabricator(:scrapbook_photo_memory, class_name: :scrapbook_memory, aliases: [:scrapbook_memory]) do
  scrapbook
  memory    { Fabricate(:photo_memory) }
end

Fabricator(:scrapbook_written_memory, class_name: :scrapbook_memory) do
  scrapbook
  memory    { Fabricate(:written_memory) }
end
