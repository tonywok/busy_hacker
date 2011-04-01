class Mailer
  DEFAULT_FROM = '"Tony Schneider" <tonywok@gmail.com>'

  attr_accessor :conn

  def initialize
    self.conn = AWS::SES::Base.new(:access_key_id => Sinatra::Application.settings.ses_key_id,
                                   :secret_access_key => Sinatra::Application.settings.ses_secret)
  end

  def send(options = {})
    conn.send_email(:to => options[:to],
                    :source => options[:from] || DEFAULT_FROM,
                    :subject => options[:subject],
                    :text_body => options[:body])
  end

  def confirmation_msg_for(email)
    msg = <<-MESSAGE
      Hey there,

      To get the weekly top 10 hottest Hacker News articles emailed to you
      in a newsletter, please confirm your email by clicking the following link.

      http://localhost:9393/email_confirmation?token=#{email.confirm_token}
    MESSAGE
  end
end
