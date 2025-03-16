class Comment < ApplicationRecord
  # Enable version tracking
  has_paper_trail

  # Associations
  belongs_to :user
  belongs_to :task

  # Validations
  validates :content, presence: true
  validates :status, inclusion: { in: %w[open closed resolved], message: "%{value} is not a valid status" }

  # Scopes
  scope :unresolved, -> { where(status: 'open') }
  scope :resolved, -> { where(status: 'resolved') }
  scope :closed, -> { where(status: 'closed') }
  
  # Callbacks
  after_save :update_task_status, if: :status_changed?
  
  private
  
  def update_task_status
    # If all comments are resolved/closed, we can update the task
    if task.comments.unresolved.empty?
      task.update(completed: true, completed_at: Time.current, completed_by: user_id)
    end
  end
end
