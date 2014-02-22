# compass-rails

**We Take Pull Requests!**

[![Build Status](https://travis-ci.org/Compass/compass-rails.png?branch=stable)](https://travis-ci.org/Compass/compass-rails)
[![Code Climate](https://codeclimate.com/github/Compass/compass-rails.png)](https://codeclimate.com/github/Compass/compass-rails)

Compass rails is an adapter for the [Compass Stylesheet Authoring
Framework](http://compass-style.org) for [Ruby on Rails](http://rubyonrails.org/).

Since Compass v0.12.0, this is the only way to use compass with your rails application.

Supports Rails 3.x, 4.x releases.

## Installation
### Rails 3.x
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

### Rails 4.x
Starting with Rails 4, the `:assets` group from the Gemfile has been [removed](http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-3-2-to-rails-4-0-gemfile). Simply add the `compass-rails` gem line to the Gemfile:

```ruby
gem 'sass-rails' # included by default in Rails 4
gem 'compass-rails'
```

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

### Configuration

If you have a compass configuration file (recommended) then you can
use the [Compass configuration 
reference](http://compass-style.org/help/tutorials/configuration-reference/)
as is. If you choose to configure compass from your rails configuration
files, then you should understand that the compass configuration
options explained there will be methods and properties on the `config.compass`
configuration object exposed to rails within any configuration block.

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
