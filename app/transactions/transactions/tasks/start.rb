module Transactions
  module Tasks
    Start = Transactions.build(:tasks, :start) do
      step :validate
      step :hydrate,    model: :project
      step :hydrate,    model: :task, from: :project
      step :transition, model: :task, state: :in_progress
      step :persist,    model: :task
      step :extract,    key: :task
    end
  end
end
