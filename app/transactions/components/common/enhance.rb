# Enhance takes a list and it is required
# `list` is the symbol key from `input`
# The value under `list` in `input` should be an array of hashes
# A subinput is created from the input minus the `list` key
# The list then has every member merged with that subinput
# This is useful for prepping a list for a process call
# where there may be shared top level attributes
#

module Components
  module Common
    module Enhance
      def self.[] list:
        @enhancers ||= {}
        @enhancers[list] ||= -> (input) {
          items = input[list]
          top = input.delete_if { |k, _| k.to_sym == list }
          input[list] = items.map { |record| record.merge top }
          Right input
        }
      end
    end
  end
end
