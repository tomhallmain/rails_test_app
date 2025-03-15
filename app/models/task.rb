class Task < ApplicationRecord
  validates :title, presence: true
  validates :priority, inclusion: { in: %w[low medium high] }, allow_nil: true
  
  before_create :set_defaults
  
  private
  
  def set_defaults
    self.completed ||= false
    self.priority ||= 'medium'
  end
end
