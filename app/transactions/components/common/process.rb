# Process takes a list and a processor, both required
# `list` is a symbol key into `input` where an array of hashes can be found
# `processor` is a DRY Transaction
#
# Each record in the list will be fed as input to the processor.
# The collected results will replace the `list` in `input`
# All errors are collected and if any, the Process operation fails.
#

module Components
  module Common
    module Process
      def self.[] list:, processor:
        -> (input) {
          results = input[list].map { |record| processor.call record }
          if results.all? { |result| result.success? }
            input[list] = results.map(&:value)
            Right input
          else
            errors = results.select { |record| record.failure? }
                            .reduce(Transactions::Errors.new) { |err, record| err.merge record.value }
            Left errors
          end
        }
      end
    end
  end
end
