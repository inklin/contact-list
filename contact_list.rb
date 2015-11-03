require_relative 'contact'
require_relative 'contact_database'

# TODO: Implement command line interaction
# This should be the only file where you use puts and gets
@command, @parameter = ARGV

def start
  case @command
  when "help" then menu
  when "new"  then create_new_contact
  when "list" then list_contacts(Contact.all)
  when "show" then show_contact(@parameter)
  when "find" then find_contacts(@parameter)
  end
end

# I/O: Takes no parameters, Returns new contact id (int)
# Calls prompt_name and prompt_email,
# calls create method on Contact class with parameters name, email
def create_new_contact
  name = prompt_name
  email = prompt_email
  contact = Contact.create(name, email)
  ContactDatabase.add(contact.to_s)
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

def list_contacts(contacts)
  contacts.each do |contact|
    puts "#{contact.id}: #{contact.name} (#{contact.email})"
  end
  puts "---"
  puts "#{contacts.size} records total"
end

def show_contact(id)
  contact = Contact.show(id)
  puts "Name: #{contact.name}"
  puts "Email: #{contact.email}"
end

def find_contacts(term)
  search_term = term.downcase
  matches = Contact.find(search_term)
  list_contacts(matches)
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

ContactDatabase.load
start