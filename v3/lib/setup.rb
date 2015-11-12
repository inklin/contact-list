puts "Connecting to the database!"

ActiveRecord::Base.establish_connection(
  database: 'contacts',
  adapter: 'postgresql',
  host: 'localhost',
  username: 'development',
  password: 'development'
)

puts "Connected!"