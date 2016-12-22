class ProjectMachine < EndState::StateMachine
  transition enabled: :disabled, as: :enable
  transition disabled: :enabled, as: :disable
end
