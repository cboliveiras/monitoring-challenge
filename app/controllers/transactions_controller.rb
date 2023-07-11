require 'anomaly_detector'
require 'descriptive_statistics/safe'

class TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def transaction_data
    transactions = Transaction.where(time: params[:time])

    if transactions.any?
      data = {
        time: transactions.pluck(:time).first,
        data: {
          approved: transactions.where(status: 'approved').sum(:count),
          denied: transactions.where(status: 'denied').sum(:count),
          refunded: transactions.where(status: 'refunded').sum(:count),
          reversed: transactions.where(status: 'reversed').sum(:count),
          backend_reversed: transactions.where(status: 'backend_reversed').sum(:count),
          failed: transactions.where(status: 'failed').sum(:count),
          processing: transactions.where(status: 'processing').sum(:count)
        }
      }

      render json: data
    else
      render json: { error: 'Transaction not found' }, status: :not_found
    end
  end

  def monitoring
    @alerts = TransactionMonitor.check_alerts_by(params[:time])

    render :monitoring, locals: { alerts: @alerts }
  end

  def new_transaction
    time = params[:time]
    status = params[:status]

    transaction = TransactionSumService.sum_transactions_and_update(time, status)

    if transaction
      transaction.update!(count: (transaction.count || 0) + 1)
      alerts = AnomalyDetector.detect_anomaly(transaction)
    else
      transaction = Transaction.create!(time:, status:, count: 1)
      alerts = 'Anomaly not detected.'
    end

    render json: {
      time:,
      status:,
      count: transaction.count,
      alerts:
    }
  end
end

