module Components
  module Tasks
    module Destroy
      Schema = Dry::Validation.Schema do
        required(:project_id).filled Types::Id
        required(:task_id).filled Types::Id
      end
    end
  end
end
