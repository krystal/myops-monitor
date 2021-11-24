require 'yaml'
require 'logger'

module MyOpsMonitor

  class << self

    def logger
      @logger ||= begin
        STDOUT.sync = true
        STDERR.sync = true
        Logger.new(STDOUT)
      end
    end

  end

end
