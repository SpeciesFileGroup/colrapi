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



## Name usage search

There are a two ways to conduct name usage search in ChecklistBank/Catalogue of Life: 1) using Elasticsearch or 2) querying PSQL directly. Elasticsearch offers more advanced search functionality and parameters while PSQL might perform faster.

### 1) Elasticsearch 
#### [/nameusage/search](http://api.checklistbank.org/#/default/search_4) or [/dataset/{dataset_id}/nameusage/search](http://api.checklistbank.org/#/default/searchDataset)

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

### 2) PSQL Search
#### [/dataset/{dataset_id}/nameusage](https://api.checklistbank.org/#/default/list_3)
Query PSQL directly for *Homo sapiens* in the Catalogue of Life latest release:
```ruby
Colrapi.nameusage('3LR', q: 'Homo sapiens') #  => MultiJson object
```

Query PSQL directly for *Homo sapiens* in the Catalogue of Life 2024 Annual Checklist:
```ruby
Colrapi.nameusage('COL24', q: 'Homo sapiens') #  => MultiJson object
```

Query PSQL directly for *Cyphoderris strepitans* in Orthoptera Species File
```ruby
Colrapi.nameusage(1021, q: 'Cyphoderris strepitans') #  => MultiJson object
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
