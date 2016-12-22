class TaskMachine < EndState::StateMachine
  transition todo: :in_progress, as: :start
  transition in_progress: :complete, as: :complete
  transition [:todo, :in_progress, :complete] => :deleted, as: :delete
end
