Fabricator(:user) do
  first_name            { Faker::Name.first_name }
  last_name             { Faker::Name.last_name }
  screen_name           { sequence(:screen_name) {|i| [Faker::Name.first_name, i.to_s].join('_')} }
  email                 { Faker::Internet.email }
  password              { generate_password }
  password_confirmation { |attrs| attrs[:password] }
  accepted_t_and_c      true
  description           "I am a fabricated user."
end

Fabricator(:active_user, from: :user) do
  after_create { |u, transients| u.activate! }
end

Fabricator(:admin_user, from: :active_user) do
  is_admin true
end

Fabricator(:pending_user, from: :user) do
  activation_state            'pending'
  activation_token            '123abc'
  activation_token_expires_at 1.hour.from_now
end

def generate_password
  @pass ||= SecureRandom.uuid.first(8)
end

