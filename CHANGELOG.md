# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- add `alt` parameter back to `abbr_emoji_filter`
- output unicode characters for svg elements

## [0.2.0] - 2015-05-25
### Added
- `abbr_emoji_filter` is an `emoji_filter` without the `alt` and `title` attributes. It works better with the `abbr` tag.
- project references

### Changed
- renamed `shorten_filter` to `auto_abbr_filter` to match other internet plugins. (nice to know others want this too)
- lessen bundler dependency to work with more ruby versions
- more strict substitution boundaries

## [0.1.0] - 2015-05-23
### Added
- `abbr_filter` and `shorten_filter`
- initial push

[unreleased]: https://github.com/kbrock/html-pipeline-abbr/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/kbrock/html-pipeline-abbr/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/kbrock/html-pipeline-abbr/commits/v0.1.0
