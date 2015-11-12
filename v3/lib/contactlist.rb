class ContactList
  class EmailError < StandardError
  end

  def initialize
    @command, @parameter = ARGV
  end

  def start
    case @command
    when "help" then menu
    when "new"  then create_new_contact
    when "list" then list_contacts(Contact.all)
    when "show" then show_contact(@parameter)
    when "find" then find_contacts(@parameter)
    else menu
    end
  end

  private
  def menu
    puts "Here is a list of available commands:"
    puts "\tnew - Create a new contact"
    puts "\tlist - List all contacts"
    puts "\tshow - Show a contact by ID"
    puts "\tfind - Find a contact by a search term"
  end

  def create_new_contact
    email = get_email
    firstname = prompt_name
    lastname = prompt_surname    
    contact = Contact.create(firstname: firstname, lastname: lastname, email: email)
    get_numbers(contact)
    save_contact(contact)
  end

  def save_contact(contact)
    if contact.save
      puts "Contact successfully added!"
    else
      puts "Contact not saved. :( "
      contact.errors.full_message.each do |attribute, message|
        puts "#{attribute}: #{message}"
      end
    end
  end

  def get_email
    email = ""
    begin
      print "Enter new contact's e-mail: "
      email = $stdin.gets.chomp
      raise EmailError if Contact.exists?(email: email)
      email
    rescue EmailError
      puts "That email already exists in the system."
      get_new_email
    end
  end

  def prompt_name
    name = ""
    loop do
      print "Enter new contact's first name: "
      name = $stdin.gets.chomp
      break if name.length > 0
    end
    name
  end

  def prompt_surname
    print "Enter new contact's last name: "
    $stdin.gets.chomp
  end

  def get_numbers(contact)
    loop do
      print "Enter a label for your phone number: "
      label = $stdin.gets.chomp
      print "Enter the phone number: "
      number = $stdin.gets.chomp
      contact.phones.create(digits: number, context: label)
      break if done_numbers?
    end
  end

  def done_numbers?
    puts "Do you have another number to enter? y/n"
    $stdin.gets.chomp == "n" || $stdin.gets.chomp == "no"
  end

  def list_contacts(contacts)
    contacts.each do |contact|
      puts "#{contact.to_s} #{print_phones(contact)}"
    end
    puts "---"
    puts "#{contacts.size} records total"
  end

  def print_phones(contact)
    contact.phones.map { |phone| phone.to_s }.join(', ') unless contact.phones.empty?
  end

  def show_contact(id)
    begin
      contact = Contact.find(id.to_i)
      puts contact.to_s
    rescue ActiveRecord::RecordNotFound
      puts "No contact with id #{id} was found."
    end
  end

  def find_contacts(term)
    matches = Contact.where("firstname LIKE :search_term OR lastname LIKE :search_term OR email LIKE :search_term", {search_term: "%#{term}%"})
    puts "Here are the contacts that match '#{term}':"
    list_contacts(matches)
  end
end