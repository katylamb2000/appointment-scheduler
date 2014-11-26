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
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
