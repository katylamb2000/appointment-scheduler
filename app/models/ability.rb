class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :access, :rails_admin
      can :dashboard
      can :manage, :all
    elsif user.instructor?
      # TODO read, update Feedback
      can :access, :rails_admin
      can :dashboard
      # read, update appointments
      can :read, Appointment, :instructor_id => user.id
      can :update, Appointment, :instructor_id => user.id
      can :export, Appointment, :instructor_id => user.id
      # manage Availabilities
      can :manage, Availability, :instructor_id => user.id
      can :export, Availability, :instructor_id => user.id
      # manage own LessonMaterials
      can :manage, LessonMaterial, :instructor_id => user.id
      can :manage, StudentMaterial, lesson_material: { instructor_id: user.id }
      # update own profile
      can :read, User, :id => user.id
      can :update, User, :id => user.id
      can :export, User, :id => user.id
      # see limited student profiles
      can :read, User, appointments: { instructor_id: user.id }
      can :export, User, appointments: { instructor_id: user.id }
    else
      can :read, Appointment, :user_id => user.id
      can :manage, User, :id => user.id
    end
  end
end
