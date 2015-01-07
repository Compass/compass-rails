require 'sprockets'
require 'compass/sprite_importer'

module CompassRails
  class SpriteImporter < Compass::SpriteImporter
    attr_reader :context, :root

    def initialize(root)
      @root = root
    end

    def find(uri, options)
      if old = super(uri, options)
        self.class.files(uri).each do |file|
          relative_path = Pathname.new(file).relative_path_from(Pathname.new(root))
          begin
            context = options[:sprockets][:context]
            pathname = context.resolve(relative_path)
            context.depend_on_asset(pathname)
          rescue Sprockets::FileNotFound

          end
        end
      end

      old
    end
  end
end
