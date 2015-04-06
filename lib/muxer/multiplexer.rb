module Muxer
  class Multiplexer

    def initialize
      @requests = []
    end

    def add_url(url)
      @requests << Request.new do
        url = url
      end
    end

    def execute
      responses = []
      looping = true
      EventMachine.run do
        EM.stop
      end

      responses
    end
  end
end