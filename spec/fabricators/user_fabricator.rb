Fabricator(:user) do
  first_name            Faker::Name.first_name
  last_name             Faker::Name.last_name
  email                 Faker::Internet.email
  password              's3cr3t'
  password_confirmation 's3cr3t'
end

Fabricator(:active_user, from: User) do
  first_name            Faker::Name.first_name
  last_name             Faker::Name.last_name
  email                 Faker::Internet.email
  password              's3cr3t'
  password_confirmation 's3cr3t'
  after_create { |u, transients| u.activate! }
end

Fabricator(:pending_user, from: User) do
  first_name            'Bobby'
  last_name             'Tables'
  email                 'bobby@example.com'
  password              'password'
  password_confirmation 'password'
  activation_state      'pending'
  activation_token      '123abc'
  activation_token_expires_at 1.hour.from_now
end

