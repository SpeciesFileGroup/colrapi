require_relative "faraday"
require "faraday/follow_redirects"
require_relative "utils"
require "colrapi/error"

module Colrapi
  class Request
    attr_accessor :endpoint, :q, :verbose, :options

    def initialize(**args)
      @endpoint = args[:endpoint]
      @verbose = args[:verbose]
      @url = args[:url]
      @q = Array(args[:q]) if args[:q]
      @id = args[:id]
      @attempt = args[:attempt]
      @format = args[:format]
      @regexp = args[:regexp]
      @content = Array(args[:content]) if args[:content]
      @name = args[:name]
      @authorship = Array(args[:authorship]) if args[:authorship]
      @authorship_year = Array(args[:authorship_year]) if args[:authorship_year]
      @code = Array(args[:code]) if args[:code]
      @nomenclatural_code = Array(args[:nomenclatural_code]) if args[:nomenclatural_code]  # unfortunately code and nom_code get used on different endpoints
      @field = Array(args[:field]) if args[:field]
      @type = Array(args[:type]) if args[:type]
      @rank = Array(args[:rank]) if args[:rank]
      @facet = Array(args[:facet]) if args[:facet]
      @extinct = Array(args[:extinct]) if args[:extinct]
      @min_rank = args[:min_rank]
      @max_rank = args[:max_rank]
      @environment = Array(args[:environment]) if args[:environment]
      @highest_taxon_id = args[:highest_taxon_id]
      @usage_id = args[:usage_id]
      @parent_rank = args[:parent_rank]
      @root_id = Array(args[:root_id]) if args[:root_id]
      @root2_id = Array(args[:root2_id]) if args[:root2_id]
      @include_parent = args[:include_parent]
      @include_synonyms = args[:include_synonyms]
      @dataset_id_filter = args[:dataset_id_filter]
      @project_id = args[:project_id]
      @short_title = args[:short_title]
      @private = args[:private]
      @released_from = args[:released_from]
      @contributes_to = args[:contributes_to]
      @has_source_dataset = args[:has_source_dataset]
      @has_gbif_id = args[:has_gbif_id]
      @gbif_id = args[:gbif_id]
      @gbif_publisher_id = args[:gbif_publisher_id]
      @taxonomic_group = Array(args[:taxonomic_group]) if args[:taxonomic_group]
      @editor = args[:editor]
      @reviewer = args[:reviewer]
      @modified_by = args[:modified_by]
      @origin = Array(args[:origin]) if args[:origin]
      @original = args[:original]
      @not_current_only = args[:not_current_only]
      @license = Array(args[:license]) if args[:license]
      @row_type = Array(args[:row_type]) if args[:row_type]
      @created_after = args[:created_after]
      @created_before = args[:created_before]
      @issue = Array(args[:issue]) if args[:issue]
      @term = Array(args[:term]) if args[:term]
      @term_operator = args[:term_operator]
      @issued = args[:issued]
      @issued_before = args[:issued]
      @modified_after = args[:modified_after]
      @modified_before = args[:modified_before]
      @last_synced_before = args[:last_synced_before]
      @min = args[:min]
      @max = args[:max]
      @min_size = args[:min_size]
      @name_type = Array(args[:name_type]) if args[:name_type]
      @nomenclatural_status = Array(args[:nomenclatural_status]) if args[:nomenclatural_status]
      @status = Array(args[:status]) if args[:status]
      @sector_mode = Array(args[:sector_mode]) if args[:sector_mode]
      @sector_dataset_id = Array(args[:sector_dataset_id]) if args[:sector_dataset_id]
      @secondary_source = Array(args[:secondary_source]) if args[:secondary_source]
      @size = args[:size]
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
      @without_data = args[:without_data]
      @broken = args[:broken]
      @subject_dataset_id = args[:subject_dataset_id]
      @mode = args[:mode]
      @decision_mode = args[:decision_mode]
      @subject = args[:subject]
      @nidx_id = args[:nidx_id]
      @sort_by = args[:sort_by]
      @reverse = args[:reverse]
      @limit = args[:limit]
      @offset = args[:offset]
      @status = args[:status]
      @state = Array(args[:state]) if args[:state]
      @running = args[:running]
      @user = args[:user]
      @password = args[:password]
      @token = args[:token]
      @options = args[:options] # TODO: not added at colrapi.rb
    end

    def perform

      args = { q: @q, regex: @regexp, attempt: @attempt, content: @content, name: @name, authorship: @authorship, 
               authorshipYear: @authorship_year, code: @code, nomCode: @nomenclatural_code, field: @field, extinct: @extinct, type: @type,
               rank: @rank, minRank: @min_rank, maxRank: @max_rank, parentRank: @parent_rank, projectKey: @project_id,
               term: @term, termOp: @term_operator, status: @status, decisionMode: @decision_mode,
               alias: @short_title, private: @private, releasedFrom: @released_from, contributesTo: @contributes_to,
               hasSourceDataset: @has_source_dataset, hasGbifKey: @has_gbif_id, group: @taxonomic_group, gbifKey: @gbif_id,
               gbifPublisherKey: @gbif_publisher_id, editor: @editor, reviewer: @reviewer, modifiedBy: @modified_by,
               id: @id, format: @format, root: @root_id, root2: @root2_id, synonyms: @include_synonyms,
               showParent: @include_parent, origin: @origin, original: @original, license: @license, rowType: @row_type,
               created: @created_after, createdBefore: @created_before, issued: @issued, issuedBefore: @issued_before,
               modified: @modified_after, modifiedBefore: @modified_before, lastSync: @last_synced_before,
               status: @status, nomStatus: @nomenclatural_status, nameType: @name_type,
               sectorMode: @sector_mode, sectorDatasetKey: @sector_dataset_id, secondarySourceGroup: @secondary_source,
               minSize: @min_size, size: @size, issue: @issue, min: @min, max: @max, datasetKey: @dataset_id_filter,
               withoutData: @without_data, superkingdom: @within_superkingdom, kingdom: @within_kingdom,
               subkingdom: @within_subkingdom, superphylum: @within_superphylum, phylum: @within_phylum,
               subphylum: @within_subphylum, superclass: @within_superclass, class: @within_class,
               subclass: @within_subclass, superorder: @within_superorder, order: @within_order,
               suborder: @within_suborder, superfamily: @within_superfamily,
               family: @within_family, subfamily: @within_subfamily,
               tribe: @within_tribe, subtribe: @within_subtribe, genus: @within_genus,
               subgenus: @within_subgenus, section: @within_section, species: @within_species,
               nidx: @nidx_id, state: @state, running: @running, notCurrentOnly: @not_current_only,
               broken: @broken, subjectDatasetKey: @subject_dataset_id, mode: @mode, subject: @subject,
               TAXON_ID: @highest_taxon_id, USAGE_ID: @usage_id, environment: @environment,
               sortBy: @sort_by, reverse: @reverse, url: @url, body: @body, offset: @offset, limit: @limit }
      opts = args.delete_if { |_k, v| v.nil? }

      conn = Faraday.new(url: Colrapi.base_url, request: { params_encoder: Faraday::FlatParamsEncoder }) do |f|
        f.request :authorization, :basic, @user, @password if @user && @password
        f.response :logger if @verbose
        f.use Faraday::ColrapiErrors::Middleware
        f.adapter Faraday.default_adapter
      end

      conn.headers['Authorization'] = "Bearer #{@token}" if @token
      conn.headers['Accept'] = 'application/json,*/*'
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
