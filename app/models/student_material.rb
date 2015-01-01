class StudentMaterial < ActiveRecord::Base
  validates_presence_of :user_id, :lesson_material_id

  belongs_to :user
  belongs_to :lesson_material

  rails_admin do
    list do
      field :id
      field :user
      field :lesson_material
      field :instructor_notes
    end

    show do
      field :id
      field :user
      field :lesson_material
      field :instructor_notes
      field :student_notes
    end

    create do
      field :user do
        inline_add false
        inline_edit false
        associated_collection_scope do
          Proc.new { |scope| scope = scope.active.where(instructor: false).where(admin: false) }
        end
      end
      field :lesson_material do
        inline_add false
        inline_edit false
      end
      field :instructor_notes
    end

    edit do
      field :user do
        read_only do
          !(bindings[:view].current_user.admin?)
        end
        associated_collection_scope do
          Proc.new { |scope| scope = scope.active }
        end
        inline_add false
        inline_edit false
      end
      field :lesson_material do
        read_only do
          !(bindings[:view].current_user.admin?)
        end
        inline_add false
        inline_edit false
      end
      field :instructor_notes
      field :student_notes do
        read_only do
          !(bindings[:view].current_user.admin?)
        end
      end
    end
  end
end