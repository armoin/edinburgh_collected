if @memory.has_coords?
  json.partial! 'memories/memory', memory: @memory
else
  json.error "Has no coordinates"
end
