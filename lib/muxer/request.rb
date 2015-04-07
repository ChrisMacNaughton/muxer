module Muxer
  class Request
    attr_accessor :url, :timeout, :headers
    attr_reader :method, :completed, :error

    alias_method  :completed?, :completed
    def initialize
      @method = :get
      @completed = false
      @timeout = 10
      @headers = {}
      @request = nil
      @error = nil
    end

    def method=(method)
      method = method.downcase.to_sym

      @method = method if [:get, :post, :head, :options, :put, :delete].include? method
    end

    def process!
      http = EventMachine::HttpRequest.new(url,
        connect_timeout: timeout,
        inactivity_timeout: timeout,
      )
      @request = http.public_send(method,
        head: headers,
      )

      @request.callback { @completed = true }
      @request.errback { @completed = @error = true}
      self
    end

    def response
      @request.response
    end
  end
end