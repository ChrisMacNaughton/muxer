module Muxer
  class Request
    attr_accessor :url, :timeout, :headers, :params
    attr_reader :method, :completed, :error

    alias_method  :completed?, :completed
    def initialize
      @method = :get
      @completed = false
      @timeout = 10
      @headers = {}
      @params = {}
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
      options = {
        head: headers
      }
      if [:post, :put].include? method
        options[:body] = params
      else
        options[:query] = params
      end
      @request = http.public_send(method,
        options
      )

      @request.callback { @completed = true }
      @request.errback { @completed = @error = true}
      self
    end

    def response
      if @request
        @request.response
      end
    end
  end
end