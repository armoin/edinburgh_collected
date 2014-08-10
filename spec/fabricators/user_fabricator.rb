Fabricator(:user) do
  first_name            Faker::Name.first_name
  last_name             Faker::Name.last_name
  email                 Faker::Internet.email
  password              's3cr3t'
  password_confirmation 's3cr3t'
end
