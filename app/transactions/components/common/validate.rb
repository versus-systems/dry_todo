# Schema takes a single required arg `schema`
# `schema` is a DRY Schema
# While this is a required arg, it is optional in the step def
# If left out of the step def, it is inferred from the namespace/transaction
# The inferred name is `Components::<namespace>::<transaction>::Schema`
# For `<transaction>_list` it is `Components::<namespace>::<transaction>::ListSchema`
#

module Components
  module Common
    module Validate
      def self.[] schema:
        -> (input) {
          validated = schema.call input
          if validated.success?
            Right validated.output
          else
            errors = validated.messages.map do |(attr, errs)|
              errs.map { |e| "#{attr.to_s.camelize(:lower)}#{input[attr].present? ? ' ' + input[attr].to_s : ''} #{e}" }
            end.flatten
            Left Transactions::Errors.new errors
          end
        }
      end
    end
  end
end
