require_relative "faraday" # !! Potential ruby 3.0 difference in module loading? relative differs from Serrano
require "faraday_middleware"
require_relative "utils"

module Colrapi
  class Request
    attr_accessor :endpoint
    attr_accessor :q
    attr_accessor :verbose

    attr_accessor :options

    def initialize(**args)
      @endpoint = args[:endpoint]
      @verbose = args[:verbose]
      @q = args[:q]
      @content = args[:content]
      @type = args[:type]
      @rank = args[:rank]
      @min_rank = args[:min_rank]
      @max_rank = args[:max_rank]
      @sort_by = args[:sort_by]
      @limit = args[:limit]
      @offset = args[:offset]
      @options = args[:options] # TODO: not added at colrapi.rb
    end

    def perform
      args = { q: @q, content: @content, type: @type, offset: @offset,
               rank: @rank, minRank: @min_rank, maxRank: @max_rank, sortBy: @sort_by, limit: @limit }
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

      # Handles ChecklistBank endpoints that do not return JSON
      begin
        MultiJson.load(res.body)
      rescue MultiJson::ParseError
        res.body
      end
      
    end
  end
end
