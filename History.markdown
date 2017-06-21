## HEAD

### Major Enhancements

  * Adds support for archiving by language

### Minor Enhancements

  * Make Archive subclass of Page (#67)
  * Don't limit slugs/title to strings (#41)
  * Enable incremental operation (#58)
  * Remove deprecated defs (#89)

### Development Fixes

  * Update Travis config and Gemfile for Ruby < 2.2.2 support (#68)
  * Consolidate History file to work with jekyllbot (#80)
  * Remove Travis test for Ruby 1.9 (#87)
  * Inherit Jekyll's rubocop config for consistency (#65)
  * Bump travis ruby versions (#91)
  * Fix Travis build error (#93)

## 2.1.0

### Minor Enhancements

  * Update Jekyll dependency to allow Jekyll 3 (#33)
  * Update docs to reflect changes in v2.0.0 (#31)
  * Add compatibility with Jekyll 3 (#48)
  * Update to reflect release of Jekyll 3 (#52)
  * Support revised documents/collections in Jekyll 3 (#53)

### Development Fixes

  * Test against Jekyll 2, 3, and GitHub Pages (#48)

## 2.0.0 / 2015-01-06

### Minor Enhancements

  * Move Date object from `page.title` to `page.date` (#26)
  * Add documentation to repository (#25)

### Bug Fixes

  * Change Jekyll dependency to ~> 2.4 (#23)

## 1.0.0 / 2014-09-26

### Major Enhancements

  * Support type-specific layouts
  * Pass `Date` object to Liquid in case of date-based archives
  * Liquid `{{ site.archives }}` support
  * Generate month and day archives

### Minor Enhancements

  * Add version file and move everything into `Archives` module
  * Use `Jekyll::Utils.slugify` for slugging
  * Require use to specify what types of archives are enabled

## 0.1.0 / 2014-08-17

  * First release
  * Generate year, category, and tag archives

## 0.0.0 / 2014-08-17

  * Birthday!
