require 'dry/matcher/either_matcher'
ActionController::Parameters.permit_all_parameters = true

class ApplicationController < ActionController::Base
  def self.action name
    resource = controller_name.camelize
    transaction = "Transactions::#{resource}::#{name.to_s.capitalize}".constantize
    define_method name do
      transacted = Transact.call transaction, params.to_h
      Dry::Matcher::EitherMatcher.call(transacted) do |result|
        result.success { |value| render json: value }
        result.failure { |value| render json: { errors: value.errors } }
      end
    end
  end

  def self.actions *names
    names.each do |name|
      action name
    end
  end
end
