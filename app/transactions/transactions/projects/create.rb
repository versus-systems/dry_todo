module Transactions
  module Projects
    Create = Transactions.build(:projects, :create) do
      step :validate
      step :set_attributes, model: :project, attributes: %i{name description}
      step :persist,        model: :project
      step :extract,        key: :project
    end
  end
end
