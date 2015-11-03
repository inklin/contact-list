## TODO: Implement CSV reading/writing
require 'csv'

# I/O: takes a string object, adds it to the contacs.csv
def add_contact_to_csv(contact)
  csv_file = File.open('contacts.csv', "a")
  csv_file.write(contact)
  csv_file.close
end

def read
  CSV.foreach('contacts.csv') do |row|
    puts "#{row[0]}: #{row[1]} (#{row[2].strip})"
  end
  puts "---"
  puts "#{CSV.read('contacts.csv').size} records total"
end