module Transactions
  module Projects
    Destroy = Transactions.build(:projects, :destroy) do
      step :validate
      step :hydrate,    model: :project
      step :transition, model: :project, state: :disabled
      step :persist,    model: :project
      step :extract,    key: :project
    end
  end
end
