module Components
  module Projects
    module Index
      Schema = Dry::Validation.Schema do
        optional(:project_id).filled Types::Id
        optional(:project_ids).each Types::Id
        optional(:state).filled Types::ProjectState
        optional(:order_by).filled :str?
        optional(:order_direction).filled Types::OrderDirection
        optional(:page).filled Types::Page
        optional(:page_size).filled Types::PageSize

        rule single_id_reference: [:project_id, :project_ids] do |id, ids|
          (id.filled? & ids.none?) |
          (id.none? & ids.filled?) |
          (id.none? & ids.none?)
        end
      end
    end
  end
end
