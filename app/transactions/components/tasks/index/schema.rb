module Components
  module Tasks
    module Index
      Schema = Dry::Validation.Schema do
        required(:project_id).filled Types::Id
        optional(:task_id).filled Types::Id
        optional(:task_ids).each Types::Id
        optional(:state).filled Types::TaskState
        optional(:order_by).filled :str?
        optional(:order_direction).filled Types::OrderDirection
        optional(:page).filled Types::Page
        optional(:page_size).filled Types::PageSize

        rule single_id_reference: [:task_id, :task_ids] do |id, ids|
          (id.filled? & ids.none?) |
          (id.none? & ids.filled?) |
          (id.none? & ids.none?)
        end
      end
    end
  end
end
