module Transactions
  class Errors
    attr_reader :errors, :prevent_rollback

    def initialize errors=[], prevent_rollback=false
      @errors = Array(errors)
      @prevent_rollback = prevent_rollback
    end

    def add additional
      errors.concat Array(additional)
      self
    end

    def merge other
      errors.concat other.errors
      @prevent_rollback = prevent_rollback || other.prevent_rollback
      self
    end

    def stop_rollback
      @prevent_rollback = true
      self
    end

    def any?
      errors.any?
    end
  end
end
