## About Jekyll Archives

Automatically generate post archives by dates, tags, and categories.

[![Gem Version](https://badge.fury.io/rb/jekyll-archives.svg)](http://badge.fury.io/rb/jekyll-archives)
[![Build Status](https://travis-ci.org/jekyll/jekyll-archives.svg?branch=master)](https://travis-ci.org/jekyll/jekyll-archives)

## Getting started

### Installation

1. Add `gem 'jekyll-archives'` to your site's Gemfile
2. Add the following to your site's `_config.yml`:

```yml
plugins:
  - jekyll-archives
```

### Configuration

Archives can be configured by using the `jekyll-archives` key in the Jekyll configuration (`_config.yml`) file. See the [Configuration](configuration.md) page for a full list of configuration options.

All archives are rendered with specific layouts using certain metadata available to the archive page. The [Layouts](layouts.md) page will show you how to create a layout for use with Archives.

## Documentation

For more information, see:

* [Getting-started](getting-started.md)
* [Configuration](configuration.md)
* [Layouts](layouts.md)
