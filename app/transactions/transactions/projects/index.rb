module Transactions
  module Projects
    Index = Transactions.build(:projects, :index) do
      step :validate
      step :exists,  model: :project
      step :default, key: :state, value: 'enabled'
      step :assign,  source: Project, destination: :collection
      step :filter,  attribute: :id, value: :project_id
      step :filter,  attribute: :id, value: :project_ids
      step :filter,  attribute: :state
      step :order,   clause: {created_at: :asc}
      step :page,    key: :projects
      step :extract, key: :paged
    end
  end
end
