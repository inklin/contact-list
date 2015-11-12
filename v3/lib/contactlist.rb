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
    email = get_new_email
    firstname = prompt_name
    lastname = prompt_surname    
    contact = Contact.create!(firstname: firstname, lastname: lastname, email: email)
    get_numbers(contact)
  end

  def get_new_email
    email = ""
    begin
      email = prompt_email
      raise EmailError if Contact.exists?(email: email)
      email
    rescue EmailError
      puts "That email already exists in the system."
      get_new_email
    end
  end

  def prompt_name
    print "Enter new contact's first name: "
    $stdin.gets.chomp
  end

  def prompt_surname
    print "Enter new contact's last name: "
    $stdin.gets.chomp
  end

  def prompt_email
    print "Enter new contact's e-mail: "
    $stdin.gets.chomp
  end

  def get_numbers(contact)
    loop do
      label = prompt_label
      number = prompt_number
      contact.phones.create(digits: number, context: label)
      break if done_numbers?
    end
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
      puts "#{contact.to_s} #{print_phones(contact)}"
    end
    puts "---"
    puts "#{contacts.size} records total"
  end

  def print_phones(contact)
    contact.phones.map { |phone| phone.to_s }.join(', ')
  end

  def show_contact(id)
    begin
      contact = Contact.find(id.to_i)
      puts contact.to_i
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