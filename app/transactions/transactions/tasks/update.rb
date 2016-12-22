module Transactions
  module Tasks
    Update = Transactions.build(:tasks, :update) do
      step :validate
      step :hydrate,        model: :project
      step :hydrate,        model: :task, from: :project
      step :set_attributes, model: :task, attributes: %i{name description points}
      step :persist,        model: :task
      step :extract,        key: :task
    end
  end
end
