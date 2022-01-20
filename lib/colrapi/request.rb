require_relative "faraday" # !! Potential ruby 3.0 difference in module loading? relative differs from Serrano
require "faraday_middleware"
require_relative "utils"

module Colrapi
  class Request
    attr_accessor :endpoint
    attr_accessor :q
    attr_accessor :verbose

    attr_accessor :options

    def initialize(endpoint, q, verbose)
      @endpoint = endpoint
      @verbose = verbose
      @q = q
      @options = options # TODO: not added at colrapi.rb
    end

    def perform
      args = { q: q}
      opts = args.delete_if { |_k, v| v.nil? }

      conn = if verbose
               Faraday.new(url: Colrapi.base_url, request: options || []) do |f|
                 f.response :logger
                 f.use FaradayMiddleware::RaiseHttpException
                 f.adapter Faraday.default_adapter
               end
             else
               Faraday.new(url: Colrapi.base_url, request: options || []) do |f|
                 f.use FaradayMiddleware::RaiseHttpException
                 f.adapter Faraday.default_adapter
               end
             end

      conn.headers[:user_agent] = make_user_agent
      conn.headers["X-USER-AGENT"] = make_user_agent

      res = conn.get endpoint, opts
      MultiJson.load(res.body)
    end
  end
end
