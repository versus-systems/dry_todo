# Page takes a required key and optional collection and destination
# `key` is the symbol key to use to store the paged results under in our standard paging hash result
# `collection` is the symbol key from `input` to pull the collection to page. Default `:collection`
# `destination` is the symbol key from `input` to place the resulting page hash, defaults to `:paged`
#
# While not meta arguments to `Page`, the function assumes there may be input keys `:page` and `:page_size`
# These are passed to the `Pager`. The `Pager` defaults to page 1 and page size 25.
#

module Components
  module Common
    module Page
      def self.[] key:, collection: :collection, destination: :paged
        -> (input) {
          pager = Pager.new input[collection], input[:page], input[:page_size]
          input[destination] = {
            key.to_s.camelize(:lower).to_sym => Array(pager.results),
            count: pager.total_count,
            current_page_number: pager.page,
            total_page_count: pager.total_page_count
          }
          Right input
        }
      end
    end
  end
end
