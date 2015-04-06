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
        loop do
          EventMachine.next_tick do
            looping = false
          end
        end while looping
      end

      responses
    end
  end
end