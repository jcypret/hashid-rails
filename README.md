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

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hashid-rails'
```

And then execute:

```shell
$ bundle
```

Or install it yourself as:

```shell
$ gem install hashid-rails
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
@person = Person.find_by_hashid!(params[:hashid])

# When no record, is found it raises an exception.
ActiveRecord::RecordNotFound
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
  config.alphabet = "abcdefghijklmnopqrstuvwxyz" +
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
                    "1234567890" 

  # Whether to override the `find` method
  config.override_find = true
end
```

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
