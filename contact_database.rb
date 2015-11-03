## TODO: Implement CSV reading/writing
require 'csv'

# read the CSV file
def read(csv_name)
  CSV.foreach(csv_name) do |row|
    puts row.inspect
  end
end

# I/O: takes a string object, adds it to the contacs.csv
def add_contact_to_csv(contact)
  csv_file = File.open('contacts.csv', "a")
  csv_file.write(contact)
  csv_file.close
end