# Default takes a key and a value, both required
# `key` is the symbol key from `input` we want to use
# `value` is what we want to set in `key`
# The `input[key]` is set to value if `input` doesn't already have that key
# The assignment is done using `Assign` so `value` must be a valid `source`
#

module Components
  module Common
    module Default
      def self.[] key:, value:
        -> (input) {
          return Right(input) if input.keys.include? key
          Components::Common::Assign[source: value, destination: key].call(input)
        }
      end
    end
  end
end
