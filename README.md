# CompassRails

[![Build Status](https://travis-ci.org/Compass/compass-rails.png?branch=stable)](https://travis-ci.org/Compass/compass-rails)
[![Code Climate](https://codeclimate.com/github/Compass/compass-rails.png)](https://codeclimate.com/github/Compass/compass-rails)

Compass rails is an adapter for the [Compass Stylesheet Authoring
Framework](http://compass-style.org) for [Ruby on Rails](http://rubyonrails.org/).

Since Compass v0.12, this adapter is the only way to install compass
into your rails application.

This adapter supports Rails 3.0, 4.0 and greater.

## Installation

Add the `compass-rails` gem line to a group called `:assets` in your application's Gemfile (Rails 3.1+ users should already have the `:assets` group):

```ruby
group :assets do
  gem 'sass-rails' # if running rails 3.1 or greater
  gem 'compass-rails'
end
```

If you are using any Compass extensions, add them to this group in your
Gemfile.

And then execute:

    $ bundle

## Usage

Change your `application.css` to `application.css.scss` or `application.css.sass` and use `@import` to your hearts content. Ex:

```scss
@import "project/mixins";
@import "project/base";

```

*or*

Use `application.css` to require files that use compass features. Ex:
```css
/*
 *= require styleguide_full_of_compass_stuff
 */
```

*Don't* use `*= require something` within your SCSS or SASS files. You're gonna have a bad time.

## Optional

To set up your project with starter stylesheets and a configuration
file:

    $ bundle exec compass init

If using a compass-based framework (like [susy](http://susy.oddbird.net/) or [blueprint](http://compass-style.org/reference/blueprint/)) then you can use the `--using` option to set this:

    $ bundle exec compass init --using blueprint

Note that the `compass init` step is optional if you have a project running Rails 3.0 or greater.

### Configuration

If you have a compass configuration file (recommended) then you can
use the [Compass configuration 
reference](http://compass-style.org/help/tutorials/configuration-reference/)
as is. If you choose to configure compass from your rails configuration
files, then you should understand that the compass configuration
options explained there will be methods and properties on the `config.compass`
configuration object exposed to rails within any configuration block.

### Notes On Sprockets Directives

Sprockets, used by the rails asset pipeline, provides directives for
doing things like requiring. These **must not** be used with Sass files.
Instead use the sass `@import` directive. In rails projects, the
`@import` directive is configured to work with sprockets via `sass-rails`. For more information on importing in rails 3.1 or greater see the [Sass-Rails README](https://github.com/rails/sass-rails/blob/master/README.md)

### Developing with Rails-based Compilation

By default, your sass files in `app/assets/stylesheets` will be
automatically compiled by the [`Sass::Plugin`](http://sass-lang.com/docs/yardoc/Sass/Plugin.html) or the [Rails asset
pipeline](http://guides.rubyonrails.org/asset_pipeline.html) depending on the version of rails that you use.

When using this approach you will need to reload your webpage in order
to trigger a recompile of your stylesheets.

### Developing with the Compass watcher

When using the Compass watcher to update your stylesheets, your
stylesheets are recompiled as soon as you save your Sass files. In this
mode, compiled stylesheets will be written to your project's public
folder and therefore will be served directly by your project's web
server -- superceding the normal rails compilation.

In this mode, rails 3.0 or earlier users will experience a slight
speed up by disabling the `Sass::Plugin` like so:

```ruby
config.after_initialize do
  Sass::Plugin.options[:never_update] = true
end
```

To return to using the Rails-based compilation mode, simply delete
the compiled stylesheets and remove any configuration changes.

### Compiling for Production without Asset Pipeline

If not using the asset pipeline run:

    $ bundle exec compass compile -e production --force

It is suggested that you compile your stylesheets as part of the deploy
or build process. However, some people choose to check in their compiled
stylesheets.

### Installing Compass extensions

Step 1: Add it to your Gemfile in the `:assets` group and run the `bundle` command to install it.

Step 2: Install the extension's assets: `bundle exec compass install 
<extension/template>`

For example, if you want to use susy.

```ruby
# Gemfile
group :assets do
  gem 'compass-rails'
  gem 'compass-susy-plugin'
end
```

then run:

    $ bundle
    $ bundle exec compass install susy
    
if you are using the rails configuration files you should add:

```ruby
config.compass.require "susy"
```

to your application.rb configuration file.

## Rails 3.1 Caveats

compass-rails requires Rails 3.1.1 and greater. Also, Rails 3.1 is out of support so consider upgrading.

## Rails 3.0 Caveats

If you want rails to compile your stylesheets (instead of using the
compass watcher) you need to edit `config/application.rb` and change:

```ruby
Bundler.require(:default, Rails.env) if defined?(Bundler)
```

to this:

```ruby
Bundler.require(:default, :assets, Rails.env) if defined?(Bundler)
```

 Also, Rails 3.0 is out of support so consider upgrading.

## Upgrading Rails 3.0 and older projects to compass-rails

First and foremost, follow the installation instructions above.

CompassRails uses the rails convention for stylesheet locations even in
older versions of rails that do not use the assets pipeline.
If you have your stylesheets already in `app/stylesheets`, you have two choices:

1. Move your stylesheets to `app/assets/stylesheets`.
2. Configure your project to look in the **legacy location** of
   `app/stylesheets` by setting `config.compass.sass_dir =
   "app/stylesheets"` in your rails configuration or by setting
   `sass_dir = "app/stylesheets"` in your compass configuration file.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
