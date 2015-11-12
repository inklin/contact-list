class Contact < ActiveRecord::Base

  has_many :phones

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :email, presence: true

  def to_s
    "#{id}: #{firstname} #{lastname} (#{email})"
  end
end