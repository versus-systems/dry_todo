# Extract takes a key (required) and an optional wrap flag
# `key` is a symbol key from `input`
# `wrap` is a boolean flag
#
# This is used as a final step in a transaction to return the desired result
# The value from `input` under the `key` is the result of this component rather than `input`
# If `wrap` is true, the result is instead a hash with one key/value.
# The key of that hash is the `key` and the value is the extracted value.
#

module Components
  module Common
    module Extract
      def self.[] key:, wrap: false
        -> (input) {
          if wrap
            Right key => input[key]
          else
            Right input[key]
          end
        }
      end
    end
  end
end
