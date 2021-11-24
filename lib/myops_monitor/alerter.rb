require 'mail'
require 'erb'

module MyOpsMonitor
  class Alerter
    def initialize(check)
      @check = check
    end

    def send_alerts
      recipients.each do |recipient|
        MyOpsMonitor.logger.info "Sending alert to #{recipient}"
        send_alert(recipient)
      end
    end

    def send_alert(recipient)
      mail = Mail.new
      mail.to(recipient)
      mail.from(ENV.fetch('ALERT_FROM_ADDRESS', 'myops-monitor@example.com'))
      if @check.issue.nil?
        mail.subject("Everything with #{@check.hostname} is OK")
        mail.body "There are no further issues to report with your MyOps installation at #{@check.hostname}."
      else
        mail.subject("An issue has been detected with #{@check.hostname}")
        mail.body self.class.template.result(binding)
      end
      mail.delivery_method :smtp, self.class.smtp_config
      MyOpsMonitor.logger.info "Alert sent to #{recipient}" if mail.deliver
    end

    private

    def recipients
      env = ENV['ALERT_RECIPIENTS']
      env&.split(/, ?/) || []
    end

    class << self
      def template
        @template ||= ERB.new(File.read(File.expand_path('../../resource/email.erb', __dir__)), nil, '-')
      end

      def smtp_config
        {
          address: ENV.fetch('SMTP_HOST', 'localhost'),
          user_name: ENV['SMTP_USERNAME'],
          password: ENV['SMTP_PASSWORD']
        }
      end
    end
  end
end
