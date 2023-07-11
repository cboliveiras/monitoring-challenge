class AnomalyDetector
  def self.detect_anomaly(time, data)
    total_transactions = Transaction.where(time:).pluck(:count).sum.to_f

    threshold = {
      'failed' => 5.0,
      'reversed' => 4.0,
      'denied' => 3.0
    }

    data.each do |status, count|
      next unless %w[failed reversed denied].include?(status)

      ratio = ((count.to_f / total_transactions) * 100).round(2)

      if ratio > threshold[status]
        alert_message = "Anomaly detected! #{status.capitalize} transactions are #{ratio}%, which exceeds a #{threshold[status]}% ratio."
        send_email(alert_message)
        create_alert(time, status, alert_message)
      end
    end

    Alert.where(time: time) || []
  end

  private

  def self.send_email(message)
    AlertMailer.send_alert(message).deliver_now
  end

  def self.create_alert(time, status, message)
    Alert.create!(time: time, status: status, message: message)
  end
end

