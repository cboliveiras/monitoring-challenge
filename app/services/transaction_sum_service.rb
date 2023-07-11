class TransactionSumService
  def self.sum_transactions_and_update(time, status)
    transactions = Transaction.where(time: time, status: status)

    return nil if transactions.empty?

    total_count = transactions.sum(:count)
    first_transaction = transactions.first
    first_transaction.update!(count: total_count)

    transactions.offset(1).destroy_all

    first_transaction
  end
end
