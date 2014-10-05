if @memory.latitude.present? && @memory.longitude.present?
  json.partial! 'memories/memory', memory: @memory
else
  json.error "Has no coordinates"
end
