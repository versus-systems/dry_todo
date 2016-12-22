module Transactions
  module Projects
    Enable = Transactions.build(:projects, :enable) do
      step :validate
      step :hydrate,    model: :project
      step :transition, model: :project, state: :enabled
      step :persist,    model: :project
      step :extract,    key: :project
    end
  end
end
