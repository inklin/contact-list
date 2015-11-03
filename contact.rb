class Contact
  @@list = []
  @@next_id = 1
  attr_accessor :name, :email, :id

  def initialize(name, email, id)
    @name = name
    @email = email
    @id = id
  end
 
  def to_s
    # TODO: return string representation of Contact
    "#{@id},#{@name},#{@email}\n"
  end
 
  ## Class Methods
  class << self

    def create(name, email)
      contact = Contact.new(name, email, @@next_id)
      Contact.add(contact)
      contact
    end
 
    def find(term)
      # TODO: Will find and return contacts that contain the term in the first name, last name or email
    end
 
    def all
      # TODO: Return the list of contacts, as is
      @@list
    end
    
    def show(id)
      # TODO: Show a contact, based on ID
      @@list.select { |contact| contact.id == id}
    end

    def list_count
      @@list.count
    end

    def add(contact)
      @@list << contact
      @@next_id += 1
    end
    
  end
 
end