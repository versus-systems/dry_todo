module Components
  module Tasks
    module Update
      Schema = Dry::Validation.Schema do
        required(:project_id).filled Types::Id
        required(:task_id).filled Types::Id
        optional(:name).filled :str?
        optional(:description).maybe :str?
        optional(:points).filled Types::Points
      end
    end
  end
end
