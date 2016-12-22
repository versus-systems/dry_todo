module Components
  module Projects
    module Create
      Schema = Dry::Validation.Schema do
        required(:name).filled :str?
        optional(:description).filled :str?
      end
    end
  end
end
