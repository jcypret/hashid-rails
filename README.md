# Hashid Rails
[![Gem Version](https://badge.fury.io/rb/hashid-rails.svg)](https://badge.fury.io/rb/hashid-rails)
[![Build Status](https://travis-ci.org/jcypret/hashid-rails.svg?branch=master)](https://travis-ci.org/jcypret/hashid-rails)
[![Code Climate](https://codeclimate.com/github/jcypret/hashid-rails/badges/gpa.svg)](https://codeclimate.com/github/jcypret/hashid-rails)
[![Test Coverage](https://codeclimate.com/github/jcypret/hashid-rails/badges/coverage.svg)](https://codeclimate.com/github/jcypret/hashid-rails/coverage)

This gem allows you to easily use [Hashids](http://hashids.org/ruby/) in your
Rails app. Instead of your models using sequential numbers like 1, 2, 3, they
will instead have unique short hashes like "yLA6m0oM", "5bAyD0LO", and
"wz3MZ49l". The database will still use integers under the hood, so this gem can
be added or removed at any time.

> IMPORTANT: If you need to maintain the same hashids from a pre-1.0 release,
> read the [upgrade notes](#upgrading-from-pre-10).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "hashid-rails", "~> 1.0"
```

And then execute:

```shell
$ bundle
```

## Basic Usage

1. Include Hashid Rails in the ActiveRecord model you'd like to enable hashids.

```ruby
class Model < ActiveRecord::Base
  include Hashid::Rails
end
```

2. Continue using `Model#find` passing in either a hashid or regular 'ol id.

```ruby
@person = Person.find(params[:hashid])
```

## Get hashid of model

You can access the hashid of any model using the `hashid` method.

```ruby
model = Model.find(params[:hashid])
#=> <Model>
model.hashid
#=> "yLA6m0oM"
```

Additionally, the `to_param` method is overriden to use hashid instead of id.
This means methods that take advantage of implicit ID will automatically work
with hashids.

```erb
Passing a hashid model to `link_to`…
<%= link_to "Model", model %>

will use `hashid` instead of `id`.
<a href="/models/yLA6m0oM">Model</a>
```

## Alternative Usage

You can use the `Model#find_by_hashid` method to find a record without falling
back on the standard `find` method.


```ruby
# When a record is found, it returns the record.
@person = Person.find_by_hashid(params[:hashid])
#=> <Person>

# When no record, it returns nil
@person = Person.find_by_hashid(params[:hashid])
#=> nil

# A bang (!) version is also available and raises an exception when not found.
@person = Person.find_by_hashid!(params[:hashid])
#=> ActiveRecord::RecordNotFound
```

## Configuration (optional)

You can add an initializer for Hashid::Rails to customize the options passed to
the Hashids gem. This is completely optional. The configuration below shows the
default options.

```ruby
Hashid::Rails.configure do |config|
  # The salt to use for generating hashid. Prepended with table name.
  config.salt = ""

  # The minimum length of generated hashids
  config.min_hash_length = 6

  # The alphabet to use for generating hashids
  config.alphabet = "abcdefghijklmnopqrstuvwxyz" \
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" \
                    "1234567890"

  # Whether to override the `find` method
  config.override_find = true

  # Whether to sign hashids to prevent conflicts with regular IDs (see https://github.com/jcypret/hashid-rails/issues/30)
  config.sign_hashids = true
end
```

## Upgrading from Pre-1.0

The 1.0 release of this gem introduced hashid signing to prevent
conflicts with database IDs that could be mis-interpreted as hashids.
IDs are now signed when encoding and the signature verified when decoding.
The trade off is that hashids are different than in previous versions due to the added signature.
If you need to maintain the same hashids from a pre-1.0 version, set `sign_hashids` to false in the config.

Additionally, some of the config names have been modified to better match the parent [Hashid](https://github.com/peterhellberg/hashids.rb) project.
The config `secret` has been renamed to `salt` and the `length` renamed to `min_hash_length`.
Update the initializer config accordingly.

Lastly, `Hashid::Rails` is no longer imported into `ActiveRecord::Base` by default.
You can instead include `Hashid::Rails` selectively in the desired models,
or include it in `ApplicationRecord` for Rails 5 to apply to all subclassed models,
or add an initializer with `ActiveRecord::Base.send :include, Hashid::Rails` to match previous behavior.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release` to create a git tag for the version, push git commits
and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/hashid-rails/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
