## HEAD

### Development Fixes

  * Initialize Archives generator with a hash (#135)
  * Remove support for legacy Jekyll versions (#136)
  * Read-in site&#39;s tags and categories attributes (#137)
  * Simplify checking if an archive type is enabled (#149)
  * Use private helper to append enabled archive type (#150)
  * Access nested Hash values with `Hash#dig` (#151)
  * Generate custom post_attr_hash with private helper (#152)

### Bug Fixes

  * Return unless &#39;jekyll-archives&#39; config is a Hash (#139)

### Documentation

  * s/gems/plugins/ (#143)

### Minor Enhancements

  * Memoize relative_path attribute of archive pages (#153)
  * Memoize date attribute of date-type archive pages (#154)
  * Allow creating slugs for emoji characters. (#129)

## 2.2.1

### Minor Enhancements

  * Make Archive subclass of Page (#67)
  * Don't limit slugs/title to strings (#41)
  * Enable incremental operation (#58)
  * Remove deprecated defs (#89)

### Development Fixes

  * Target Ruby 2.3
  * Allow testing and using with Jekyll 4.x (#133)
  * Update Travis config and Gemfile for Ruby < 2.2.2 support (#68)
  * Consolidate History file to work with jekyllbot (#80)
  * Remove Travis test for Ruby 1.9 (#87)
  * Inherit Jekyll's rubocop config for consistency (#65)
  * Bump travis ruby versions (#91)
  * Fix Travis build error (#93)
  * Define path with __dir__ (#105)
  * Appease Rubocop (#104)
  * update Rubocop and Travis config (#110)
  * Update .travis.yml (#111)
  * Modernize tests &amp; linting (#114)
  * Test against Ruby 2.5 (#118)
  * Lint with rubocop-jekyll (#128)

### Documentation

  * Update Installation Guide (#116)
  * docs/configuration: GitHub table display was messed up (#96)
  * Small updates for consistency across document (#130)

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
