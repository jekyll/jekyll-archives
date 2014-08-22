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
  layout: archive                  # The layout to use for archive pages.
  permalinks:
    year:     '/archive/:name'     # The permalink to use for year-based archives.
    tag:      '/tag/:name'         # The permalink to use for tag archives.
    category: '/category/:name'    # The permalink to use for category archives.
```
