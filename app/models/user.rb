class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async

  validates_presence_of :first_name, :city, :country, :age
  validates :gender, inclusion: { in: ["male", "female"] }, allow_nil: true
end
