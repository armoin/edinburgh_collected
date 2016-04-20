Fabricator(:link) do
  name { sequence(:name) {|i| [FFaker::Product.product_name, i.to_s].join('_')  } }
  url  { sequence(:url)  {|i| File.join(FFaker::Internet.http_url, i.to_s) } }
end
