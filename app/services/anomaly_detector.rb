class AnomalyDetector
  ZSCORE_THRESHOLD = 3.0

  def self.detect_anomaly(transaction)
    return [] unless transaction

    status = transaction['status']
    count = transaction['count'].to_i
    time = transaction['time']

    zscore = calculate_zscore(count, time)
    anomaly_threshold = calculate_anomaly_threshold(time)

    if zscore.abs > ZSCORE_THRESHOLD
      message = "Anomaly detected! #{status.capitalize} transaction has a high Z-score: #{zscore}."

      Alert.create!(time:, status:, message:)
    elsif transaction.count > anomaly_threshold
      message = "Anomaly detected! #{status.capitalize} transactions are #{transaction.count}, " \
      "which exceeds the expected threshold of #{anomaly_threshold}."

      Alert.create!(time:, status:, message:)
    else
      return 'Anomaly not detected.'
    end

    Alert.where(time:, status:)
  end

  private

  def self.calculate_anomaly_threshold(time)
    average_count = transaction_counts(time).sum / transaction_statuses_size(time)
    average_count
  end

  def self.calculate_zscore(count, time)
    mean = transaction_counts(time).sum / transaction_counts(time).size.to_f
    std_dev = Math.sqrt(transaction_counts(time).map { |x| (x - mean) ** 2 }.sum / transaction_statuses_size(time))

    (count - mean) / std_dev
  end

  def self.transaction_counts(time)
    Transaction.where(time: time).pluck(:count)
  end

  def self.transaction_statuses_size(time)
    Transaction.where(time: time).pluck(:status).uniq.size
  end
end
