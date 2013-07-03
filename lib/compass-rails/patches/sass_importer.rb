module Sprockets
  class SassTemplate < Tilt::Template
    def evaluate(context, locals, &block)
      # Use custom importer that knows about Sprockets Caching
      cache_store = SassCacheStore.new(context.environment)
      paths  = context.environment.paths.map { |path| CompassRails::SpriteImporter.new(context, path) }
      paths += context.environment.paths.map { |path| SassImporter.new(context, path) }
      paths += ::Rails.application.config.sass.load_paths


      options = CompassRails.sass_config.merge( {
        :filename => eval_file,
        :line => line,
        :syntax => syntax,
        :cache_store => cache_store,
        :importer => SassImporter.new(context, context.pathname),
        :load_paths => paths,
        :sprockets => {
          :context => context,
          :environment => context.environment
        }
      })

      ::Sass::Engine.new(data, options).render
    rescue ::Sass::SyntaxError => e
      # Annotates exception message with parse line number
      context.__LINE__ = e.sass_backtrace.first[:line]
      raise e
    end
  end
end
