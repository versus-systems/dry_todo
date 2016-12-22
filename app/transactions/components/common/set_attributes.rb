# If the specified `model` key exists in input,
# it's attributes are updated to the specified attributes from input
# if they are in the input
# If the specified `model` key does not exist, a new model is initialized first
#

module Components
  module Common
    module SetAttributes
      def self.[](model:, attributes:)
        klass = model.to_s.camelize.constantize
        -> (input) do
          input[model] ||= klass.new
          settable = attributes.select { |attribute| input.key? attribute }
          input[model].assign_attributes input.slice(*settable)
          Right input
        end
      end
    end
  end
end
