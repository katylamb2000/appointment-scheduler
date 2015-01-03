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
      # read, update appointments
      can :read, Appointment, :instructor_id => user.id
      can :update, Appointment, :instructor_id => user.id
      can :export, Appointment, :instructor_id => user.id
      # manage Availabilities
      can :manage, Availability, :instructor_id => user.id
      can :export, Availability, :instructor_id => user.id
      # read, update received Feedback
      can :read, Feedback, appointment: { :instructor_id => user.id }
      can :export, Feedback, appointment: { :instructor_id => user.id }
      # read, update given Feedback
      can :create, Feedback, :user_id => user.id
      can :read, Feedback, :user_id => user.id
      can :update, Feedback, :user_id => user.id
      can :export, Feedback, :user_id => user.id
      # manage own LessonMaterials
      can :manage, LessonMaterial, :instructor_id => user.id
      # manage giving own students own materials
      can :manage, StudentMaterial, lesson_material: { instructor_id: user.id }
      # update own profile
      can :read, Instructor, :id => user.id
      can :update, Instructor, :id => user.id
      can :export, Instructor, :id => user.id
      # see limited student profiles
      can :read, Student, appointments: { instructor_id: user.id }
      can :export, Student, appointments: { instructor_id: user.id }
    else
      can :read, Appointment, :user_id => user.id
      can :update, StudentMaterial, :user_id => user.id
      can :manage, User, :id => user.id, :deleted_at => nil
    end
  end
end
