module Transactions
  module Projects
    Show = Transactions.build(:projects, :show) do
      step :validate
      step :hydrate, model: :project
      step :extract, key: :project
    end
  end
end
