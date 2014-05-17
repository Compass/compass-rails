# compass-rails

**We Take Pull Requests!**

[![Build Status](https://travis-ci.org/Compass/compass-rails.png?branch=master)](https://travis-ci.org/Compass/compass-rails)
[![Code Climate](https://codeclimate.com/github/Compass/compass-rails.png)](https://codeclimate.com/github/Compass/compass-rails)

Compass rails is an adapter for the [Compass Stylesheet Authoring
Framework](http://compass-style.org) for [Ruby on Rails](http://rubyonrails.org/).

Since Compass v0.12.0, this is the only way to use compass with your rails application.

Supports Rails 3.2, 4.x releases.

## Installation

Add the `compass-rails` gem line to your application's Gemfile

```ruby
gem 'sass-rails'
gem 'compass-rails'
```

If you are using any Compass extensions, add them to this group in your
Gemfile.

And then execute:

    $ bundle

## Usage

Change your `application.css` to `application.css.scss` or `application.css.sass` and then `@import compass` and your own stylesheets to your hearts content. E.g.:

```scss
@import "compass";

@import "your_project/mixins";
@import "your_project/base";
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

Step 1: Add it to your Gemfile and run the `bundle` command to install it.

Step 2: Install the extension's assets: `bundle exec compass install 
<extension/template>`

For example, if you want to use susy.

```ruby
# Gemfile
gem 'compass-rails'
gem 'compass-susy-plugin'
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
