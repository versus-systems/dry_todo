module Transactions
  def self.build namespace, name, traced: false, &block
    builder = Transactions::TransactionBuilder.new namespace, name, traced
    builder.build(&block)
    builder.transaction
  end
end
