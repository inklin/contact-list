## TODO: Implement CSV reading/writing
require 'csv'

class ContactDatabase
  class << self
    # I/O: takes a string object, adds it to the contacs.csv
    def add(contact)
      csv_file = File.open('contacts.csv', "a")
      csv_file.write(contact)
      csv_file.close
    end

    def csv_size
      open_csv.readlines.size
    end


    def open_csv
      CSV.open('contacts.csv', 'r')
    end

    def load
      CSV.read('contacts.csv').each do |contact|
        id = contact[0]
        name = contact[1]
        email = contact[2]
        new_contact = Contact.new(name, email, id)
        Contact.add(new_contact)
      end
    end
  end
end