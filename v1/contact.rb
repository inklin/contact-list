class Contact
  attr_reader :numbers, :name, :email, :id

  def initialize(name, email, id, numbers)
    @name = name
    @email = email
    @id = id
    @numbers = numbers
  end
 
  def to_s
    numbers_string = @numbers.to_a.flatten.join(',')
    "#{@id},#{@name},#{@email},'#{numbers_string}'\n"
  end
end