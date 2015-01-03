class Feedback < ActiveRecord::Base
  validates_presence_of :user_id, :appointment_id, :notes, :context
  validates :context, inclusion: { in: ["left by instructor", "left by student"] }
  validates_uniqueness_of :user_id, scope: :appointment_id

  belongs_to :user
  belongs_to :appointment

  rails_admin do
    list do
      field :id
      field :user do
        pretty_value do
          user = bindings[:object].user
          if user.instructor?
            bindings[:view].content_tag(:a, bindings[:object].user.full_name, { :href => "/admin/instructor/#{user.id}"} )
          else
            bindings[:view].content_tag(:a, bindings[:object].user.full_name, { :href => "/admin/student/#{user.id}"} )
          end
        end
      end
      field :context
    end    
  end
end