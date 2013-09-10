class AdminMailer < ActionMailer::Base

  default from: ENV['EMAIL_SENDER']

  def new_user_waiting_for_approval(user)
    @user = user

    # FIXME Admin notify list instead.
    mail(:to => ENV['ADMIN_REQUIRED_EMAIL'], :subject => "New user awaiting approval")
  end

  def deny_application(user)
    @user = user
    mail(:to => @user.email, :subject => "Application denied")
  end
end