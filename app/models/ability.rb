class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :access, :rails_admin
      can :dashboard
      can :manage, :all
    elsif user.instructor?
      # update own profile
      # see limited student profiles
      # read, update appointments (only statuses)
      # manage Availabilities
      # read, update Feedback
      can :access, :rails_admin
      can :dashboard
      can :read, User, :id => user.id
      can :update, User, :id => user.id
      can :read, User, appointments: { instructor_id: user.id }
      can :manage, Availability, :instructor_id => user.id
      can :read, Appointment, :instructor_id => user.id
      can :update, Appointment, :instructor_id => user.id
    else
      can :manage, User, :id => user.id
    end
  end
end
