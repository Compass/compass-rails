klass = if defined?(Sass::Rails::SassTemplate)
  Sass::Rails::SassTemplate
else
  Sprockets::SassTemplate
end

klass.class_eval do
  def evaluate(context, locals, &block)
    # Use custom importer that knows about Sprockets Caching
    cache_store = begin Sprockets::SassCacheStore.new(context.environment); rescue; nil; end ||
        Sprockets::SassProcessor::CacheStore.new(sprockets_cache_store, context.environment)
    paths  = context.environment.paths.map { |path| CompassRails::SpriteImporter.new(context, path) }
    paths += context.environment.paths.map { |path| sass_importer(context, path) }
    paths += ::Rails.application.config.sass.load_paths


    options = CompassRails.sass_config.merge( {
      :filename => eval_file,
      :line => line,
      :syntax => syntax,
      :cache_store => cache_store,
      :importer => sass_importer(context, context.pathname),
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

  private
  def sass_importer(context, path)
    begin self.class.parent::SassImporter.new(context, path); rescue; nil; end ||
        self.class.parent::SassImporter.new(path)
  end

  def sprockets_cache_store
    case Rails.application.config.assets.cache_store
      when :null_store
        Sprockets::Cache::NullStore.new
      when :memory_store, :mem_cache_store
        Sprockets::Cache::MemoryStore.new
      else
        Sprockets::Cache::FileStore.new(Dir::tmpdir)
    end
  end
end    

