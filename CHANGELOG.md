## [Unreleased]

## [0.1.7] - 2026-06-17
 - Allow Ruby 4.0.0:
    - Relaxed `required_ruby_version` to `>= 2.5.0, < 5.0`
    - Added Ruby 4.0.0 to the CI matrix
    - Bumped `faraday-follow_redirects` upper bound to allow 0.5+ (which lifts the Ruby < 4 cap)
    - Dropped the `bundler` development dependency
 - Fixed duplicate `:status` argument in `Colrapi::Request`
 - Updated tests to match current ChecklistBank API responses

## [0.1.6] - 2025-03-25
 - Added more nameusage_search parameters:
    - authorship
    - authorship_year
    - extinct
    - field
    - name_type
    - nomenclatural_code
    - nomenclatural_status
    - origin
    - secondary_source
    - sector_dataset_id
    - sector_mode
    - status
    - taxonomic_group

## [0.1.5] - 2025-03-25
 - Added usage_id to nameusage_search

## [0.1.4] - 2025-03-05
 - Fixed authentication
 - Kept depreciated ChecklistBank preview endpoint functionality by using /dataset/{dataset_id}LRC.json instead (now requires a token)

## [0.1.3] - 2025-03-04
 - Added environment and highest_taxon_id to name_usage_search
 - Updated license from NCSA to MIT

## [0.1.2] - 2024-09-11
 - Removed Gemfile.lock
 - Bumped development depency versions to avoid CVE-2024-43398
 - Added attempt param to archive endpoint

## [0.1.1] - 2023-04-17
- Updated Faraday version

## [0.1.0] - 2022-01-20

- Initial release
