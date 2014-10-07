json.type 'Feature'
json.geometry do
  json.type 'Point'
  json.coordinates [memory.longitude, memory.latitude]
end
json.properties do
  json.id          memory.id
  json.type        memory.type
  json.file        memory.source
  json.title       memory.title
  json.description memory.description
  json.year        memory.year
  json.month       memory.month
  json.day         memory.day
  json.attribution memory.attribution
  json.created_at  memory.created_at
  json.updated_at  memory.updated_at

  json.categories do
    json.array! memory.categories, :id, :name
  end

  json.tags memory.taggings do |tagging|
    json.id   tagging.tag.id
    json.name tagging.tag.name
  end

  if memory.user
    json.user do
      json.screen_name memory.user.screen_name
      json.is_group    memory.user.is_group
    end
  else
    json.user nil
  end

  if memory.area
    json.area do
      json.id        memory.area.id
      json.name      memory.area.name
    end
  else
    json.area nil
  end
  json.location  memory.location
end
