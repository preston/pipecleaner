class Notifications < ActionMailer::Base
  # default from: "from@example.com"
  default from: ENV['EMAIL_SENDER']

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.status_change.subject
  #
  def status_change(notification, status)
    @notification = notification
    @status = status
    mail to: notification.user.email, subject: "#{ENV['EMAIL_PREFIX']}#{status.member.item.name}: #{status.stage.name} #{status.code}"
  end
end
