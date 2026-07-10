# db/seeds.rb

puts "[SEED] Initializing database seeding sequence..."

# 🔐 Reads credentials from system environment variables with a safe fallback
admin_password = ENV.fetch("ADMIN_SEED_PASSWORD") { "my_password_for_rails" }
admin_email    = ENV.fetch("ADMIN_SEED_EMAIL")    { "ivaylo.bumbovski@gmail.com" }

admin_user = User.find_or_create_by!(username: "admin") do |user|
  user.email_address = admin_email
  user.date_of_birth = "1984-07-19"
  user.password = admin_password
  user.password_confirmation = admin_password
  user.admin = true
end

if admin_user.persisted?
  puts "[SEED] Default system administrator profile confirmed: username 'admin'"
else
  puts "[SEED] Critical failure during root admin seeding operation."
end