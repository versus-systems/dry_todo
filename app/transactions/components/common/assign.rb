# Assign takes a source and a destination, both required
# `source` is where/how to get the value
# `destination` is the symbol key in `input` to store the value
#
# `source` can be a variety of types:
#    Symbol - :match_instances - pull the value from input using source as a key
#    Hash - {game: :players} - single key/value (both symbols).
#                              Pull the key from input and `send` it the value.
#    Array - [:auth, :user_id] - array of symbols. `dig` into the input hash
#    Callable - -> { [] } - a callable object, like Lambda. Will be called for the value.
#                           Used to ensure a unique value as transaction defs are read only once.
#    Any - 'some random value' - Anything that is not one of the above is treated as itself.
#

module Components
  module Common
    module Assign
      # rubocop:disable all
      def self.[] source:, destination:
        -> (input) {
          if source.is_a? Symbol
            value = input[source]
          elsif source.is_a? Hash
            container = source.keys.first
            methods = Array(source.values.first)
            container = input[container] if container.is_a? Symbol
            if container.present?
              value = methods.reduce(container) { |receiver, attribute| receiver.send attribute }
            end
          elsif source.is_a? Array
            value = input.dig(*source)
          elsif source.respond_to? :call
            value = source.call
          else
            value = source
          end
          input[destination] = value unless value.nil?
          Right input
        }
      end
      # rubocop:enable all
    end
  end
end
