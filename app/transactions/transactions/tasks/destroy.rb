module Transactions
  module Tasks
    Destroy = Transactions.build(:tasks, :destroy) do
      step :validate
      step :hydrate,    model: :project
      step :hydrate,    model: :task, from: :project
      step :transition, model: :task, state: :deleted
      step :persist,    model: :task
      step :extract,    key: :task
    end
  end
end
