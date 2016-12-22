Rails.application.routes.draw do
  defaults = {
    constraints: { format: 'json' },
    only: %i(index show create update destroy)
  }

  resources :projects, defaults.merge(param: :project_id) do
    member do
      patch 'enable'
      resources :tasks, defaults.merge(param: :task_id) do
        member do
          patch 'start'
          patch 'complete'
        end
      end
    end
  end

end
