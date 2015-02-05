## HEAD

### Minor Enhancements
  * Update Jekyll dependency to allow Jekyll 3 (#33)

### Bug Fixes

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
