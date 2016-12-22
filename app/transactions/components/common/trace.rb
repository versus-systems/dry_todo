# Trace is an internal component that shouldn't be directly used.
# It should never be used in production.
# Any transaction `build` can have an optional arg `traced: true`
# When traced is true in a transaction `build`,
# a Trace component is inserted before the first step and after every step
# This causes useful information about which step is being executed and what the input is
# All `traced: true` flags should be removed before merging to `develop`
#

module Components
  module Common
    module Trace
      # rubocop:disable all
      def self.[] step_num:, namespace:, transaction_name:, multi:, name:, args:
        -> (input) {
          transaction = multi ? "#{transaction_name}_list" : transaction_name
          pp "Step Number #{step_num}, #{namespace}, #{transaction}, #{name}"
          pp "Step Meta Args: #{args}"
          pp input
          Right input
        }
      end
      # rubocop:enable all
    end
  end
end
