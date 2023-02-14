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
      @name = args[:name]
      @authorship = args[:authorship]
      @code = args[:code]
      @type = args[:type]
      @rank = args[:rank]
      @min_rank = args[:min_rank]
      @max_rank = args[:max_rank]
      @dataset_id_filter = args[:dataset_id_filter]
      @short_title = args[:short_title]
      @private = args[:private]
      @released_from = args[:released_from]
      @contributes_to = args[:contributes_to]
      @has_source_dataset = args[:has_source_dataset]
      @has_gbif_id = args[:has_gbif_id]
      @gbif_id = args[:gbif_id]
      @gbif_publisher_id = args[:gbif_publisher_id]
      @editor = args[:editor]
      @reviewer = args[:reviewer]
      @modified_by = args[:modified_by]
      @origin = args[:origin]
      @license = args[:license]
      @row_type = args[:row_type]
      @created_after = args[:created_after]
      @created_before = args[:created_before]
      @issue = args[:issue]
      @term = args[:term]
      @term_operator = args[:term_operator]
      @issued = args[:issued]
      @issued_before = args[:issued]
      @modified_after =  args[:modified_after]
      @modified_before = args[:modified_before]
      @min_size = args[:min_size]
      @within_superkingdom = args[:within_superkingdom]
      @within_kingdom = args[:within_kingdom]
      @within_subkingdom = args[:within_subkingdom]
      @within_superphylum = args[:within_superphylum]
      @within_phylum = args[:within_phylum]
      @within_subphylum = args[:within_subphylum]
      @within_superclass = args[:within_superclass]
      @within_class = args[:within_class]
      @within_subclass = args[:within_subclass]
      @within_superorder = args[:within_superorder]
      @within_order = args[:within_order]
      @within_suborder = args[:within_suborder]
      @within_superfamily = args[:within_superfamily]
      @within_family = args[:within_family]
      @within_subfamily = args[:within_subfamily]
      @within_tribe = args[:within_tribe]
      @within_subtribe = args[:within_subtribe]
      @within_genus = args[:within_genus]
      @within_subgenus = args[:within_subgenus]
      @within_section = args[:within_section]
      @within_species = args[:within_species]
      @nidx_id = args[:nidx_id]
      @sort_by = args[:sort_by]
      @reverse = args[:reverse]
      @limit = args[:limit]
      @offset = args[:offset]
      @state = args[:state]
      @running = args[:running]
      @user = args[:user]
      @password = args[:password]
      @token = args[:token]
      @options = args[:options] # TODO: not added at colrapi.rb
    end

    def perform
      args = { q: @q, content: @content, name: @name, authorship: @authorship, code: @code, type: @type,
               rank: @rank, minRank: @min_rank, maxRank: @max_rank, term: @term, term_operator: @term_operator,
               alias: @short_title, private: @private, releasedFrom: @released_from, contributesTo: @contributes_to,
               hasSourceDataset: @has_source_dataset, hasGbifKey: @has_gbif_id, gbifKey: @gbif_id,
               gbifPublisherKey: @gbif_publisher_id, editor: @editor, reviewer: @reviewer, modifiedBy: @modified_by,
               origin: @origin, license: @license, rowType: @row_type, created: @created_after,
               createdBefore: @created_before, issued: @issued, issuedBefore: @issued_before, modified: @modified_after,
               modifiedBefore: @modified_before, minSize: @min_size, issue: @issue, datasetKey: @dataset_id_filter,
               superkingdom: @within_superkingdom, kingdom: @within_kingdom, subkingdom: @within_subkingdom,
               superphylum: @within_superphylum, phylum: @within_phylum,
               subphylum: @within_subphylum, superclass: @within_superclass, class: @within_class,
               subclass: @within_subclass, superorder: @within_superorder, order: @within_order,
               suborder: @within_suborder, superfamily: @within_superfamily,
               family: @within_family, subfamily: @within_subfamily,
               tribe: @within_tribe, subtribe: @within_subtribe, genus: @within_genus,
               subgenus: @within_subgenus, section: @within_section, species: @within_species,
               nidx: @nidx_id, state: @state, running: @running,
               sortBy: @sort_by, reverse: @reverse, offset: @offset, limit: @limit}
      opts = args.delete_if { |_k, v| v.nil? }

      conn = if verbose
               Faraday.new(url: Colrapi.base_url, request: options || []) do |f|
                 if !@user.nil? and !@password.nil?
                   f.request(:basic_auth, @user, @password)
                 end
                 f.response :logger
                 f.use FaradayMiddleware::RaiseHttpException
                 f.adapter Faraday.default_adapter
               end
             else
               Faraday.new(url: Colrapi.base_url, request: options || []) do |f|
                 if !@user.nil? and !@password.nil?
                   f.request(:basic_auth, @user, @password)
                 end
                 f.use FaradayMiddleware::RaiseHttpException
                 f.adapter Faraday.default_adapter
               end
             end

      conn.headers['Authorization'] = "Bearer #{@token}" unless @token.nil?
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
