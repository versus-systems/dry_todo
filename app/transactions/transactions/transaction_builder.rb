# Steps are looked up via name.
# First the Components::Common namespace is searched
# Then the Components::<namespace>::<transaction_name> namspace is searched
# Finally the Components::<namespace> namespace is searched
# This allows for project-wide common components as well
# as custom components specific to a transaction
# and custom components specific to a namespaced group of transactions
#

module Transactions
  class TransactionBuilder
    attr_reader :namespace, :transaction_name, :multi, :steps, :traced

    def initialize namespace, transaction_name, traced=false
      @namespace = namespace.to_s.camelize
      @transaction_name = transaction_name.to_s.camelize
      if !!@transaction_name.match(/.+List$/)
        @multi = true
        @transaction_name = @transaction_name.gsub(/List$/, '')
      else
        @multi = false
      end
      @traced = traced
      @steps = {}
    end

    def build &block
      instance_eval(&block)
    end

    # rubocop:disable all
    def step name, **args
      component = manual_component(args) ||
                  custom_component(name) ||
                  common_component(name)

      args = safe_args args
      fail("No such component: #{name}") unless component
      args = assumed_args(name) unless args.present?
      component = component[args] if component.is_a? Module
      step_num = steps.keys.count + 1
      if traced && step_num == 1
        steps["step_0".to_sym] = Components::Common::Trace[step_num: 0, namespace: namespace, transaction_name: transaction_name, multi: multi, name: 'Initial', args: {}]
      end
      steps["step_#{step_num}".to_sym] = component
      if traced
        steps["step_#{step_num + 1}".to_sym] = Components::Common::Trace[step_num: step_num, namespace: namespace, transaction_name: transaction_name, multi: multi, name: name, args: args]
      end
    end
    # rubocop:enable all

    def transaction
      trans = Dry::Transaction::DSL.new(container: {}) {}
      steps.each do |name, component|
        trans.step name, with: component
      end
      trans.call
    end

    private

    def safe_args args
      if args.keys.length == 1 && args[:with].present?
        args.delete :with
      end
      args
    end

    def assumed_args name
      case name
      when :validate
        if multi
          {schema: "Components::#{namespace}::#{transaction_name}::ListSchema".constantize}
        else
          {schema: "Components::#{namespace}::#{transaction_name}::Schema".constantize}
        end
      end
    end

    def common_component name
      full_name = "Components::Common::#{name.to_s.camelize}"
      full_name.constantize
    rescue
      nil
    end

    def custom_component name
      full_custom_component(name) ||
      alt_custom_component(name)
    end

    def full_custom_component name
      full_name = "Components::#{namespace}::#{transaction_name}::#{name.to_s.camelize}"
      full_name.constantize
    rescue
      nil
    end

    def alt_custom_component name
      alt_name = "Components::#{namespace}::#{name.to_s.camelize}"
      alt_name.constantize
    rescue
      nil
    end

    def manual_component args
      return unless args.present?
      if args.keys.length == 1 && args[:with].present?
        args[:with]
      end
    end
  end
end
