module Muxer
  # Multiplexer is the core class of Muxer that actually multiplexes
  # web requests. Multiplexer has a lists of Muxer::Requests that will
  # be executed and added to the completed or failed response when the
  # timeouts have been reached.
  class Multiplexer
    attr_reader :requests
    attr_writer :timeout
    # multiplexer = Multiplexer.new
    def initialize
      @requests = []
      @timeout = nil
    end

    # add_url builds a Request object and passes it to add_request
    #
    # m.add_url('https://www.google.com', {timeout: 3}) # gives a 3 second
    # timeout to a request to https://www.google.com
    def add_url(url, options = {})
      options.keys.each do |key|
        options[key.to_sym] = options.delete(key)
      end
      options = {timeout: nil, method: :get, params: {}, redirects: nil}.merge(options)
      timeout = 
      request = Request.new
      request.url = url
      options.each do |key, val|
        next unless request.respond_to? ("#{key}=".to_sym)
        request.send("#{key}=".to_sym, val) if val
      end
      add_request request
    end

    # add_request adds a request to Multiplexer
    #
    # request = Muxer::Request.new
    # request.url = 'https://www.google.com'
    # request.timeout = 3
    # m.add_request request

    # gives a 3 second timeout to a request to https://www.google.com
    def add_request(request)
      requests << request
    end

    # executes the actual event loop that manages creating, sending,
    # and processing the finished / timed out web requests
    def execute
      @responses = {succeeded: [], failed: [], pending: []}
      @start = Time.now
      EventMachine.run do
        requests.each do |request|
          @responses[:pending] << request.process!
        end

        EM::PeriodicTimer.new(0.001) do
          process_requests
        end
      end
      @responses
    end

    private

    def process_requests
      process_pending
      
      process_timeouts

      if @responses[:pending].empty?
        EM.stop
      end
    end

    def process_pending
      @responses[:pending].each do |pending|
        if pending.completed?
          @responses[:pending].delete(pending)
          if pending.error.nil?
            @responses[:succeeded] << pending
          else
            @responses[:failed] << pending
          end
        end
      end
    end

    def process_timeouts
      if @timeout && (@start + @timeout <= Time.now)
        finish_timeouts
        return
      end
      highest_remaining_timeout = @responses[:pending].map(&:timeout).max
      if highest_remaining_timeout && (@start + highest_remaining_timeout <= Time.now)
        finish_timeouts
      end
    end

    def finish_timeouts
      @responses[:pending].each do |pending|
        @responses[:failed] << pending
      end
      @responses[:pending] = []
      EM.stop
    end
  end
end