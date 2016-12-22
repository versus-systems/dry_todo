module Components
  module Projects
    module Update
      Schema = Dry::Validation.Schema do
        required(:project_id).filled Types::Id
        optional(:name).filled :str?
        optional(:description).filled :str?
      end
    end
  end
end
