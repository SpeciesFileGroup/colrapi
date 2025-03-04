# colrapi

This is a wrapper on the Catalogue of Life API. Code follow the spirit/approach of the Gem [serrano](https://github.com/sckott/serrano), and indeed much of the wrapping utility is copied 1:1 from that repo, thanks [@sckott](https://github.com/sckott).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'colrapi'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install colrapi


## Documentation

Most of the [ChecklistBank/Catalogue of Life API](https://api.checklistbank.org) is wrapped by the Colrapi gem, but not everything is documented yet. Looking through the [tests](https://github.com/SpeciesFileGroup/colrapi/tree/main/test) is a good way to see examples and learn how to use the Ruby gem. If you need something documented, please [open an issue](https://github.com/SpeciesFileGroup/colrapi/issues/new) ticket.

The Colrapi Ruby gem uses dataset_id to access information scoped within a dataset. There are [4 types of datasets](https://api.checklistbank.org/vocab/datasetorigin) in ChecklistBank: `external`, `project`, `release`, and `xrelease`. Most datasets are `external`, maintained outside of ChecklistBank and imported. A `project` is a draft version of a dataset assembled inside ChecklistBank from `external` datasets (e.g., [Catalogue of Life](https://www.checklistbank.org/dataset/3/about)). A `release` is a published dataset released from a `project` (e.g., [Catalogue of Life 2024 Annual Checklist](https://www.checklistbank.org/dataset/COL24/about)). An `xrelease` is a published dataset in which automated tools were used to extend a `release` dataset with additional information to fill in data gaps and have less editorial scrutiny. For example, this can mean that a very carefully scrutinized `external` dataset can be assembled into a project, published with some editorial decisions as a `release` and also extended to include missing names that a taxonomic expert might have deliberately excluded from their taxonomic database for various reasons in an `xrelease`. `xrelease` datasets aim to meet the use case of being able to attach occurrences and other data to a (nearly) complete list of scientific names. If you want the more expert scrutinized version of COL, then use a `release`. If you want to attach data to a complete list of scientific names and are less concerned about taxonomic scrutiny, then use an `xrelease`. (There may be no public COL `xrelease` datasets yet as the feature is currently under development.)

Catalogue of Life has dataset_id=3, but you should almost never use dataset_id=3 because it is a draft unreleased version of COL and can have errors while the releases are being produced. Instead use 3LR to get the COL latest release, or 3LXR to get the COL latest extended release. COL releases new editions each month and the monthly releases are eventually deleted. If you need stable data that will be persistently accessible, then use the dataset_id=COLYY, where YY is the Annual Checklist year (e.g. COL24 to get the 2024 Annual Checklist). COL aims to keep the annual checklists permanently accessible, but the best practice is to download a copy of the data and archive it permanently with any research papers that use COL. Download a copy here, replacing {dataset_id} with the dataset_id: https://www.checklistbank.org/dataset/{dataset_id}/download

### Dataset

Get a list of external datasets in ChecklistBank:
```ruby
Colrapi.dataset(origin: 'external')
```

#### [/dataset](http://api.checklistbank.org/#/default/search)
Get a list of projects in ChecklistBank:
```ruby
Colrapi.dataset(origin: 'project')
```

Get a list of releases in ChecklistBank released from Catalogue of Life:
```ruby
Colrapi.dataset(origin: 'release', released_from: 3)
```

Get a list of xreleases in ChecklistBank released from Catalogue of Life:
```ruby
Colrapi.dataset(origin: 'xrelease', released_from: 3)
```

Get a list of datasets that contribute to Catalogue of Life:
```ruby
Colrapi.dataset(contributes_to: 3)
```

Get a list of datasets under a specific [license](https://api.checklistbank.org/vocab/license):
```ruby
Colrapi.dataset(license: 'cc by')
```

### Names




### Metadata

Get metadata by dataset_id:
```ruby
Colrapi.dataset(dataset_id: 'COL24')
```


### Name usage search

There are a two ways to conduct name usage search in ChecklistBank/Catalogue of Life: 1) using Elasticsearch or 2) querying PostgreSQL directly. Elasticsearch offers more advanced search functionality and parameters while PostgreSQL might perform faster.

#### 1) Elasticsearch 
##### [/nameusage/search](http://api.checklistbank.org/#/default/search_4) or [/dataset/{dataset_id}/nameusage/search](http://api.checklistbank.org/#/default/searchDataset)

Elasticsearch all of ChecklistBank:
```ruby
Colrapi.nameusage_search(q: 'Homo sapiens') #  => MultiJson object
```

Elasticsearch the Catalogue of Life latest release:
```ruby
Colrapi.nameusage_search(dataset_id: '3LR', q: 'Homo sapiens') #  => MultiJson object
```

Elasticsearch the Catalogue of Life 2024 Annual Checklist:
```ruby
Colrapi.nameusage_search(dataset_id: 'COL24', q: 'Homo sapiens') #  => MultiJson object
```

Elasticsearch Orthoptera Species File:
```ruby
Colrapi.nameusage_search(dataset_id: 1021, q: 'Cyphoderris strepitans') #  => MultiJson object
```

#### 2) PostgreSQL Search
##### [/dataset/{dataset_id}/nameusage](https://api.checklistbank.org/#/default/list_3)
Query PostgreSQL directly for *Homo sapiens* in the Catalogue of Life latest release:
```ruby
Colrapi.nameusage('3LR', q: 'Homo sapiens') #  => MultiJson object
```

Query PostgreSQL directly for *Homo sapiens* in the Catalogue of Life 2024 Annual Checklist:
```ruby
Colrapi.nameusage('COL24', q: 'Homo sapiens') #  => MultiJson object
```

Query PostgreSQL directly for *Cyphoderris strepitans* in Orthoptera Species File
```ruby
Colrapi.nameusage(1021, q: 'Cyphoderris strepitans') #  => MultiJson object
```

## Taxon
Get a taxon from the Catalogue of Life latest release by taxon ID:
```ruby
Colrapi.taxon('3LR', taxon_id: 'BHC3') #  => MultiJson object
```

Get the higher classification for a taxon from the Catalogue of Life latest release by taxon ID:
```ruby
Colrapi.taxon('3LR', taxon_id: 'BHC3', subresource: 'classification') #  => MultiJson object
```

Get the distribution for a taxon from the Catalogue of Life latest release by taxon ID:
```ruby
Colrapi.taxon('3LR', taxon_id: 'BHC3', subresource: 'distribution') #  => MultiJson object
```

Get additional info about a taxon from the Catalogue of Life latest release by taxon ID:
```ruby
Colrapi.taxon('3LR', taxon_id: 'BHC3', subresource: 'info') #  => MultiJson object
```

Get species interactions for a taxon from 3i World Auchenorrhyncha Database by taxon ID:
```ruby
Colrapi.taxon(2317, taxon_id: 28472, subresource: 'interaction') #  => MultiJson object
```

Get media for a taxon from WoRMS World Porifera Database by taxon ID:
```ruby
Colrapi.taxon(1044, taxon_id: 'urn:lsid:marinespecies.org:taxname:166055', subresource: 'media') #  => MultiJson object
```

Get a source information from the Catalogue of Life latest release by taxon ID:
```ruby
Colrapi.taxon('3LR', taxon_id: 'BHC3', subresource: 'source') #  => MultiJson object
```

Get synonyms from the Catalogue of Life latest release by taxon ID:
```ruby
Colrapi.taxon('3LR', taxon_id: 'BHC3', subresource: 'synonyms') #  => MultiJson object
```

Get a taxonomic treatment from a Plazi dataset by taxon ID:
```ruby
Colrapi.taxon('49590', taxon_id: '03D087F29465E83AFCF39B19FA20FC96.taxon', subresource: 'treatment') #  => MultiJson object
```

Get vernacular names from the Catalogue of Life latest release by taxon ID:
```ruby
Colrapi.taxon('3LR', taxon_id: 'BHC3', subresource: 'vernacular') #  => MultiJson object
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, update the `CHANGELOG.md`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mjy/colrapi. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/species_file_group/colrapi/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT](https://opensource.org/licenses/MIT) license.

## Code of Conduct

Everyone interacting in the Colrapi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/species_file_group/colrapi/blob/main/CODE_OF_CONDUCT.md).
