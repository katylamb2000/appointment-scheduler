RailsAdmin.config do |config|
  
  # config.excluded_models << "User" # TODO: consider this option

  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  # TODO custom actions: bulk status update
  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except ['Guest', 'Student', 'Rebooking']
    end
    export
    bulk_delete
    show
    edit do
      except ['Rebooking']
    end
    delete do
      except ['Rebooking']
    end

    member :restore do
      link_icon 'icon-repeat'
      
      visible do
        bindings[:object].class.name == 'DeletedUser' && bindings[:controller].current_user.admin?
      end
      
      controller do
        Proc.new do
          @object.restore!
            flash[:success] = "This user has been restored."
            redirect_to index_path
        end
      end
    end

    collection :trigger_email do # TODO remove, testing only.
      link_icon 'icon-envelope'

      visible do
        bindings[:abstract_model].model.to_s == "Appointment" && bindings[:controller].current_user.admin?
      end

      controller do
        Proc.new do
          ReminderScheduleWorker.perform_async
          flash[:notice] = "The send email process had been triggered. Please check that the appropriate emails have been sent."
          redirect_to :back
        end
      end
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
