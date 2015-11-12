class Contact < ActiveRecord::Base

  has_many :phones

  validates :firstname, presence: true

  def to_s
    "#{id}: #{firstname} #{lastname} (#{email})"
  end
end