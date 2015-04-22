module Muxer
  # Muxer::Request is designed to wrap the requests that Muxer uses
  # to parallelize the web requests and handle timeouts.
  class Request
    attr_accessor :url, :timeout, :headers, :params, :redirects
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

      @request = http.public_send(method,
        request_options
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

    private

    def request_options
      options = {
        head: headers
      }
      if [:post, :put].include? method
        options[:body] = params
      else
        options[:query] = params
      end

      options[:redirects] = redirects
      options.reject!{|_,v| empty? v}
      options
    end

    def empty?(opt)
      (opt.nil? || opt == {} || opt == [] || opt == '')
    end
  end
end