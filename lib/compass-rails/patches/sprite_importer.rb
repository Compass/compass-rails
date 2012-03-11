require 'sprockets'
require 'compass/sprite_importer'

module Compass
  class SpriteImporter < Sass::Importers::Base

    alias :old_find :find

    def find(uri, options)

      if old = old_find(uri, options)
        @_options = options
        self.class.files(uri).each do |file|
          if pathname = resolve(file)
            context.depend_on(pathname)
          end
        end
      end

      old
    end

  private

    def resolve(uri)
      resolver.resolve(Pathname.new(uri))
    end

    def context
     resolver.context
    end

    def resolver
      @_options[:custom][:resolver]
    end

  end
end
