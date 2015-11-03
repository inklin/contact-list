class Contact
  @@list = []
  @@next_id = 1
  attr_accessor :name, :email, :id

  def initialize(name, email, id, numbers)
    @name = name
    @email = email
    @id = id
    @numbers = numbers
  end
 
  def to_s
    # TODO: return string representation of Contact
    numbers_string = @numbers.to_a.flatten.join(',')
    "#{@id},#{@name},#{@email},\"#{numbers_string}\"\n"
  end
 
  ## Class Methods
  class << self

    def create(name, email, numbers)
      contact = Contact.new(name, email, @@next_id, numbers)
      Contact.add(contact)
      contact
    end
 
    def find(term)
      # TODO: Will find and return contacts that contain the term in the first name, last name or email
      matching_contacts = @@list.select do |contact| 
        contact.name.downcase.include?(term) || contact.email.downcase.include?(term)
      end
      matching_contacts
    end
 
    def all
      # TODO: Return the list of contacts, as is
      @@list
    end
    
    def show(id)
      # TODO: Show a contact, based on ID
      @@list.each do |contact|
       return contact if contact.id == id
      end
    end

    def add(contact)
      @@list << contact
      @@next_id += 1
    end

    # checks if email is already in the list
    # I/O: takes a string as a parameter and returns true/false
    def used?(email)
      @@list.any? { |contact| contact.email.downcase == email}
    end
    
  end
 
end