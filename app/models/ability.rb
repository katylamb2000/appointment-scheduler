class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :access, :rails_admin
      can :dashboard
      can :manage, :all
    elsif user.instructor?
      can :access, :rails_admin
      can :dashboard
      can :manage, Availability, :instructor_id => user.id
    else
      can :manage, User, :id => user.id
    end
  end
end
