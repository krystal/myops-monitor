require 'json'
require 'net/https'
require 'myops_monitor/error'

module MyOpsMonitor
  class Check
    attr_reader :state, :issue, :connection_error, :not_ok_http_status

    def initialize
      load_state
      determine_issue
    end

    def stale_servers
      @state.dig('servers', 'stale') || 0
    end

    def hostname
      return ENV['MYOPS_HOST'] if @state.nil?

      @state.dig('hostname')
    end

    private

    def load_state
      http = Net::HTTP.new(ENV['MYOPS_HOST'], 443)
      http.use_ssl = true

      request = Net::HTTP::Get.new('/state')
      response = http.request(request)
      if response.is_a?(Net::HTTPOK)
        @state = JSON.parse(response.body)
        return true
      end

      @not_ok_http_status = response.status
      false
    rescue StandardError => e
      @connection_error = e
      false
    end

    def determine_issue
      if @connection_error
        @issue = :connection_error
        return
      end

      if @not_ok_http_status
        @issue = :invalid_http_response
        return
      end

      if stale_servers.positive?
        @issue = :stale_servers
        nil
      end
    end
  end
end
