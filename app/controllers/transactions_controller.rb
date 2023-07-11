class TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def alerts
    alerts = Alert.where(time: params[:time])

    if alerts.any?
      data = {
        time: params[:time],
        alerts: alerts.pluck(:message)
      }

      render json: data
    else
      render json: { message: 'No alerts found at this time' }, status: :not_found
    end
  end

  def monitoring
    @alerts = Alert.where(time: params[:time])

    render :monitoring, locals: { alerts: @alerts }
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

