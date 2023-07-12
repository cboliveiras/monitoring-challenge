class TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def alerts
    range_of_time = Time.now.beginning_of_day..Time.now.end_of_day
    denied_alerts = Alert.where(status: 'denied', created_at: range_of_time)
    failed_alerts = Alert.where(status: 'failed', created_at: range_of_time)
    reversed_alerts = Alert.where(status: 'reversed', created_at: range_of_time)
    alerts = []

    (0..23).each do |i|
      hour = Time.now.beginning_of_day + i.hours
      alerts << {
        time: "#{hour.strftime('%H')}h",
        denied: denied_alerts.where(created_at: hour..hour.end_of_hour).count,
        failed: failed_alerts.where(created_at: hour..hour.end_of_hour).count,
        reversed: reversed_alerts.where(created_at: hour..hour.end_of_hour).count
      }
    end

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

