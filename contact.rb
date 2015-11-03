class Contact
  attr_accessor :name, :email
  @@contacts = []

  def initialize(name, email)
    # TODO: assign local variables to instance variables
    @name = name
    @email = email
    @@contacts << self
  end
 
  def to_s
    # TODO: return string representation of Contact
    "#{contact.size}, #{@name}, #{@email}\n"
  end
 
  ## Class Methods
  class << self

    def create(name, email)
      new_contact = Contact.new(name, email)
      contacts << new_contact
    end
 
    def find(term)
      # TODO: Will find and return contacts that contain the term in the first name, last name or email
    end
 
    def all
      # TODO: Return the list of contacts, as is
    end
    
    def show(id)
      # TODO: Show a contact, based on ID
    end

    def contact_count
      @@contacts.inspect
    end
    
  end
 
end