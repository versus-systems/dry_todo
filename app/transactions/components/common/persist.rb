# Persist takes a single arg model which is required
# `model` is a symbol key into `input`
#
# The value under `model` from `input` will be sent `save`
# If it succeeds, input is passed on
# If it fails, the AR messages are added to errors
#

module Components
  module Common
    module Persist
      def self.[] model:
        -> (input) {
          if input[model].save
            Right input
          else
            Left Transactions::Errors.new input[model].errors.full_messages
          end
        }
      end
    end
  end
end
