class Comment < ApplicationRecord
  # Enable version tracking
  has_paper_trail versions: {
    scope: -> { order("id desc") }
  },
  meta: {
    user_id: :user_id_for_paper_trail,
    ip: :ip_for_paper_trail,
    user_agent: :user_agent_for_paper_trail
  }

  # Associations
  belongs_to :user
  belongs_to :task, optional: true
  belongs_to :project, optional: true

  # Validations
  validates :content, presence: true
  validates :status, inclusion: { in: %w[open closed resolved], message: "%{value} is not a valid status" }
  validate :must_belong_to_task_or_project
  validate :cannot_belong_to_both_task_and_project

  # Scopes
  scope :unresolved, -> { where(status: 'open') }
  scope :resolved, -> { where(status: 'resolved') }
  scope :closed, -> { where(status: 'closed') }
  
  private
  
  def must_belong_to_task_or_project
    unless task.present? || project.present?
      errors.add(:base, "Comment must belong to either a task or a project")
    end
  end

  def cannot_belong_to_both_task_and_project
    if task.present? && project.present?
      errors.add(:base, "Comment cannot belong to both a task and a project")
    end
  end

  def user_id_for_paper_trail
    PaperTrail.request.whodunnit
  end

  def ip_for_paper_trail
    PaperTrail.request.controller_info[:ip]
  end

  def user_agent_for_paper_trail
    PaperTrail.request.controller_info[:user_agent]
  end
end
