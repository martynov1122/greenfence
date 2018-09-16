class AlertMailerJob < Struct.new(:user, :alert)
  def perform
     AlertMailer.alert_notification_email(user, alert).deliver
  	
  end
end
