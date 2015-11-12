class Phone < ActiveRecord::Base

  belongs_to :contact

  def to_s
    "#{context}: #{digits}"
  end
end