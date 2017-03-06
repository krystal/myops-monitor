require 'yaml'
require 'logger'
require 'moonrope_client'

module MyOpsMonitor

  def self.logger
    @logger ||= begin
      STDOUT.sync = true
      STDERR.sync = true
      Logger.new(STDOUT)
    end
  end

  def self.config
    @config ||= begin
      if File.file?(self.config_path)
        config = YAML.load_file(self.config_path)
        logger.info "Configuration loaded from #{self.config_path}"
        config
      else
        raise Error, "Config file not found at #{self.config_path}"
      end
    end
  end

  def self.config_path
    ENV['MYOPS_MONITOR_CONFIG'] || File.expand_path("../../../config.yml", __FILE__)
  end

  def self.client
    @client ||= begin
      headers = {'X-Auth-Token' => config['myops']['api_key']}
      MoonropeClient::Connection.new(config['myops']['host'], :headers => headers, :port => config['myops']['port'], :ssl => config['myops']['ssl'])
    end
  end

end
