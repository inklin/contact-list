require 'pg'
require 'active_record'

require_relative 'lib/setup'
require_relative 'lib/contact'
require_relative 'lib/phone'
require_relative 'lib/contactlist'

ContactList.new.start