module Types
  include Dry::Types.module

  def self.hash_enum name, hash
    name = name.to_s.camelize
    Types.const_set :"#{name}StringMap", hash
    Types.const_set :"#{name}NumericMap", hash.invert
    Types.const_set name.to_sym, Strict::Int.constrained(included_in: "Types::#{name}NumericMap".constantize.keys) | Coercible::String.constrained(included_in: "Types::#{name}StringMap".constantize.keys)
    Types::Coercible.const_set name.to_sym, Coercible::String.constructor { |input| "Types::#{name}".constantize["Types::#{name}NumericMap".constantize[input.to_i] || input] }
    Types::Coercible.const_set :"Numeric#{name}", Coercible::String.constructor { |input| "Types::#{name}StringMap".constantize[input.to_s] }
  end

  Id = Coercible::String.constrained(format: /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/)

  OrderDirection = Coercible::String.constrained included_in: ['asc', 'desc']

  Page = Coercible::Int.constrained gt: 0
  PageSize = Coercible::Int.constrained gt: 0

  Points = Coercible::Int.constrained included_in: [0, 1, 2, 3, 5, 8, 13]

  hash_enum 'ProjectState', Project.states

  hash_enum 'TaskState', Task.states

end
