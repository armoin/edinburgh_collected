namespace :temp_users do
  task :generate => :environment do |t, args|
    details = Array.new(ENV['NUMBER'].to_i) do |n|
      password = random(8)
      user = Fabricate.create(:active_user,
        email: "temp_user_#{random(4)}@example.com",
        password: password,
        password_confirmation: password
      )
      "email: #{user.email}, password: #{password}"
    end
    p users: details
  end

  task :remove => :environment do |t, args|
    User.where("email LIKE 'temp_user%'").destroy_all
  end
end

def random(num)
  SecureRandom.uuid.first(num)
end
