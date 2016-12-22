module Transactions
  module Projects
    Update = Transactions.build(:projects, :update) do
      step :validate
      step :hydrate,        model: :project
      step :set_attributes, model: :project, attributes: %i{name description}
      step :persist,        model: :project
      step :extract,        key: :project
    end
  end
end
