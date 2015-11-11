require 'csv'

class ContactDatabase
  @list = []

  class << self
    def load
      CSV.read('contacts.csv').each do |contact|
        id = contact[0].to_i
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
        add(new_contact)
      end
    end

    def write_to_csv(contact)
      csv = File.open('contacts.csv', 'a')
      csv.write(contact.to_s)
      csv.close
    end

    def list
      @list
    end

    def email_used?(email)
      list.any? { |contact| contact.email.downcase == email}
    end
 
    def find(term)
      matching_contacts = list.select do |contact| 
        contact.name.downcase.include?(term) || contact.email.downcase.include?(term)
      end
      matching_contacts
    end
    
    def show(id)
      list.each do |contact|
       return contact if contact.id == id
      end
      nil
    end

    def create_contact(name, email, numbers)
      new_contact = Contact.new(name, email, unique_id, numbers)
      add(new_contact)
      write_to_csv(new_contact)
    end

    private
    def unique_id
      max_id = 0
      list.each do |contact|
        max_id = contact.id if contact.id > max_id
      end
      max_id + 1
    end

    def add(contact)
      @list << contact
    end

  end
end