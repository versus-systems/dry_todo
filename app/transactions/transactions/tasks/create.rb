module Transactions
  module Tasks
    Create = Transactions.build(:tasks, :create) do
      step :validate
      step :hydrate,        model: :project
      step :set_attributes, model: :task, attributes: %i{name description points project}
      step :persist,        model: :task
      step :extract,        key: :task
    end
  end
end
