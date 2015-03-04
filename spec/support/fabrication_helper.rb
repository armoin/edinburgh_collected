def build_array(size, model_name, opts={})
  Array.new(size) { |i| Fabricate.build( model_name, opts.merge(id: i+1) ) }
end