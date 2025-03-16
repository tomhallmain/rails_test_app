RailsAdmin.config do |config|
  config.asset_source = :importmap
  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Authorization ==
  config.authorize_with do
    unless current_user.admin?
      flash[:error] = 'You are not authorized to access this page.'
      redirect_to main_app.root_path
    end
  end

  config.actions do
    dashboard
    index
    new
    show
    edit
    delete
  end

  # Task configuration
  config.model 'Task' do
    list do
      field :id
      field :title
      field :project
      field :user
      field :completed
      field :archived
      field :due_date
      field :priority
      field :created_at
    end

    show do
      field :id
      field :title
      field :description
      field :project
      field :user
      field :completed
      field :completed_at
      field :completed_by
      field :archived
      field :archived_at
      field :archived_by
      field :due_date
      field :priority
      field :tags
      field :comments
      field :created_at
      field :updated_at
      field :versions
    end
  end

  # Project configuration
  config.model 'Project' do
    list do
      field :id
      field :title
      field :user
      field :due_date
      field :tasks_count do
        formatted_value do
          bindings[:object].tasks.count
        end
      end
      field :created_at
    end
  end

  # Comment configuration
  config.model 'Comment' do
    list do
      field :id
      field :task
      field :user
      field :content
      field :status
      field :created_at
    end
  end

  # Version configuration for PaperTrail
  config.model 'PaperTrail::Version' do
    list do
      field :id
      field :item_type
      field :item_id
      field :event
      field :whodunnit
      field :created_at
      field :ip
      field :user_agent
    end
  end
end 