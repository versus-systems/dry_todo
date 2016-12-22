class Project < ApplicationRecord
  has_many :tasks

  enum state: {
    enabled:  10,
    disabled: 20
  }
  after_initialize :default_state

  private

  def default_state
    self.state ||= :enabled
  end
end
