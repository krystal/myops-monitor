require 'json'
require 'net/https'
require 'myops_monitor/error'

module MyOpsMonitor
  class Check

    def initialize
      response = MyOpsMonitor.client.meta.status
      if response.success?
        @status = response.data
      end
    rescue => e
      MyOpsMonitor.logger.error "#{e.class}: #{e.message}"
    end

    def ok?
      issues.empty?
    end

    def issues
      @issues ||= Array.new.tap do |a|

        if @status.nil?
          a << "Could not connect to the MyOps installation"
        else
          if unpolled['servers'] > 0
            a << "There are #{unpolled['servers']} unpolled servers"
          end

          if unpolled['switches'] > 0
            a << "There are #{unpolled['servers']} unpolled switches"
          end

          if stale_locks['switches'] > 0
            a << "There are #{stale_locks['servers']} servers with stale locks"
          end

          if stale_locks['switches'] > 0
            a << "There are #{stale_locks['servers']} switches with stale locks"
          end
        end
      end
    end

    def stale_locks
      @status['stale_locks'] || {}
    end

    def unpolled
      @status['unpolled'] || {}
    end

  end
end
