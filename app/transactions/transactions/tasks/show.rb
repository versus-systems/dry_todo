module Transactions
  module Tasks
    Show = Transactions.build(:tasks, :show) do
      step :validate
      step :hydrate, model: :project
      step :hydrate, model: :task, from: :project
      step :extract, key: :task
    end
  end
end
