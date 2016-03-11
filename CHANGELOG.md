# Changelog

## 0.3.0 (2016-03-10)
- Customize the alphabet used for Hashids

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
