module Transactions
  module Tasks
    Complete = Transactions.build(:tasks, :complete) do
      step :validate
      step :hydrate,    model: :project
      step :hydrate,    model: :task, from: :project
      step :transition, model: :task, state: :complete
      step :persist,    model: :task
      step :extract,    key: :task
    end
  end
end
