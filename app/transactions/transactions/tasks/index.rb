module Transactions
  module Tasks
    Index = Transactions.build(:tasks, :index) do
      step :validate
      step :hydrate, model: :project
      step :exists,  model: :task, from: :project
      step :assign,  source: {project: [:tasks, :active]}, destination: :collection
      step :filter,  attribute: :id, value: :task_id
      step :filter,  attribute: :id, value: :task_ids
      step :filter,  attribute: :state
      step :order,   clause: {created_at: :asc}
      step :page,    key: :tasks
      step :extract, key: :paged
    end
  end
end
