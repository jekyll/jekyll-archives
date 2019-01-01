## Configuration

Archives configuration is done in the site's `_config.yml` file, under the `jekyll-archives` key.

### Default configuration

```yml
jekyll-archives:
  enabled: []
  layout: archive
  permalinks:
    year: '/:year/'
    month: '/:year/:month/'
    day: '/:year/:month/:day/'
    tag: '/tag/:name/'
    category: '/category/:name/'
  types:
    year: 'year'
    month: 'month'
    day: 'day'
    tag: 'tag'
    category: 'category'
```

### Configuration options

#### Required and recommended settings
- [Enabled archives (`enabled`)](#enabled-archives)
- [Archive-specific layouts (`layouts`)](#archive-specific-layouts)

#### Optional settings
- [Default layout (`layout`)](#default-layout)
- [Permalinks (`permalinks`)](#permalinks)

#### Custom archives
- [Archive types (`types`)](#types)

---

#### Enabled archives

| Key       | Value type      | Values |
|-----------|-----------------|--------|
| `enabled` | String or Array | `'all'` or an array of any combination of `years`, `months`, `days`, `categories`, `tags`, or archive names (the keys in `types`, by default `year`, `month`, `day`, `category`, `tag`) |

##### Description
This option sets which types of archives will be created. Must be set to an array of enabled archives, or the string 'all' (to enable all archives).

If an array is used, it may contain individual archive names, or [archive types](#types) using the plural form: year**s**, month**s**, day**s**, categor**ies**, tag**s**. When archive types are used, all archives of that type are enabled.
##### Sample values

```yml
enabled: all
enabled:
  - categories
enabled:
  - year
  - month
  - tags
```

---

#### Default layout

| Key      | Value type | Values |
|----------|------------|--------|
| `layout` | String     | The layout name of the default archive layout |

##### Description

Sets the default layout to use if no type-specific layout (see [Type-specific layouts](#type-specific-layouts) below) for an archive is specified.

##### Sample values

```yml
layout: archive                  # _layouts/archive.html
layout: custom-archive-layout    # _layouts/custom-archive-layout.html
```

---

#### Type-specific layouts

| Key       | Value type                | Values |
|-----------|---------------------------|--------|
| `layouts` | Map, String &rarr; String | A map of archive name (the keys in `types`, by default `year`, `month`, `day`, `category`, `tag`) to its layout. |

##### Description

Maps archive types to the layout they will be rendered in. Not all types need to be specified; those without a specific layout will fall back to the default layout.

##### Sample values

```yml
layouts:
  year: year-archive
  month: month-archive
  day: day-archive
  category: category-archive
  tag: tag-archive
```

---

#### Permalinks

| Key          | Value type                | Values |
|--------------|---------------------------|--------|
| `permalinks` | Map, String &rarr; String | A map of archive name (the keys in `types`, by default `year`, `month`, `day`, `category`, `tag`) to its permalink format. |

##### Description

Maps archive types to the permalink format used for archive pages. The permalink style is the same as regular Jekyll posts and pages, but with different variables.

These variables are:

* `:year` for year archives
* `:year` and `:month` for month archives
* `:year`, `:month`, and `:day` for day archives
* `:name` for category and tag archives

If the permalink for an archive which is not part of the [default configuration](#default_configuration) is missing, a fallback will automatically be provided, based on the following patterns:
* `/{archive-name}/:name/` for archives whose type is either `tag` or `category`
* `/{archive-name}/:year/` for archives whose type is `year`
* `/{archive-name}/:year/:month/` for archives whose type is `month`
* `/{archive-name}/:year/:month/:day/` for archives whose type is `day`

*Note:* trailing slashes are required to create the archive as an `index.html` file of a directory.

##### Sample values

```yml
permalinks:
  year: '/archives/year/:year/'
  month: '/archives/month/:year-:month/'
  tag: '/archives/tag/:name/'
```

#### Types
| Key | Value type | Values |
|---|---|---|---|
| `permalinks` | Map, String &rarr; String | A map of archive name to archive types: `year`, `month`, `day`, `category`, `tag`. |
##### Description
By default, an archive of each type is declared, with the same name as its type. Therefore, in simple case, the distinction between archive type and archive name can be ignored.

However, it can sometimes be useful set up multiple archives of the same type to provide different views of that same content. For instance, one view could contain a list of post titles, serving as a table of content, while an other view would include the posts' content inline.

In that case, the keys of `types` are used to declare new archive names, and the values must be one of `year`, `month`, `day`, `category`, or `tag`.

Archive names are what are used as keys to [`layouts`](#archive-specific-layouts) or [`permalinks`](#permalinks), or as values in the [`enabled`](#enabled-archives) array.

##### Sample
```yml
enabled: [tags]
layouts:
 tag-toc: "table-of-content"
types:
 tag-index: "tag"
 tag: "tag"
permalinks:
  tag: '/tag/:name/`
  tag-toc: '/tag/:name/toc/`
```
