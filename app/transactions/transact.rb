class Transact
  def initialize transaction, input
    @transaction = transaction
    @input = input
  end

  def self.call transaction, input
    new(transaction, input).call
  end

  def call
    result = Left Transactions::Errors.new 'An unexpected error occured'
    ActiveRecord::Base.transaction do
      result = transaction.call input
      raise ActiveRecord::Rollback if result.failure? && !result.value.prevent_rollback
    end
    result
  rescue StandardError => e
    unless Rails.env.production?
      pp e.message
      pp e.backtrace
    end
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.inspect
    result
  end

  private

  attr_reader :transaction, :input

end
