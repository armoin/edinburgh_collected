json.type 'FeatureCollection'
json.features @memories.select{|m| m.latitude.present?}, partial:'memories/memory', as: :memory
