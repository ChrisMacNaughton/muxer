require 'eventmachine'
require 'em-http'

require 'muxer/version'
require 'muxer/request'
require 'muxer/multiplexer'

module Muxer
  def self.execute
    multiplexer = Multiplexer.new

    yield multiplexer if block_given?

    multiplexer.execute
  end
end
