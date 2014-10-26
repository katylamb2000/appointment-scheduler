class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async

  validates_presence_of :first_name, unless: Proc.new { |u| u.admin? }
  validates_presence_of :city, :country, :age, unless: Proc.new { |u| u.admin? || u.instructor? }

  validates :gender, inclusion: { in: ["male", "female"] }, allow_nil: true

  def admin?
    admin
  end

  def instructor?
    instructor
  end
end
