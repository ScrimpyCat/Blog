Blog
====

This is the base blog implementation for my site. To check how it's currently used for my site, see the my-site branch.

The blog currently supports static posts, tagging, series groups, and live streaming.

Usage:
------
Creating new posts is done through rake post commands.

	post:create[file] #creates a new post file
	post:insert[file] #inserts the post into the database
	post:update[file] #updates a post already in the database (only needed if post header info has changed)
	post:remove[file] #removes a post from the database
	post:delete[file] #deletes the post file


Posts can be found within `/app/assets/posts` and are denoted by the extension `.post`. Posts also include an attribute header (it is simply a YAML structure) which contains some metadata about the post.

This attribute data is stripped from the actual file before it is rendered. This data is however stored in the database, so modifying this data requires a post:update. So the general usage is to chain the post onto the actual type of the file. e.g. The post to be rendered is written in HTML, or Markdown, etc.

```
--- #html_entry.html.post
title: I was written in HTML
date: 2014-08-03
---
<p>Hello World</p>
```
```
--- #markdown_entry.md.post
title: I was written in Markdown
date: 2014-08-03
---
Hello World
```

Attributes
----------
All attributes apart from the date are optional. The current list is:

	---
	title:
	author:
	date:
	tags:
	series:
	---

`title` - The title of the post. The title is displayed inside the rendered post, and is also used for referencing the post directly `www.example.com/blog/this-is-my-title`. If this field is left blank it cannot be referenced directly apart from using the post's id `www.example.com/blog?id=1`.  
`author` - The author of the post. The author is displayed inside the rendered post unless it is not supplied.  
`date` - The date of the post (datetime). This is the most important attribute, as leaving it blank will have unwarranted effects. This field is also automatically set when generating posts from post:create.  
`tags` - A list of categories this post falls under. If any tags are supplied then those tags can be used to search for the post `www.example.com/blog/category/some-tag+another-tag`  
`series` - The series this post belongs to. If the post is apart of a group of posts, this field can be used to indicate that. The series will be displayed inside the rendered post and will also make it listed under its series tag `www.example.com/blog/series/some-series`