Fabricator(:link) do
  name { sequence(:name) {|i| [Faker::Product.product_name, i.to_s].join('_')  } }
  url  { sequence(:url)  {|i| File.join(Faker::Internet.http_url, i.to_s) } }
end
