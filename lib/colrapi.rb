# frozen_string_literal: true

require "erb"
require_relative "colrapi/version"
require_relative "colrapi/request"
require "colrapi/helpers/configuration"

module Colrapi
  extend Configuration

  define_setting :base_url, "https://api.checklistbank.org/"
  define_setting :mailto, ENV["COL_API_EMAIL"]

  # Get dataset metadata
  #
  # For a specific dataset:
  #  @param dataset_id [String] The dataset id
  #  @param attempt [Integer] Returns archived metadata for a past import attempt number
  #
  # Search datasets:
  #   @param q [String] A search query for datasets
  #   @param short_title [String] A dataset alias
  #   @param code [String] The nomenclatural code (bacterial, botanical, cultivars, phytosociological, virus, zoological)
  #   @param private [Boolean] Whether the dataset is private or not
  #   @param released_from [Integer] Filter by a project id that a dataset was released from
  #   @param contributes_to [Integer] Filter by a project id that a dataset contributes to
  #   @param has_source_dataset [Boolean] Filter by if source datasets contribute to the project dataset
  #   @param has_gbif_id [Boolean] Whether the dataset has a GBIF registry id
  #   @param gbif_id [String] The GBIF registry id
  #   @param gbif_publisher_id [String] Filter by a GBIF publisher's id
  #   @param editor [Integer] Filter by an editor's user id
  #   @param reviewer [Integer] Filter by a reviewer's user id
  #   @param modified_by [Integer] Filter by a user id  on last modified by
  #   @param origin [Array, String] Filter by the origin of a dataset (external, project, release, xrelease)
  #   @param type [Array, String] Filter by the dataset type (nomenclatural, taxonomic, phylogenetic, article, legal, thematic, other)
  #   @param license [Array, String] Filter by the license type (cc0, cc_by, cc_by_sa, cc_by_nc, cc_by_nd, cc_by_nc_sa, cc_by_nc_nd, unspecified, other)
  #   @param row_type [Array, String] Filter by datasets that include a row type (e.g., acef:AcceptedSpecies, col:Taxon, dwc:Taxon)
  #   @param created_after [Date] Filter by created after date
  #   @param created_before [Date] Filter by created before date
  #   @param issued_after [Date] Filter by issued after date
  #   @param issued_before [Date] Filter by issued before date
  #   @param modified_after [Date] Filter by modified after date
  #   @param modified_before [Date] Filter by modified before date
  #   @param min_size [Integer] Filter by minimum record size
  #
  #   @param sort_by [String] Sort by (key, alias, title, creator, relevance, created, modified, imported, size)
  #   @param reverse [Boolean] Sort in reverse
  #   @param offset [Integer] Offset for pagination
  #   @param limit [Integer] Limit for pagination
  #   @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.dataset(dataset_id: nil, attempt: nil, q: nil, short_title: nil, code: nil, private: nil, released_from: nil,
                   contributes_to: nil, has_source_dataset: nil, has_gbif_id: nil, gbif_id: nil, gbif_publisher_id: nil,
                   editor: nil, reviewer: nil, modified_by: nil, origin: nil, type: nil, license: nil, row_type: nil,
                   created_after: nil, created_before: nil, issued_after: nil, issued_before: nil, modified_after: nil,
                   modified_before: nil, min_size: nil, sort_by: nil, reverse: nil, offset: nil, limit: nil,
                   verbose: false)
    endpoint = "dataset"
    unless dataset_id.nil?
      endpoint = "#{endpoint}/#{dataset_id}"
      unless attempt.nil?
        endpoint = "#{endpoint}/#{attempt}"
      end
      endpoint = "#{endpoint}.json"
      Request.new(endpoint: endpoint, verbose: verbose).perform
    else
      Request.new(endpoint: endpoint, q: q, short_title: short_title, code: code, private: private,
                  released_from: released_from, contributes_to: contributes_to, has_source_dataset: has_source_dataset,
                  has_gbif_id: has_gbif_id, gbif_id: gbif_id, gbif_publisher_id: gbif_publisher_id, editor: editor,
                  reviewer: reviewer, modified_by: modified_by, origin: origin, type: type, license: license,
                  row_type: row_type, created_after: created_after, created_before: created_before,
                  issued_after: issued_after, issued_before: issued_before, modified_after: modified_after,
                  modified_before: modified_before, min_size: min_size, sort_by: sort_by, reverse: reverse,
                  offset: offset, limit: limit, verbose: verbose).perform
    end
  end

  # Get project decisions
  #
  # @param dataset_id [String] The dataset id
  # @param decision_id [Integer, nil] The decision id
  # @param name [String, nil] The scientific name to match
  # @param rank [String, nil] The rank of the scientific name
  # @param modified_by [Integer, nil] Filter by a user id  on last modified by
  # @param broken [Boolean, nil] Whether the decision is broken or not
  # @param subject_dataset_id [String, nil] The source dataset id
  # @param mode [String, nil] The type of decision (block, reviewed, update, update_recursive, ignore)
  # @param subject [Boolean, nil] TODO: what does this do? All decisions with subject=true are bare names, so maybe it checks if the subject taxon exists?
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Hash, Boolean] A result hash
  def self.decision(dataset_id, decision_id: nil, name: nil, rank: nil, modified_by: nil, broken: nil,
                    subject_dataset_id: nil, mode: nil, subject: nil, offset: nil, limit: nil, verbose: false)
    if decision_id.nil?
      endpoint = "dataset/#{dataset_id}/decision"
      Request.new(endpoint: endpoint, name: name, rank: rank, modified_by: modified_by, broken: broken,
                  subject_dataset_id: subject_dataset_id, mode: mode, subject: subject, offset: offset,
                  limit: limit, verbose: verbose).perform
    else
      endpoint = "dataset/#{dataset_id}/decision/#{decision_id}"
      Request.new(endpoint: endpoint, verbose: verbose).perform
    end
  end

  # Get duplicate names
  #
  # @param dataset_id [String] The dataset id
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  def self.duplicate(dataset_id, offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/duplicate"
    Request.new(endpoint: endpoint, offset: offset, limit: limit, verbose: verbose).perform
  end

  # Get names diff between 2 datasets
  #
  # @param dataset_id [String] The first dataset id
  # @param dataset2_id [String] The second dataset id
  # @param root_id [Array, String, nil] The root taxon for the first dataset
  # @param root2_id [Array, String, nil] The root taxon for the second dataset
  # @param min_rank [String, nil] The minimum taxonomic rank
  # @param authorship [Boolean, nil] Include authorship
  # @param include_synonyms [Boolean, nil] Include synonyms
  # @param include_parent [Boolean, nil] Include parent
  # @param parent_rank [String, nil] Filter by parent rank
  # @param token [String, nil] An authentication token from Colrapi.user_login()
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [String] A text diff of names
  def self.diff(dataset_id, dataset2_id, root_id: nil, root2_id: nil, min_rank: nil,
                authorship: nil, include_synonyms: nil, include_parent: nil, parent_rank: nil,
                offset: nil, limit: nil, token: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/diff/#{dataset2_id}"
    Request.new(endpoint: endpoint, root_id: root_id, root2_id: root2_id, min_rank: min_rank,
                authorship: authorship, include_synonyms: include_synonyms,
                include_parent: include_parent, parent_rank: parent_rank,
                offset: offset, limit: limit, token: token, verbose: verbose).perform
  end

  # Get editor info
  #
  # @param dataset_id [String] The dataset id
  # @param token [String, nil] The authentication token from retrieved with Colrapi.user_login(user, password)
  #
  # # @return [Array, Hash, Boolean] An array of hashes
  def self.editor(dataset_id, token, verbose: false)
    endpoint = "dataset/#{dataset_id}/editor"
    Request.new(endpoint: endpoint, token: token, verbose: verbose).perform
  end

  # Get estimates
  # @param dataset_id [String] The dataset id
  # @param estimate_id [Integer, nil] The estimate ID
  # @param name [String] The scientific name
  # @param rank [String, nil] taxonomic rank
  # @param modified_by [Integer, nil] Filter by a user id  on last modified by
  # @param broken [Boolean, nil] Whether the estimate is broken or not
  # @param min [Integer, nil] Filter by the minimum estimate
  # @param max [Integer, nil] Filter by the maximum estimate
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Hash, Boolean] A results hash
  def self.estimate(dataset_id, estimate_id: nil, name: nil, rank: nil, modified_by: nil, broken: nil, min: nil,
                    max: nil, offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/estimate"
    if estimate_id.nil?
      Request.new(endpoint: endpoint, name: name, rank: rank, modified_by: modified_by, broken: broken,
                  min: min, max: max, offset: offset, limit: limit, verbose: verbose).perform
    else
      endpoint = "dataset/#{dataset_id}/estimate/#{estimate_id}"
      Request.new(endpoint: endpoint, verbose: verbose).perform
    end
  end

  # Get data quality issues
  #
  # @param dataset_id [String] The dataset id
  # @param issue [String] Filter by data quality issue (e.g., ACCEPTED_NAME_MISSING, DUPLICATE_NAME, URL_INVALID)
  # @param mode [String] Verbatim (default) or interpreted
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Hash, Boolean] An array of hashes
  def self.issues(dataset_id, issue: nil, mode: 'verbatim', offset: nil, limit: nil, verbose: false)
    if issue.nil?
      metrics = Request.new(endpoint: "/dataset/#{dataset_id}/import?state=finished").perform
      return {"issuesCount" => metrics[0]['issuesCount']}
    else
      if mode == 'interpreted'
        issues = self.vocab(term: 'issue')
        record_type = 'any'
        issues.each do |i|
          if i['name'] == issue.downcase
            record_type = i['group']
          end
        end

        # TODO: so far issues are only filterable on nameusage/search and /reference
        #   for other record_types, may need to add other endpoints in the future
        if record_type == 'reference'
          self.reference(dataset_id, issue: issue, offset: offset, limit: limit, verbose: verbose)
        else
          self.nameusage_search(dataset_id: dataset_id, issue: issue, facet: 'issue', offset: offset, limit: limit,
                              verbose: verbose)
        end
      else
        self.verbatim(dataset_id, issue: issue, offset: offset, limit: limit, verbose: verbose)
      end
    end
  end

  # Get importer status
  #
  # @param dataset_id [String] Calls the dataset_id endpoint /importer/{dataset_id}
  # @param dataset_id_filter [String] Filters the importer queue by dataset_id
  # @param state [String] The import status (e.g., waiting, preparing, downloading, processing, inserting, ...)
  # @param running [Boolean] Filter by actively importing datasets
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.importer(dataset_id: nil, dataset_id_filter: nil, state: nil, running: nil, offset: nil, limit: nil,
                    verbose: false)
    endpoint = "importer"
    if dataset_id.nil?
      Request.new(endpoint: endpoint, dataset_id_filter: dataset_id_filter, state: state, running: running,
                  offset: offset, limit: limit, verbose: verbose).perform
    else
      endpoint = "#{endpoint}/#{dataset_id}"
      Request.new(endpoint: endpoint, verbose: verbose).perform
    end
  end

  # Get names or a name from a dataset
  #
  # @param dataset_id [String] The dataset id
  # @param name [String] The scientific name to match
  # @param authorship [String] The authorship string for the scientific name
  # @param code [String] The nomenclatural code (bacterial, botanical, cultivars, phytosociological, virus, zoological)
  # @param rank [String] The rank of the scientific name
  # @param within_superkingdom [String] Restricts query to within a superkingdom
  # @param within_kingdom [String] Restricts query to within a kingdom
  # @param within_subkingdom [String] Restricts query to within a subkingdom
  # @param within_superphylum [String] Restricts query to within a superphylum
  # @param within_phylum [String] Restricts query to within a phylum
  # @param within_subphylum [String] Restricts query to within a subphylum
  # @param within_superclass [String] Restricts query to within a superclass
  # @param within_class [String] Restricts query to within a class
  # @param within_subclass [String] Restricts query to within a subclass
  # @param within_superorder [String] Restricts query to within a superorder
  # @param within_order [String] Restricts query to within a order
  # @param within_suborder [String] Restricts query to within a suborder
  # @param within_superfamily [String] Restricts query to within a superfamily
  # @param within_family [String] Restricts query to within a family
  # @param within_subfamily [String] Restricts query to within a subfamily
  # @param within_tribe [String] Restricts query to within a tribe
  # @param within_subtribe [String] Restricts query to within a subtribe
  # @param within_genus [String] Restricts query to within a genus
  # @param within_subgenus [String] Restricts query to within a subgenus
  # @param within_section [String] Restricts query to within a section
  # @param within_species [String] Restricts query to within a species
  #
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  # def self.matching(dataset_id, name: nil, authorship: nil, code: nil, rank: nil, within_superkingdom: nil,
  #                   within_kingdom: nil, within_subkingdom: nil, within_superphylum: nil, within_phylum: nil,
  #                   within_subphylum: nil, within_superclass: nil, within_class: nil, within_subclass: nil,
  #                   within_superorder: nil, within_order: nil, within_suborder: nil, within_superfamily: nil,
  #                   within_family: nil, within_subfamily: nil, within_tribe: nil, within_subtribe: nil,
  #                   within_genus: nil, within_subgenus: nil, within_section: nil, within_species: nil,
  #                   verbose: false)
  #   endpoint = "dataset/#{dataset_id}/matching"
  #   Request.new(endpoint: endpoint, name: name, authorship: authorship, code: code, rank: rank,
  #               within_superkingdom: within_superkingdom, within_kingdom: within_kingdom,
  #               within_subkingdom: within_subkingdom, within_superphylum: within_superphylum,
  #               within_phylum: within_phylum, within_subphylum: within_subphylum, within_superclass: within_superclass,
  #               within_class: within_class, within_subclass: within_subclass, within_superorder: within_superorder,
  #               within_order: within_order, within_suborder: within_suborder, within_superfamily: within_superfamily,
  #               within_family: within_family, within_subfamily: within_subfamily, within_tribe: within_tribe,
  #               within_subtribe: within_subtribe, within_genus: within_genus, within_subgenus: within_subgenus,
  #               within_section: within_section, within_species: within_species, verbose: verbose).perform
  # end

  # Get metrics for the *last successful* import of a dataset or a specific import_attempt
  #
  # @param dataset_id [String] The dataset id
  # @param import_attempt [Integer] The import attempt
  #
  # @return [Array, Hash, Boolean] An array of hashes
  def self.metrics(dataset_id, import_attempt: nil, verbose: false)

    import = self.importer(dataset_id: dataset_id)
    unless %w[unchanged finished].include? import['state']
      return {"code" => 400, 'message' => 'Dataset has not finished importing or failed to import'}
    end

    # it's necessary to get the last finished import attempt because status=unchanged import results don't have metrics
    #   project release datasets do not seem to have import_attempts or should be taken from the project dataset, e.g.:
    #     https://api.checklistbank.org/dataset/3/import/107 == https://api.checklistbank.org/dataset/9837/import
    if import_attempt.nil?
      import = self.importer(dataset_id_filter: dataset_id, state: 'finished')
      if import['total'] > 0
        import_attempt = import['result'][0]['attempt']
      end
    end

    endpoint = "dataset/#{dataset_id}/import"
    if !import_attempt.nil?
      endpoint = "#{endpoint}/#{import_attempt}"
      Request.new(endpoint: endpoint, verbose: verbose).perform
    else
      # /dataset/{id}/import returns an array of 1 item while /dataset/{id}/import/{attempt} doesn't
      res = Request.new(endpoint: endpoint, verbose: verbose).perform
      res[0]
    end
  end

  # Get names or a name from a dataset
  #
  # @param dataset_id [String] The dataset id
  # @param name_id [String] The name id
  # @param subresource [String] The name subresource endpoint (relations, synonyms, types, or orphans)
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.name(dataset_id, name_id: nil, subresource: nil, offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/name"
    unless name_id.nil?
      endpoint = "#{endpoint}/#{name_id}"
      offset = nil
      limit = nil
    end
    if !subresource.nil? and %w[relations synonyms types orphans].include? subresource
      endpoint = "#{endpoint}/#{subresource}"
    end
    Request.new(endpoint: endpoint, offset: offset, limit: limit, verbose: verbose).perform
  end

  # Get a text list of names for a dataset
  #
  # @param dataset_id [String] The dataset id
  # @param import_attempt [Integer] The import attempt number
  #
  def self.name_list(dataset_id, import_attempt: nil, verbose: nil)

    # get last import attempt number if none given
    if import_attempt.nil?
      import = self.importer(dataset_id: dataset_id)
      import_attempt = import['attempt']
    end

    endpoint = "dataset/#{dataset_id}/import/#{import_attempt}/names"
    Request.new(endpoint: endpoint, verbose: verbose).perform
  end

  # Get a text tree of names for a dataset
  #
  # @param dataset_id [String] The dataset id
  # @param import_attempt [Integer] The import attempt number
  #
  def self.name_tree(dataset_id, import_attempt: nil, verbose: nil)

    # get last import attempt number if none given
    if import_attempt.nil?
      import = self.importer(dataset_id: dataset_id)
      import_attempt = import['attempt']
    end

    endpoint = "dataset/#{dataset_id}/import/#{import_attempt}/tree"
    Request.new(endpoint: endpoint, verbose: verbose).perform
  end

  # Get name usages or a nameusage from a dataset
  #   Note: Queries the PSQL database, whereas nameusage_search uses Elastic Search
  #
  # @param dataset_id [String] The dataset id
  # @param nameusage_id [String] The nameusage id
  # @param q [String] The scientific name or authorship search query
  # @param rank [Array, String] The rank of the taxon in the search query q
  # @param nidx_id [String] The name index id
  # @param subresource [String] The name subresource endpoint (relations, synonyms, types, or orphans)
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.nameusage(dataset_id, nameusage_id: nil, q: nil, rank: nil, nidx_id: nil, subresource: nil,
                     offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/nameusage"
    unless nameusage_id.nil?
      endpoint = "#{endpoint}/#{nameusage_id}"
      offset = nil
      limit = nil
    end
    unless subresource.nil?
      endpoint = "#{endpoint}/#{subresource}"
    end
    Request.new(endpoint: endpoint, q: q, rank: rank, nidx_id: nidx_id, offset: offset, limit: limit,
                verbose: verbose).perform
  end

  # Search the nameusage route, which uses Elastic Search
  #
  # @param q [String] A query string
  # @param dataset_id [String, nil] restricts name usage search within a dataset
  # @param endpoint [String, nil] some endpoints have nested options
  # @param content [String, nil] restrict search to SCIENTIFIC_NAME, or AUTHORSHIP
  # @param issue [Array, String, nil] the data quality issue
  # @param type [String, nil] sets the type of search to PREFIX, WHOLE_WORDS, or EXACT
  # @param rank [String, nil] taxonomic rank of name usages
  # @param min_rank [String, nil] minimum taxonomic rank of name usages
  # @param max_rank [String, nil] maximum taxonomic rank of name usages
  # @param facet [Array, String, nil] the search facet
  #
  # @param sort_by [String, nil] sort results by NAME, TAXONOMIC, INDEX_NAME_ID, NATIVE, or RELEVANCE
  # @param reverse [Boolean] sort in reverse order
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.nameusage_search(q: nil, dataset_id: nil, endpoint: 'nameusage/search', content: nil, issue: nil,
                            type: nil, rank: nil, min_rank: nil, max_rank: nil, facet: nil,
                            sort_by: nil, reverse: nil, offset: nil, limit: nil,
                            verbose: false)

    # a nil dataset_id will search name usages from all datasets in ChecklistBank
    unless dataset_id.nil?
      endpoint = "dataset/#{dataset_id}/nameusage/search"
    end

    Request.new(endpoint: endpoint, q: q, content: content, issue: issue, type: type,
                rank: rank, min_rank: min_rank, max_rank: max_rank, facet: facet,
                sort_by: sort_by, reverse: reverse, offset: offset, limit: limit, verbose: verbose).perform
  end

  # Parse a scientific name
  #
  # @param name [String] The scientific name to parse
  # @param authorship [String, nil] The authorship string for the scientific name
  # @param rank [String, nil] The rank of the scientific name to parse
  # @param code [String] The nomenclatural code (bacterial, botanical, cultivars, phytosociological, virus, zoological)
  #
  # @return [Hash, Boolean] A hash with the parsed scientific name
  def self.parser_name(name, authorship: nil, rank: nil, code: nil, verbose: false)
    endpoint = 'parser/name'
    Request.new(endpoint: endpoint, name: name, authorship: authorship, rank: rank, code: code,
                verbose: verbose).perform
  end

  # Get metadata patch
  #
  # @param dataset_id [String] The dataset id
  # @param token [String, nil] The authentication token from retrieved with Colrapi.user_login(user, password)
  def self.patch(dataset_id, patch_id: nil, token: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/patch"
    unless patch_id.nil?
      endpoint = "#{endpoint}/#{patch_id}"
    end
    Request.new(endpoint: endpoint, token: token, verbose: verbose).perform
  end

  # Get a reference with @reference_id from dataset @dataset_id via the reference route
  #
  # @param dataset_id [String] The dataset id
  # @param reference_id [String] The reference id
  # @param subresource [String] The reference subresource endpoint (orphans)
  # @param issue [String] The data quality issue (https://api.checklistbank.org/vocab/issue)
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.reference(dataset_id, reference_id: nil, subresource: nil, issue: nil, offset: nil, limit: nil,
                     verbose: false)
    endpoint = "dataset/#{dataset_id}/reference"
    if subresource == 'orphans'
      reference_id = nil
      endpoint = "#{endpoint}/orphans"
    end
    unless reference_id.nil?
      endpoint = "#{endpoint}/#{reference_id}"
    end
    Request.new(endpoint: endpoint, issue: issue, offset: offset, limit: limit, verbose: verbose).perform
  end

  # Get reviewer info
  #
  # @param dataset_id [String] The dataset id
  # @param token [String, nil] The authentication token from retrieved with Colrapi.user_login(user, password)
  #
  # # @return [Array, Hash, Boolean] An array of hashes
  def self.reviewer(dataset_id, token, verbose: false)
    endpoint = "dataset/#{dataset_id}/reviewer"
    Request.new(endpoint: endpoint, token: token, verbose: verbose).perform
  end

  # Get sector metadata, which allows importing datasets into project subtrees
  #
  # @param dataset_id [String] The dataset id
  # @param sector_id [Integer, nil] The sector id
  # @param name [String] The scientific name to query
  # @param rank [String, nil] The rank of the scientific name
  # @param modified_by [Integer, nil] Filter by a user id  on last modified by
  # @param broken [Boolean, nil] Whether the decision is broken or not
  # @param subject_dataset_id [String, nil] The source dataset id
  # @param last_synced_before [Date, nil] Filter by sectors synced before this date
  # @param mode [String, nil] Filter by type of sector (attach, union, merge)
  # @param subject [Boolean, nil] TODO: what does this do? All decisions with subject=true are bare names, so maybe it checks if the subject taxon exists?
  # @param min_size [Integer, nil] The minimum number of records in the sector
  # @param without_data [Boolean, nil] Filters to empty sectors with no data synced into the project yet
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Hash, Boolean] An hash of results
  def self.sector(dataset_id, sector_id: nil, name: nil, rank: nil, modified_by: nil, broken: nil,
                  subject_dataset_id: nil, last_synced_before: nil, mode: nil, subject: nil, min_size: nil, without_data: nil,
                  offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/sector"
    if sector_id.nil?
      Request.new(endpoint: endpoint, name: name, rank: rank, modified_by: modified_by, broken: broken,
                  subject_dataset_id: subject_dataset_id, last_synced_before: last_synced_before, mode: mode,
                  subject: subject, min_size: min_size, without_data: without_data,
                  offset: offset, limit: limit, verbose: verbose).perform
    else
      endpoint = "#{endpoint}/#{sector_id}"
      Request.new(endpoint: endpoint, verbose: verbose).perform
    end
  end

  # Get sector sync info
  #
  # @param dataset_id [String] The dataset id
  # @param sector_id [Integer, nil] The sector id
  # @param state [Array, String, nil] The sector sync state (e.g., waiting, processing, inserting, indexing, finished, etc.)
  # @param running [Boolean, nil] Filter to sector syncs that are only running
  # @param attempt [Integer, nil] The sync attempt number for sector_id
  # @param subresource [String, nil] The subresource for attempt (names or tree)
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Hash, Boolean] An hash of results
  def self.sector_sync(dataset_id, sector_id: nil, attempt: nil, subresource: nil, state: nil, running: nil, offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/sector/sync"
    if sector_id.nil?
      Request.new(endpoint: endpoint, state: state, running: running, offset: offset, limit: limit,
                  verbose:verbose).perform
    else
      if attempt.nil?
        endpoint = "dataset/#{dataset_id}/sector/#{sector_id}/sync"
      else
        endpoint = "dataset/#{dataset_id}/sector/#{sector_id}/sync/#{attempt}"
        endpoint = "#{endpoint}/#{subresource}" unless subresource.nil?
      end
      Request.new(endpoint: endpoint, verbose:verbose).perform
    end
  end

  # Get the dataset settings
  # @param dataset_id [String] The dataset id
  #
  # @return [Hash, Boolean] A hash including the dataset settings
  def self.settings(dataset_id)
    Request.new(endpoint: "dataset/#{dataset_id}/settings").perform
  end

  # Get a synonym with @synonym_id from dataset @dataset_id via the synonym route
  #
  # @param dataset_id [String] The dataset id
  # @param synonym_id [String] The synonym id
  # @param subresource [String] The synonym subresource endpoint (source)
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.synonym(dataset_id, synonym_id: nil, subresource: nil, offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/synonym"
    unless synonym_id.nil?
      endpoint = "#{endpoint}/#{synonym_id}"
    end
    if subresource == 'source'
      endpoint = "#{endpoint}/source"
    end
    Request.new(endpoint: endpoint, offset: offset, limit: limit, verbose: verbose).perform
  end

  # Get the full list of taxon IDs for a dataset (returns 1 ID string per line, not JSON)
  #
  # @param dataset_id [String] The dataset id
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon_ids(dataset_id, verbose: false)
    Request.new(endpoint: "dataset/#{dataset_id}/taxon/ids", verbose: verbose).perform
  end

  # Get a taxon with @id from dataset @dataset_id via the taxon route
  #
  # @param dataset_id [String] The dataset id
  # @param taxon_id [String] The taxon id
  # @param subresource [String] The taxon subresource endpoint (classification, distribution, info, interaction, media,
  #   relation, source, synonyms, treatment, or vernacular)
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.taxon(dataset_id, taxon_id: nil, subresource: nil, offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/taxon"
    unless taxon_id.nil?
      endpoint = "#{endpoint}/#{taxon_id}"
    end

    subresources = %w[classification distribution info interaction media relation source synonyms treatment vernacular]
    if !subresource.nil? and subresources.include? subresource
      endpoint = "#{endpoint}/#{subresource}"
    end
    Request.new(endpoint: endpoint, offset: offset, limit: limit, verbose: verbose).perform
  end

  # Get the root taxa
  #
  # @param dataset_id [String] The dataset id
  # @param taxon_id [String] The taxon id
  # @param children [Boolean] Display the children of taxon_id
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.tree(dataset_id, taxon_id: nil, children: false, offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/tree"
    endpoint = "#{endpoint}/#{taxon_id}" unless taxon_id.nil?
    endpoint = "#{endpoint}/children" unless taxon_id.nil? or !children
    Request.new(endpoint: endpoint, offset: offset, limit: limit, verbose: verbose).perform
  end

  # Get user data
  #
  # @param user_id [Integer, nil] The user id
  # @param q [String, nil] The search query
  # @param role [String, nil] The user role (admin, editor, or reviewer)
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param token [String, nil] The authentication token from retrieved with Colrapi.user_login(user, password)
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.user(user_id: nil, q: nil, role: nil, offset: nil, limit: nil, token: nil, verbose: false)
    if user_id.nil?
      endpoint = "user"
      Request.new(endpoint: endpoint, q: q, role: role, offset: offset, limit: limit, token: token,
                  verbose: verbose).perform
    else
      endpoint = "user/#{user_id}"
      Request.new(endpoint: endpoint, token: token, verbose: verbose).perform
    end
  end

  # Get datasets user can access
  # @param token [String] The access token from Colrapi.user_login()
  # @param dataset_id [String, nil] A dataset id to check
  # @param origin [Array, String, nil] Filter by the origin of a dataset (external, project, release, xrelease)
  #
  # @return [Array, Boolean] An array of datasets, or returns a boolean if dataset_id is provided
  def self.user_dataset(token, dataset_id: nil, origin: nil, verbose: false)
    endpoint = "user/dataset"
    if dataset_id.nil?
      Request.new(endpoint: endpoint, token: token, origin: origin, verbose: verbose).perform
    else
      endpoint = "user/dataset/#{dataset_id}"
      Request.new(endpoint: endpoint, token: token, verbose: verbose).perform
    end
  end

  # Authenticate user and get authentication token
  def self.user_login(user, password, verbose: false)
    Request.new(endpoint: "user/login", user: user, password: password, verbose: verbose).perform
  end

  # Get the authenticated user
  #
  # @param token [String, nil] The authentication token from retrieved with Colrapi.user_login(user, password)
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.user_me(token, verbose: false)
    Request.new(endpoint: "user/me", token: token, verbose: verbose).perform
  end

  # Get verbatim data
  #
  # @param dataset_id [String] The dataset id
  # @param verbatim_id [String] The verbatim id
  # @param q [String] The search query string
  # @param issue [Array, String] Filter by data quality issue (e.g., ACCEPTED_NAME_MISSING, DUPLICATE_NAME, URL_INVALID)
  # @param type [Array, String] The file type (e.g., acef:AcceptedSpecies, col:Taxon, dwc:Taxon)
  #
  # TODO: May not work yet: https://github.com/CatalogueOfLife/backend/issues/1201
  #   @param term [Array, String] Filter by term (http://api.checklistbank.org/vocab/term)
  #   @param term_operator [String] The operator to use with term ('and' or 'or')
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array, Boolean] An array of hashes
  def self.verbatim(dataset_id, verbatim_id: nil, q: nil, issue: nil, type: nil, term: nil, term_operator: nil,
                    offset: nil, limit: nil, verbose: false)
    endpoint = "dataset/#{dataset_id}/verbatim"
    if verbatim_id.nil?
      Request.new(endpoint: endpoint, q: q, issue: issue, type: type, term: term, term_operator: term_operator,
                  offset: offset, limit: limit, verbose: verbose).perform
    else
      endpoint = "#{endpoint}/#{verbatim_id}"
      Request.new(endpoint: endpoint, verbose: verbose).perform
    end
  end

  # Get vernacular names
  #
  # @param dataset_id [String, nil] The dataset id
  # @param language [String, nil] The language of the vernacular name (see: http://api.checklistbank.org/vocab/language)
  #
  # @param offset [Integer] Offset for pagination
  # @param limit [Integer] Limit for pagination
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Hash] A hash of vernacular results
  def self.vernacular(dataset_id: nil, language: nil, offset: nil, limit: nil, verbose: false)
    if dataset_id.nil?
      endpoint = 'vernacular'
      Request.new(endpoint: endpoint, language: language, offset: offset, limit: limit, verbose: verbose).perform
    else
      endpoint = "dataset/#{dataset_id}/vernacular"
      Request.new(endpoint: endpoint, language: language, offset: offset, limit: limit, verbose: verbose).perform
    end
  end

  # Get backend version
  #
  # @return [String] A version string
  def self.version(verbose: false)
    Request.new(endpoint: 'version', verbose: verbose).perform
  end

  # Get vocab
  # @param term [String] The vocab term
  # @param subresource [String] The subresource which is usually the id, code, or name
  # @param children [Boolean] Returns the geotime's children if true
  #
  # @param verbose [Boolean] Print headers to STDOUT
  #
  # @return [Array]
  def self.vocab(term: nil, subresource: nil, children: false, verbose: false)
    endpoint = "vocab"
    endpoint = "#{endpoint}/#{term}" unless term.nil?
    endpoint = "#{endpoint}/#{subresource}" unless term.nil? or subresource.nil?
    endpoint = "#{endpoint}/children" if children and term == "geotime"
    Request.new(endpoint: endpoint, verbose: verbose).perform
  end
end
