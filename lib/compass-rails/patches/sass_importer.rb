klass = if defined?(Sass::Rails::SassTemplate)
  Sass::Rails::SassTemplate
else
  Sprockets::SassTemplate
end

klass.class_eval do
  def evaluate(context, locals, &block)
    # Use custom importer that knows about Sprockets Caching
    cache_store = 
      if defined?(Sprockets::SassCacheStore)
        Sprockets::SassCacheStore.new(context.environment)
      else
        Sprockets::SassProcessor::CacheStore.new(sprockets_cache_store, context.environment)
      end

    paths  = context.environment.paths.map { |path| CompassRails::SpriteImporter.new(path) }
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

    engine = ::Sass::Engine.new(data, options)

    engine.dependencies.map do |dependency|
      filename = dependency.options[:filename]
      if filename.include?('*') # Handle sprite globs
        image_path = Rails.root.join(Compass.configuration.images_dir).to_s
        Dir[File.join(image_path, filename)].each do |f|
          context.depend_on(f)
        end
      else
        context.depend_on(filename)
      end
    end

    engine.render
  rescue ::Sass::SyntaxError => e
    # Annotates exception message with parse line number
    context.__LINE__ = e.sass_backtrace.first[:line]
    raise e
  end

  private

  def sass_importer_artiy
    @sass_importer_artiy ||= self.class.parent::SassImporter.instance_method(:initialize).arity
  end


  def sass_importer(context, path)
    case sass_importer_artiy.abs
    when 1
      self.class.parent::SassImporter.new(path)
    else
      self.class.parent::SassImporter.new(context, path)
    end
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

