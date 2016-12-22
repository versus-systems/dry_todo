class Task < ApplicationRecord
  belongs_to :project

  enum state: {
    deleted:      -1,
    todo:         10,
    in_progress:  20,
    complete:     30
  }
  after_initialize :default_state

  scope :active, -> { where.not state: :deleted }

  private

  def default_state
    self.state ||= :todo
  end
end
