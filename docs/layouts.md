# Layouts

Archives layouts are special layouts that specify how an archive page is displayed. Special attributes are available to these layouts to represent information about the specific layout being generated. These layouts are otherwise identical to regular Jekyll layouts. To handle the variety of cases presented through the attributes, we recommend that you use [type-specific layouts](./configuration.md#type-specific-layouts). 

### Layout attributes
#### Title (`page.title`)
The `page.title` attribute contains information regarding the name of the archive *if and only if* the archive is a tag or category archive. In this case, the attribute simply contains the name of the tag/category. For date-based archives (year, month, and day), this attribute is `nil`.

#### Date (`page.date`)
In the case of a date archive, this attribute contains a Date object that can be used to present the date header of the archive in a suitable format. For year archives, the month and day components of the Date object passed to Liquid should be neglected; similarly, for month archives, the day component should be neglected. We recommend using the [`date` filter](http://docs.shopify.com/themes/liquid-documentation/filters/additional-filters#date) in Liquid to process the Date objects. For tag and category archives, this field is `nil`.

#### Posts (`page.posts`)
The `page.posts` attribute contains an array of Post objects matching the archive criteria. You can iterate over this array just like any other Post array in Jekyll.

#### Type (`page.type`)
This attribute contains a simple string indicating the type of the layout being generated. Its value can be one of `tag`, `category`, `year`, `month`, or `day`.

### Sample layouts
#### Tag and category layout

<!-- {% raw %} -->
```html
<h1>Archive of posts with {{ page.type }} '{{ page.title }}'</h1>
<ul class="posts">
  {% for post in page.posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%b %-d, %Y" }}</span>
      <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
```

#### Year layout
```html
<h1>Archive of posts from {{ page.date | date: "%Y" }}</h1>

<ul class="posts">
{% for post in page.posts %}
  <li>
    <span class="post-date">{{ post.date | date: "%b %-d, %Y" }}</span>
    <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ul>
```

#### Month layout
```html
<h1>Archive of posts from {{ page.date | date: "%B %Y" }}</h1>

<ul class="posts">
{% for post in page.posts %}
  <li>
    <span class="post-date">{{ post.date | date: "%b %-d, %Y" }}</span>
    <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ul>
```

#### Day layout
```html
<h1>Archive of posts from {{ page.date | date: "%B %-d, %Y" }}</h1>

<ul class="posts">
{% for post in page.posts %}
  <li>
    <span class="post-date">{{ post.date | date: "%b %-d, %Y" }}</span>
    <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
  </li>
{% endfor %}
</ul>
```
<!-- {% endraw %} -->
