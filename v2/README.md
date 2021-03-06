# Introduction
IMPORTANT NOTE: Read and understand this entire assignment prior to starting.

It would definitely be nice to store the contacts for our recently created app onto the disk, instead of just in an array in the program's runtime memory. This way, the contacts won't disappear when you quit the program.

In order to do this, we will build an mini-ORM of our own, before we start to use Active Record, the ORM of choice for Ruby/Rails developers.

You may already be storing the contacts in your app by writing them to a CSV file on disk (don't worry if you didn't implement this), which is a bit of work to implement and yet not very flexible. Let's instead use an RDBMS (Relational Database Management System) like PostgreSQL to store and retrieve our contact records as rows within a table (not unlike how books were stored in the bookstore database.)

# What's an ORM?
Working directly with SQL from Ruby everytime you want to talk to a database is cumbersome and annoying. Why? Because in languages like Ruby, we like to work with objects with behavior and properties, not tables, rows and columns.

For this reason, many developers prefer to use an "ORM", an Object-Relational-Mapping.

Wikipedia has a good overview of ORMs. Read the intro and overview sections only.

# Contact class Interface
Given that we already have our app laid out in an OO way, and have a Contact class responsible for managing the contacts, we should ideally just be able to modify the Contact class to talk to the contacts table in our database, instead of to using the @@contacts array in memory to store the contacts.

Below is a list of methods that should ideally be implemented. # implies instance method and . implies class method.

Contact.new(firstname, lastname, email)
The constructor / initializer. Used to represent a contact instance in memory. Does not talk to the database.

Contact#save
Either inserts or updates a row in the database, as necessary for the given instance of contact.

Ask yourself / discuss: When save is called, how will it know whether to run an INSERT or UPDATE SQL statement?

Contact#destroy
Executes a DELETE SQL command against the database.

Ask yourself / discuss: What will it need to provide the database as part of the DELETE SQL statement?

Contact.find(id)
A class method to SELECT a contact row from the database by id and return a Contact instance that represents ("maps to") that row.

Ask yourself / discuss: Why is this a class method and not an instance method?

Contact.find_all_by_lastname(name)
Another class method, but this one returns an array of all contacts that have the provided last name. If none are found, an empty array should be returned.

It will do an exact string match.

Contact.find_all_by_firstname(name)
Same as Contact.find_all_by_lastname(name) but for first name instead.

Contact.find_by_email(email)
Almost identical to the other two methods above. However, since emails are assumed to be unique, we return only a single record (or nil) here. Hence why we use find_by_ instead of find_all_by for this method name.

#Code Walkthrough
Here's an example walkthrough ("driver" code) for how the Contact class (ORM) would be used and how the methods would interact with the database.

Creating a new record
contact = Contact.new("Khurram", "Virani", "kv@example.com")
contact.save
Here, save would trigger an INSERT SQL statement to be sent to the database to add the contact into the the contacts table in our postgres database:

INSERT INTO contacts (firstname, lastname, email)
  VALUES ('Khurram', 'Virani', 'kv@example.com')
The record would get created in the database and the resulting id column (the "Primary Key" value for the row) would be auto-assigned by the database. The ORM should then store the id in the instance variable @id, for later use (eg: to update the record).

contact.id # => 5
Updating a record
Continuing on with our example use of the ORM in Ruby land:

contact.firstname = "K"
contact.lastname = "V"
contact.save
Since this contact was already created, the save method will know not to INSERT this contact but rather UPDATE it in the database:

UPDATE contacts SET firstname='K', lastname='V', email='kv@example.com'
  WHERE id=5
The id=5 part tells the DB which contact to update, and is thus quite crucial (otherwise all the records in the contacts table would get updated). Our Contact class (ORM) should use the @id previously stored for creating this WHERE clause.

Loading a record by ID
Later on, if the class method Contact.find is used, the ORM will simply need to SELECT that record from the DB and create an instance of a Contact that represents that row for us, as such:

same_contact = Contact.find(5)
puts same_contact.firstname # => 'K'
puts same_contact.lastname  # => 'V'
puts same_contact.email # => 'kv@example.com'
The .find method will perform the following SELECT to retrieve the record from the DB and create a new instance of Contact with the necessary information to return back to us.

SELECT c.id, c.firstname, c.lastname, c.email
  FROM contacts AS c
  WHERE c.id = 5
Nice, this can power our show action in the REPL. When a user asks to see contact #5, our Application can use the Contact.find to retrieve the contact!

Using the find_by class methods to search
Using one of the find_by class methods, we can also easily search for contacts like so:

contacts = Contact.find_all_by_lastname('Virani')
contacts.each do |c|
  puts c
end
Note how the find_by method returns an array instead of a single instance. Ask yourself, why would we build it this way?

Destroying a record
The ORM will also provide us with a destroy instance method to DELETE that contact row from the contacts table:

same_contact.destroy
This will execute a SQL statement such as this:

DELETE FROM contacts WHERE id = 5
The record will be deleted from the database but the object instance will remain in memory in Ruby. This is because method call to an object cannot destroy the object it is called on from memory.

Note: Since same_contact will no longer point to a valid, existing record in the database, using ORM methods like save and destroy (again) will likely cause a postgres error/exception. That's okay for now. (We can prevent this by throwing our own exception to the caller instead of attempting to execute an invalid query but let's leave that for now.)

Attempting to find contact with id 5 now will naturally not yield a contact (since it was just deleted.)

Contact.find(5) # => nil

# High-level Steps
Below are some steps to help you get started with your refactoring your contact list app to support a database.

1. Create a new database
You've done this previously. Nothing special here.

2. Connect to it via psql
Since we'll be executing only simple SQL statements, I suggest using psql instead of a GUI.

3. Create a contacts table
Using psql, execute the following SQL statement against the (currently empty) database that you just created:

CREATE TABLE contacts (
  id        serial NOT NULL PRIMARY KEY,
  firstname varchar(40) NOT NULL,
  lastname  varchar(40) NOT NULL,
  email     varchar(40) NOT NULL
);
4. Insert some (seed) records
Execute multiple INSERT statements (again, through psql) to create some dummy records in the contacts table so your app will have contacts to load/find.

5. Create a new branch
Within your contacts list app, create and checkout a new branch called orm or something like that:

git checkout -b orm
This way you can work on and commit/push to a separate branch, and merge back to master later once it's all complete.

6. Implement connection logic
All the orm methods that need to talk to the database need a connection first. Create a connection class method on the Contact class that establishes the connection (using the proper credentials) and returns the connection object. Your other methods will just be able to make use of it. This method shouldn't need to take in any parameters.

7. Implement new and save workflow
As you implement this workflow, consider using irb or pry to "drive" (manually test) your new code. Since this is all pretty new to you, don't worry about TDD.

A better alternative to manually testing/driving your Contact methods using pry, is to write a short ruby script with driver code that uses the Contact class instead, so you don't have to manually type and run driver code each time you want to test/drive your code.

8. Implement other methods
As always, work iteratively! Don't try to implement all the methods at once.