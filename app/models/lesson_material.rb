class LessonMaterial < ActiveRecord::Base
  validates_presence_of :instructor_id, :name, :attachment
  validates_uniqueness_of :name

  belongs_to :instructor, class_name: "User"

  mount_uploader :attachment, AttachmentUploader
  process_in_background :attachment

  rails_admin do
    list do
      field :id
      field :instructor do
        visible do
          bindings[:controller].current_user.admin?
        end
      end
      field :name
      field :attachment
    end

    show do
      field :id
      field :instructor do
        visible do
          bindings[:controller].current_user.admin?
        end
      end
      field :name
      field :description
      field :attachment
    end

    edit do
      field :instructor do
        inline_add false
        inline_edit false
        visible do
          bindings[:controller].current_user.admin?
        end
      end
      field :name
      field :description
      field :attachment
    end
    edit do
    end
  end
end