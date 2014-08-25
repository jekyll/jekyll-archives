# Jekyll Archives

Automatically generate post archives by dates, tags, and categories.

[![Gem Version](https://badge.fury.io/rb/jekyll-archives.png)](http://badge.fury.io/rb/jekyll-archives)

## Usage

1. Add `gem 'jekyll-archives'` to your site's Gemfile
2. Add the following to your site's `_config.yml`:

```yml
gems:
  - jekyll-archives
```

## Configuration
`jekyll-archives` is configurable from your site's `_config.yml` file:

```yml
jekyll-archives:
  layout: archive                  # The default layout to use for archive pages.
  enabled:                         # Specifies which archives are enabled.
    - year
    - month
    - tags
  layouts:                         # (Optional) Specifies type-specific layouts.
    year:     year-archive
    month:    month-archive
  permalinks:                      # (Optional) The permalinks to use for each archive.
    year:     '/:year/'
    month:    '/:year/:month/'
    day:      '/:year/:month/:day'
    tag:      '/tag/:name/'
    category: '/category/:name/'
```

### The `enabled` setting
Archives are enabled based on the following configuration rules:
- All archives are disabled by default.
- All archives can be enabled by setting `enabled: true` or `enabled: all`.
- Individual archives can be enabled by setting `enabled` to an array (see above example).
