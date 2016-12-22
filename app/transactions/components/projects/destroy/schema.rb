module Components
  module Projects
    module Destroy
      Schema = Dry::Validation.Schema do
        required(:project_id).filled Types::Id
      end
    end
  end
end
