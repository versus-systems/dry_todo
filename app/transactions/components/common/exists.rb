# Exists takes the same model, params, repo, and from args from `Hydrate`
# Operationally it is exactly the same as hydrate except instead of pulling the record
# It just does an `exists?` check. If true, input is passed unchanged, if false, error.
#

module Components
  module Common
    module Exists
      # rubocop:disable all
      def self.[] model:, params: nil, repo: nil, from: nil
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
          if input[model].present? && input[model].send(attribute) == search_value
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
          exists = repository.exists? attribute => search_value
          if exists
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
