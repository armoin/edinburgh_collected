json.id          @scrapbook.id
json.title       @scrapbook.title
json.description @scrapbook.description
json.created_at  @scrapbook.created_at
json.updated_at  @scrapbook.updated_at

if @scrapbook.user
  json.user do
    json.screen_name @scrapbook.user.screen_name
    json.is_group    @scrapbook.user.is_group
  end
else
  json.user nil
end

json.memories @scrapbook.scrapbook_memories.order(:ordering).each do |sbm|
  json.id         sbm.id
  json.memory_id  sbm.memory_id
  json.memory_url memory_url(sbm.memory_id, format: :json)
  json.thumbnail  sbm.memory.source_url(:thumb)
end
