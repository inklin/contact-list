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
        numbers_array = contact[3].scan(/[A-Za-z]+,[\d]+-[\d]+/)
        number_hash = Hash.new()

        numbers_array.each do |info|
          info_array = info.split(',')
          label = info_array[0]
          number = info_array[1]
          number_hash[label] = number
        end

        new_contact = Contact.new(name, email, id, number_hash)
        Contact.add(new_contact)
      end
    end
  end
end