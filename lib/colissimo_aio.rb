require 'colissimo/version'
require 'colissimo/configuration'
require 'deposit'
require 'label'
require 'tracking'
require 'relay_point'
require 'ostruct'
require 'savon'

module ColissimoAIO

  include Deposit
  include Label
  include Tracking
  include RelayPoint

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Error < StandardError
  end
end