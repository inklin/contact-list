require_relative 'contact'
require_relative 'contact_database'

class ContactList
  class EmailError < StandardError
  end

  class NoContactFound < StandardError
  end

  def initialize
    @command, @parameter = ARGV
  end

  def start
    case @command
    when "help" then menu
    when "new"  then create_new_contact
    when "list" then list_contacts(ContactDatabase.list)
    when "show" then show_contact(@parameter)
    when "find" then find_contacts(@parameter)
    end
  end

  def create_new_contact
    email = get_new_email
    name = prompt_name
    numbers = get_numbers
    ContactDatabase.create_contact(name, email, numbers)
  end

  def get_new_email
    email = ""
    begin
      email = prompt_email
      raise EmailError if ContactDatabase.email_used?(email)
      email
    rescue EmailError
      puts "That email already exists in the system."
      get_new_email
    end
  end

  def prompt_name
    print "Enter new contact's name: "
    $stdin.gets.chomp
  end

  def prompt_email
    print "Enter new contact's e-mail: "
    $stdin.gets.chomp
  end

  def get_numbers
    numbers = {}
    loop do
      label = prompt_label
      number = prompt_number
      numbers[label] = number
      break if done_numbers?
    end
    numbers
  end

  def done_numbers?
    puts "Do you have another number to enter? y/n"
    $stdin.gets.chomp == "n"
  end

  def prompt_label
    print "Enter a label for the phone number: "
    $stdin.gets.chomp
  end

  def prompt_number
    print "Enter the phone number: "
    $stdin.gets.chomp
  end

  def list_contacts(contacts)
    contacts.each do |contact|
      puts "#{contact.id}: #{contact.name} (#{contact.email}) #{contact.numbers}"
    end
    puts "---"
    puts "#{contacts.size} records total"
  end

  def show_contact(id)
    begin
      contact = ContactDatabase.show(id.to_i)
      raise NoContactFound if contact.nil?
      puts "Name: #{contact.name}, Email: #{contact.email}"
    rescue NoContactFound
      puts "No contact with id #{id} was found."
    end
  end

  def find_contacts(term)
    search_term = term.downcase
    matches = ContactDatabase.find(search_term)
    list_contacts(matches)
  end

  def menu
    puts "Here is a list of available commands:"
    puts "\tnew - Create a new contact"
    puts "\tlist - List all contacts"
    puts "\tshow - Show a contact"
    puts "\tfind - Find a contact"
  end
end

ContactDatabase.load
ContactList.new.start