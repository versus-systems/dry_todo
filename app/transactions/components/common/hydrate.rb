# Hydrate takes a number of arguments, the only required one is `model`
# `model` is a symbol key that represents where the result should be stored.
#         it is also used to infer a lot of defaults for the other optional args.
# `params` is a hash, each key/value pair will be tried to see which has a value in `input`
#          the key is the attribue that will be used in the `find_by`
#          the value is a sybol key from `input` that holds the value we will search by.
#          If not provided this defaults to an attribute of `:id` and a value of `<model>_id`
# `repo` Is the think that will receive the `find_by`
#        If not provided it defaults to the AR class inferred from `model`
#        If `from` is provided it defaults to a hash { from => <models>s }
#        When repo is:
#        Hash - It should be 1 key/value. The key is a symbol into `input`
#               The `input[key]` is pulled and sent the hash value symbol.
#               (i.e. `{ game: :players }` is equivalent to: `input[:game].players`)
#        Symbol - This is a key into `input` that should be the string name of a model class
#        String - This is a string which should be the name of a model class, it is constantized
#        AR Class - This is an AR model class and/or association and is treated as is
# `from` Is a symbol key from input that is used to infer the repo
# `fail_ok` Is a boolean flag, default `false`. If `true` a failure to find does not error.
# `force` Is a boolean flag, default `false`. If `true` hydration is done even if `input[model]` is already set
#

module Components
  module Common
    module Hydrate
      # rubocop:disable all
      def self.[] model:, params: nil, repo: nil, from: nil, fail_ok: false, force: false
        repo = { from => model.to_s.pluralize.to_sym } if from.present?
        repo = model.to_s.classify.constantize if repo.nil?
        params = { id: "#{model}_id".to_sym } if params.nil?
        -> (input) {
          attribute, search_key, search_value = params.reduce([]) do |result, (a, k)|
            if input.dig(*Array(k)).present?
              [a, Array(k).last, input.dig(*Array(k))]
            else
              result
            end
          end
          return Right(input) unless search_key.present?
          if input[model].present? && input[model].send(attribute) == search_value && !force
            return Right input
          end
          repository = repo
          case repo
          when Hash
            model_type = repo.values.first.to_s.underscore.pluralize
            repository = input[repo.keys.first].send repo.values.first
          when Symbol
            model_type = input[repo].underscore.pluralize
            repository = input[repo].constantize
          when String
            model_type = repo.underscore.pluralize
            repository = repo.constantize
          else
            model_type = repo.name.underscore.pluralize
          end
          hydrated = repository.find_by attribute => search_value
          if hydrated
            input[model] = hydrated
            Right input
          elsif fail_ok
            Right input
          else
            Left Transactions::Errors.new I18n.t("#{model_type}.errors.not_found", id_type: search_key.to_s.camelize(:lower), id: search_value)
          end
        }
      end
      # rubocop:enable all
    end
  end
end
