Fabricator(:user) do
  first_name            { Faker::Name.first_name }
  last_name             { Faker::Name.last_name }
  screen_name           { sequence(:screen_name) {|i| [Faker::Name.first_name, i.to_s].join('_')} }
  email                 { Faker::Internet.email }
  password              { generate_password }
  password_confirmation { |attrs| attrs[:password] }
  accepted_t_and_c      true
  description           "I am a fabricated user."
  is_blocked            false
  moderation_state      'approved'
end

Fabricator(:active_user, from: :user) do
  activation_state            'active'
  activation_token            nil
  activation_token_expires_at nil

  after_create { |u, transients| u.activate! }
end

Fabricator(:unmoderated_user, from: :active_user) do
  moderation_state ModerationStateMachine::DEFAULT_STATE
end

Fabricator(:reported_user, from: :active_user) do
  moderation_state  'reported'
  moderated_by      { Fabricate(:admin_user) }
  last_moderated_at { Time.now }
  moderation_reason { "Don't like it." }
end

Fabricator(:approved_user, from: :active_user) do
  after_create { |u, transients| u.approve!(u) }
end

Fabricator(:admin_user, from: :active_user) do
  is_admin true
end

Fabricator(:pending_user, from: :user) do
  activation_state            'pending'
  activation_token            '123abc'
  activation_token_expires_at 1.hour.from_now
end

Fabricator(:blocked_user, from: :user) do
  is_blocked true
end

def generate_password
  @pass ||= SecureRandom.uuid.first(8)
end

