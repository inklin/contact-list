class Contact
  attr_accessor:firstname, :lastname, :email
  attr_reader :id

  def initialize(firstname, lastname, email, id=nil)
    @firstname = firstname
    @lastname = lastname
    @email = email
    @id = id
  end
 
  def to_s
    "#{@id},#{@firstname} #{@lastname},#{@email}"
  end

  # Contact #destroy
  def destroy
    Contact.connection.exec_params('DELETE FROM contacts WHERE id = $1, [id];', [id])
  end

  def save
    if id
      Contact.connection.exec_params('UPDATE contacts SET firstname = $1, lastname = $2, email = $3 WHERE id = $3;', [firstname, lastname, email, id])
    else
      result = Contact.connection.exec_params('INSERT INTO contacts (firstname, lastname, email) VALUES ($1, $2, $3) RETURNING id;', [firstname, lastname, email])
      @id = result[0]['id']
    end
  end

  # Class methods
  # Connection Class method
  def self.connection
    @@connection ||= PG::Connection.open(dbname: 'contacts')
  end

  # Find a Contact by ID 
  # SELECT contact from DB through ID
  def self.find(id)
    result = connection.exec_params('SELECT * FROM contacts WHERE id = $1;', [id])
    Contact.new(result[0]['firstname'], result[0]['lastname'], result[0]['email'], result[0]['id'])
  end

  # Find all Contacts by last name
  # Returns array of all contacts with provided last name
  def self.find_all_by_lastname(name)
    contacts = []
    result = connection.exec_params('SELECT * FROM contacts WHERE lastname = $1;', [name])
    result.each do |row|
      contacts << Contact.new(row['firstname'], row['lastname'], row['email'], row['id'])
    end
    contacts
  end

  # Find all Contacts by first name
  # Returns array of all contacts with provided first name
  def self.find_all_by_firstname(name)
    contacts = []
    result = connection.exec_params('SELECT * FROM contacts WHERE firstname = $1;', [name])
    result.each do |tuple|
      contacts << Contact.new(tuple['firstname'], tuple['lastname'], tuple['email'], tuple['id'])
    end
    contacts
  end

  # Find Contact by email
  # Returns single Contact instance or nil
  def self.find_by_email(email)
    result = connection.exec_params('SELECT * FROM contacts WHERE email = $1;', [email])
    Contact.new(result[0]['firstname'], result[0]['lastname'], result[0]['email'], result[0]['id'])
  end

end