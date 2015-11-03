require_relative 'contact'
require_relative 'contact_database'

# TODO: Implement command line interaction
# This should be the only file where you use puts and gets
@command, @parameter = ARGV
contacts = []

def start
  case @command
  when "help" then menu
  when "new"  then create_new_contact
  end
end

def create_new_contact
  name = prompt_name
  email = prompt_email
  new_contact = Contact.create(name, email)
  contacts << new_contact
  add_contact_to_csv(new_contact.to_s)
end

def prompt_name
  print "Enter new contact's name: "
  $stdin.gets.chomp
end

def prompt_email
  print "Enter new contact's e-mail: "
  $stdin.gets.chomp
end

def menu
  puts "Here is a list of available commands:"
  puts "\tnew - Create a new contact"
  puts "\tlist - List all contacts"
  puts "\tshow - Show a contact"
  puts "\tfind - Find a contact"
end

start