# Filter takes a number of arguments, all of them optional
# `collection` is the key from `input` where the collection we are filtering lives, defaults to `:collection`
# `attribute` is the symbol attribute on the collection to filter
# `value` is symbol key from `input` where the value to filter the attribute by lives. It defaults to `attribute`
# `association` is a symbol key for an association to join the collection on which is then filtered via attribute/value
# `through` is an alias for `association`, if `association` present it overrides `through`
# `where` is a string clause that is fed to `where` on the collection
# `values` is an array of symbol keys from `input` that if provided,
#          an array of values will be pulled from `input` with those keys and
#          will be fed as the remain args to `where` used for `?`
#
# The `collection` in input is replaced with the new filted collection
# If the input is invalid or or the values pull from `input` are nil, the collection is returned as is.
# This allows for us to "filter" and not care if actually filter or not.
# If you MUST filter by something then make sure your schema requires it and you will safely have it.
#

module Components
  module Common
    module Filter
      # rubocop:disable all
      def self.[] collection: :collection, attribute: nil, value: attribute, through: nil, association: through, where: nil, values: nil
        -> (input) {
          if association.present? && attribute.present? && value.present? && input[value].present?
            input[collection] = input[collection].joins(association).where(association.to_s.pluralize.to_sym => { attribute => input[value] })
          elsif where.present?
            params = Array(values).map { |key| input[key] }
            input[collection] = input[collection].where(where, *params) if params.all?(&:present?)
          elsif attribute.present? && value.present? && input[value].present?
            input[collection] = input[collection].where(attribute => input[value])
          end
          Right input
        }
      end
      # rubocop:enable all
    end
  end
end
