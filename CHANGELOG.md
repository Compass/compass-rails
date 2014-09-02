# Change log

## 2.0.0 - 2014-07-10
### Added
- Support for Rails 4.2
- Allow newer sass-rails with Sass 3.3 support (see #160).

### Removed
- Rails 3.0 support.

### Fixed
- Properly bust the cache on image sprites within a sub-directory that
are imported with a wildcard (see #166).

## 1.1.7 - 2014-03-18
### Fixed
- Locked Sprockets version to 2.11.0 (see #146).

## 1.1.6 - 2014-03-11
### Fixed
- Leave bundle selection to rails environment.

## 1.1.5 - 2014-03-11
### Added
- Support for Ruby 2.1.0.

### Fixed
- Fixed `rails_loaded?` for when Rails is defined but no application is actually loaded.

## 1.1.4 - 2014-03-18
### Changed
- Simplified README.

## 1.1.3 - 2013-12-27
### Fixed
- No longer assuming asset pipeline is running when generating sprites.

## 1.1.2 - 2013-12-06
### Fixed
- Reverted fix for `generated_image_url` introduced in 1.1.0.

## 1.1.1 - 2013-12-05
### Added
- Support for Compass versions greater than 0.12.2.

## 1.1.0 - 2013-12-05
### Added
- Rails 4 support.
- Ruby 2.0 support.

### Fixed
- Allow compass-rails without asset pipeline on Rails 3.2.
- Fix `generated_image_url` when `generated_images_dir` is set.

### Removed
- Support for Ruby 1.8.7 and 1.9.2.
- Support for Rails 2.3.

## 1.0.3 - 2012-06-26
### Added
- Bumped Compass version to 0.12.2.

### Fixed
- `FixedStaticCompiler` hack so sprite source files dont show up in manifest.
