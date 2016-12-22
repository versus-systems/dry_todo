# Coerce takes a value and a type, both required
# `value` is a symbol key from `input`
# `type` is a DRY coercible Type
#
#  The value from input under the `value` key
#  is wrapped in the `type` to coerce it.
#  The result is assigned back into the same key in input
#

module Components
  module Common
    module Coerce
      def self.[] value:, type:
        -> (input) {
          begin
            input[value] = type[input[value]]
            Right input
          rescue Dry::Types::ConstraintError
            Left Transactions::Errors.new I18n.t('errors.coercion', key: value)
          end
        }
      end
    end
  end
end
