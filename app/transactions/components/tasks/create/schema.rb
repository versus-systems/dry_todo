module Components
  module Tasks
    module Create
      Schema = Dry::Validation.Schema do
        required(:project_id).filled Types::Id
        required(:name).filled :str?
        required(:points).filled Types::Points
        optional(:description).maybe :str?
      end
    end
  end
end
