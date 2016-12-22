module Components
  module Projects
    module Show
      Schema = Dry::Validation.Schema do
        required(:project_id).filled Types::Id
      end
    end
  end
end
