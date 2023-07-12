class AlertMailer < ApplicationMailer
  def send_alert(alerts)
    monitoring_team = ['email1@example.com', 'email2@example.com']

    mail(to: monitoring_team, subject: 'Anomaly Detection Alerts', body: alerts)
  end
end
