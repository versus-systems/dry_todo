# Subtransaction takes a required transaction and destination and an optional restricted
# `transaction` is a Dry Transaction
# `destination` is a symbol key in `input` to place the result
# `restricted` is an array of symbol keys in `input` to slice from input and used instead of input
#
# The transaction is called using input (possibly restricted)
# The result is placed in destination if successful
# Any error passes on out as the result of Subtransaction
#

module Components
  module Common
    module Subtransaction
      def self.[] transaction:, destination:, restricted: []
        -> (input) {
          if restricted.any?
            subinput = input.slice(*restricted)
          else
            subinput = input
          end
          transaction.call(subinput).fmap do |result|
            input[destination] = result
            input
          end
        }
      end
    end
  end
end
