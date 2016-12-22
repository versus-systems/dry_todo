# Lock takes a single required arg model
# `model` is the symbol key into `input`
#
# The value under the `model` from `input` has an AR lock applied
#

module Components
  module Common
    module Lock
      def self.[] model:
        -> (input) {
          input[model].lock!
          Right input
        }
      end
    end
  end
end
