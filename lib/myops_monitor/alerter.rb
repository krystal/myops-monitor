require 'mail'
require 'erb'

module MyOpsMonitor
  class Alerter

    def initialize(check)
      @check = check
      @host = MyOpsMonitor.config['myops']['host']
    end

    def send_alerts
      MyOpsMonitor.config['alerts']['recipients'].each do |recipient|
        send_alert(recipient)
      end
    end

    def send_alert(recipient)
      mail = Mail.new
      mail.to(recipient)
      mail.from(MyOpsMonitor.config['alerts']['from'])
      if @check.ok?
        mail.subject("Everything with #{@host} is OK")
        mail.body "There are no issues to report with your MyOps installation at #{@host}."
      else
        mail.subject("An issue has been detected with #{@host}")
        mail.body self.class.template.result(binding)
      end
      mail.delivery_method :smtp, MyOpsMonitor.config['smtp'].each_with_object({}) { |(k,v), h| h[k.to_sym] = v }
      if mail.deliver
        MyOpsMonitor.logger.info "Alert sent to #{recipient}"
      end
    end

    private

    def self.template
      @template ||= ERB.new(File.read(File.expand_path('../../../resource/email.erb', __FILE__)), nil, '-')
    end

  end
end
