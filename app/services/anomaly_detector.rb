class AnomalyDetector
  def self.detect_anomaly(time, data)
    alerts = []
    total_transactions = Transaction.where(time:).pluck(:count).sum.to_f

    threshold = {
      'failed' => 4.0,
      'reversed' => 5.0,
      'denied' => 6.0
    }

    data.each do |status, count|
      next unless %w[failed reversed denied].include?(status)

      ratio = ((count.to_f / total_transactions) * 100).round(2)

      if ratio > threshold[status]
        alert_message = "Anomaly detected! #{status.capitalize} transactions are #{ratio}%, which exceeds a #{threshold[status]}% ratio."
        alerts << alert_message
        create_alert(time, status, alert_message)
      end
    end

    send_email(alerts)
    Alert.where(time: time) || []
  end

  private

  def self.send_email(alerts)
    AlertMailer.send_alert(alerts).deliver_now
  end

  def self.create_alert(time, status, message)
    Alert.create!(time: time, status: status, message: message)
  end
end

