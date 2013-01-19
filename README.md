cl-mvc
======

Basic Common Lisp MVC framework

Author:  Matthew Carter

Date:    20130119

Purpose: Simple Common Lisp MVC Framework for easily extensible web code

License: GPLv3

Right now everything is very sloppy - if using, use at your own risk!

NO WARRANTY SHALL BE IMPLIED OR EXPECTED

Usage:

Start up a slime instance:

	(load "~/cl-mvc/package.lisp")

Hit the now running web server:

	http://localhost:4242/about-us/

	
Actions are determined based on the current URL, controlled by Hunchentoot regex dispatch handlers.

Example:

	your-domain.com/news/article/44/

Will (using the default set up) run the "news" MVC in this order typically:

	controllers/news.lisp -> models/news-model.lisp -> views/news-view.lisp -> templates/some-template.html

By default there are the following actions:

	news (doesn't do anything but print out a message)

	help.html (shows some plain text help page - nothing useful yet)

	standard-page (everything defaults to this if not scooped up by something defined before)

The "standard-page" default action can be used to run a simple mySQL driven CMS with custom templates (template system includes file inclusion, CL code evaluation and variable substitution).

Email me with any questions at jehiva@gmail.com
