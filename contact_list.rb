require_relative 'contact'
require_relative 'contact_database'

# TODO: Implement command line interaction
# This should be the only file where you use puts and gets
@command, @parameter = ARGV

def start
  case @command
  when "help" then menu
  when "new"  then add_new_contact
  when "list" then list_contacts
  when "show" then 
    id = @parameter.to_i
    puts Contact.show(id)
  end
end

# I/O: Takes no parameters, Returns new contact id (int)
# Calls prompt_name and prompt_email,
# calls create method on Contact class with parameters name, email
def add_new_contact
  name = prompt_name
  email = prompt_email
  contact = Contact.create(name, email)
  add_contact_to_csv(contact.to_s)
  contact.id
end

# I/O: No parameters, returns string
def prompt_name
  print "Enter new contact's name: "
  $stdin.gets.chomp
end

# I/O: No parameters, returns string
def prompt_email
  print "Enter new contact's e-mail: "
  $stdin.gets.chomp
end

def list_contacts
  Contact.all.each do |contact|
    puts "#{contact.id}: #{contact.name} (#{contact.email})"
  end
  puts "---"
  puts "#{Contact.list_count} records total"
end

# I/O: No parametrs, no return value
# Method prints a menu to the console
def menu
  puts "Here is a list of available commands:"
  puts "\tnew - Create a new contact"
  puts "\tlist - List all contacts"
  puts "\tshow - Show a contact"
  puts "\tfind - Find a contact"
end

load_csv
start