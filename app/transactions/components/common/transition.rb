# Transition takes a required model and state and optional machine and passive flag
# `model` is the symbol key from `input` where the model to transition can be found
# `state` is the desired state as a symbol
# `machine` is the state machine to wrap the model with. It defaults to an inferrence from `model`
# `passive` is a boolean flag, if true, a failure to transition won't error
#
# The model extracted from input is wrapped in the machine and told to transition to `state`
#

module Components
  module Common
    module Transition
      def self.[] model:, state:, machine: nil, passive: false
        machine = "#{model.to_s.camelize}Machine".constantize if machine.nil?
        -> (input) {
          return Right(input) if input[model].state.to_s == state.to_s
          wrapped = machine.new input[model]
          result = wrapped.transition state
          if result || passive
            Right input
          else
            failed_transition = I18n.t 'errors.transition_failed', kind: input[model].class.name, id: input[model].id, current_state: wrapped.state, desired_state: state
            errors = [failed_transition] + Array(wrapped.failure_messages)
            Left Transactions::Errors.new errors
          end
        }
      end
    end
  end
end
