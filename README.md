Ben's Rails Templates
=====================

Requirements
------------
* Rails 3
* Bundler
* Git

Usage
-----
    rails new yourappname -m 'https://github.com/benlangfeld/rails-templates/raw/master/base.rb'

Remember to add `-T` and `--database=postgresql` for extra coolness.

You'll get a minimal number of prompts during the process. First, your editor will open with a YAML file taking some basic config. You'll then likely have to confirm replacement of rails.js, and then if you use Heroku, you'll get one more YAML config file. Simple.

Features
--------
* Git repo (each step committed separately)
* rspec
* mocha
* factory\_girl
* infinity\_test
* cucumber
* nifty\_layout
* web\_app_theme
* haml
* jquery
* simple\_navigation
* kaminari
* simple\_form
* static
* has_scope
* simple_enum
* andand
* annotate\_models
* auto\_protect\_model\_attributes
* cappuccino
* adhearsion
* heroku
* cream
* github


Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Commit.
* Send me a pull request. Bonus points for topic branches.

Copyright
---------

Copyright (c) 2011 Ben Langfeld. MIT licence (see LICENSE for details).
Some stuff shamefully stolen from Kevin Faustino at https://github.com/madebydna/rails-templater
