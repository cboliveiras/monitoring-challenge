class AlertMailer < ApplicationMailer
  def send_alert(message)
    mail(to: 'cboliveirasbr@gmail.com', subject: 'Anomaly Detection Alert', body: message)
  end
end
