class TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def alerts
    alerts = AlertPresenter.generate_alerts_data
    render json: alerts
  end

  def alert_monitoring
    render file: 'public/js/alert_monitoring.html', layout: false
  end

  def new_transaction
    time = params[:time]
    data = params[:data]

    data.each do |status, count|
      transaction = TransactionSumService.sum_transactions_and_update(time, status)

      if transaction.present?
        transaction.update(count: transaction.count + count)
      else
        Transaction.create!(time: time, status: status, count: count)
      end
    end

    alerts = AnomalyDetector.detect_anomaly(time, data)

    render json: { time:, alerts: alerts.pluck(:message) }, status: :ok
  end
end

