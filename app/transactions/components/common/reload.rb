# Reload takes a single required arg model
# `model` is a symbol key into `input`
#
# The value under `model` from `input` is pulled
# and sent `relaod`
#

module Components
  module Common
    module Reload
      def self.[] model:
        -> (input) {
          input[model].reload
          Right input
        }
      end
    end
  end
end
