class AlertPresenter
  def self.generate_alerts_data
    range_of_time = Time.now.beginning_of_day..Time.now.end_of_day
    denied_alerts = alerts_by_status('denied', range_of_time)
    failed_alerts = alerts_by_status('failed', range_of_time)
    reversed_alerts = alerts_by_status('reversed', range_of_time)

    alerts = []

    (0..23).each do |i|
      hour = Time.now.beginning_of_day + i.hours
      range_of_hour = hour..hour.end_of_hour
      alerts << {
        time: "#{hour.strftime('%H')}h",
        denied: count_alerts(denied_alerts, range_of_hour),
        failed: count_alerts(failed_alerts, range_of_hour),
        reversed: count_alerts(reversed_alerts, range_of_hour)
      }
    end

    alerts
  end

  private

  def self.alerts_by_status(status, range_of_time)
    Alert.where(status: status, created_at: range_of_time).select { |alert| range_of_time.cover?(Time.parse(alert.time)) }
  end

  def self.count_alerts(alerts, range_of_time)
    alerts.select { |alert| range_of_time.cover?(Time.parse(alert.time)) }.count
  end
end
