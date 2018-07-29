# Changelog

## 1.2.2 (2018-07-29)
### Fixed
- Handle exception raised when using a letter-only alphabet and attempting to
  decode an integer ID from [@Drakula2k](https://github.com/Drakula2k) ([#54](https://github.com/jcypret/hashid-rails/pull/54)).

## 1.2.1 (2018-01-13)
- Found issue where unsigned hashids with `find` did not fall back to passed in ID ([#46](https://github.com/jcypret/hashid-rails/pull/46)).
- Move finder specs to a shared example run against both the signed and unsigned hashids.

## 1.2.0 (2017-11-17)
- Fix regression where `find_by_hashid` and `find_by_hashid!` attempt to decode
  values that are not hashids. ([#41](https://github.com/jcypret/hashid-rails/pull/41))

## 1.1.1 (2017-11-03)
- Fix eager loading and finding records through a parent. ([#39](https://github.com/jcypret/hashid-rails/pull/39))

## 1.1.0 (2017-10-04)
- Add option to disable hashid signing. This adds backwards compatibility with
  pre-1.0 releases. Thanks [@olliebennett](https://github.com/olliebennett)! ([#37](https://github.com/jcypret/hashid-rails/pull/37))
- Add note to README about upgrading from pre-1.0 releases.

## 1.0.0 (2017-04-29)
- Sign hashids to prevent accidentally decoded regular ids
- Require explicitly including Hashid::Rails in models
- Improve support for model associations
- Rename config variables to better match hashids project
- Improve overall test coverage

## 0.7.0 (2017-02-15)
- Add configuration option to disable overriding default `find` (#22).

## 0.6.0 (2017-01-07)
- Add Rubocop and adjust styles to be consistent.
- Fix issue where finding multiple non-hashids returns an array of nils.
- Switch over testing to use SQLite for more accurate db interactions.

## 0.5.0 (2016-10-15)
- Update specs to support Rails 5.x series.

## 0.4.1 (2016-08-21)
- Limit installations to Rails 4.x; gem is not yet Rails 5 compatible.

## 0.4.0 (2016-08-21)
- Add `find_by_hashid` method to always try and decode, as opposed to `find` which tries to find it as an integer first.

## 0.3.2 (2016-03-30)
- Multiple ids can be passed to `find` method.

## 0.3.1 (2016-03-10)
- Update Rails dependency to work with Rails 4.0 and up.

## 0.3.0 (2016-03-10)
- Customize the alphabet used for Hashids.

## 0.2.0 (2016-01-02)

- Customize the Hashid seed and length using a configuration initializer.
- Add test coverage
- Fix issue where calling `.reload` on model retries to `decode_id`.

## 0.1.2 (2015-04-12)

- Let `Model#find` work with integers passed in as strings.

## 0.1.1 (2015-04-12)

- Let `Model#find` work with integer model ids as well as hashids.

## 0.1.0 (2015-04-12)

- Initial Release
