# Compass::Rails

Compass rails is an adapter for the [Compass Stylesheet Authoring
Framework](http://compass-style.org) for [Ruby on Rails](http://http://rubyonrails.org/).

Since Compass v0.12, this adapter is the only way to install compass
into your rails application.

This adapter supports rails versions 2.3 and greater. Rails 2.3 users
please read the caviats below.

## Installation

Add the `compass-rails` gem line to a group called `:assets` in your application's Gemfile (Rails 3.1+ users should already have the `:assets` group):

    group :assets do
      gem 'compass-rails'
    end

If you are using any Compass extensions, add them to this group in your
Gemfile.

And then execute:

    $ bundle

To set up your project with starter stylesheets and a configuration
file:

    $ bundle exec compass init

If using a compass-based framework (like [susy](http://susy.oddbird.net/) or [blueprint](http://compass-style.org/reference/blueprint/)) then you can use the `--using` option:

    $ bundle exec compass init --using blueprint

Note that the `compass init` step is optional if you have a project running Rails 3.0 or greater.

## Upgrading existing rails projects using Compass to CompassRails

First and foremost, follow the installation instructions above.

CompassRails uses the rails convention for stylesheet locations even in
older versions of rails that do not use the assets pipeline.
If you have your stylesheets already in `app/stylesheets`, you have two choices:

1. Move your stylesheets to `app/assets/stylesheets`.
2. Configure your project to look in `app/assets/stylesheets` by setting
   `config.compass.sass_dir = "app/stylesheets"` in your rails
configuration or by setting `sass_dir = "app/stylesheets"` in your
compass configuration file.

## Configuration

If you have a compass configuration file (recommended) then you can
use the [Compass configuration 
reference](http://compass-style.org/help/tutorials/configuration-reference/)
as is. If you choose to configure compass from your rails configuration
files, then you should understand that the compass configuration
options explained there will be methods and properties on the `config.compass`
configuration object exposed to rails within any configuration block.

## Usage

### Developing with Rails-based Compilation

By default, your sass files in `app/assets/stylesheets` will be
automatically compiled by the the [`Sass::Plugin`](http://sass-lang.com/docs/yardoc/Sass/Plugin.html) or the [Rails asset
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

    config.after_initialize do
      Sass::Plugin.options[:never_update] = true
    end

To return to using the Rails-based compilation mode, simply delete
the compiled stylesheets and remove any configuration changes.

### Compiling for Production

If using the Rails asset pipeline run:

    $ rake assets:precompile

If not using the asset pipeline run:

    $ bundle exec compass compile -e production --force

It is suggested that you compile your stylesheets as part of the deploy
or build process. However, some people choose to check in their compiled
stylesheets.

### Notes On Sprockets Directives

Sprockets, used by the rails asset pipeline, provides directives for
doing things like requiring. These **must not** be used with Sass files.
Instead use the sass `@import` directive. In rails projects, the
`@import` directive is configured to work with sprockets via `sass-rails`. For more information on importing in rails 3.1 or greater see the [Sass-Rails REAME](https://github.com/rails/sass-rails/blob/master/README.markdown)

## Rails 2.3 Caviats

Compass requires that your rails 2.3 project is using Bundler to manage
your rubygems. If you haven't yet set up your rails 2.3 project to use Bundler,
please do so prior to upgrading. [Bundler installation guide for rails
2.3](http://gembundler.com/rails23.html).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
