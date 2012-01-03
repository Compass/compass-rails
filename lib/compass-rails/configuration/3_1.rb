module CompassRails
  module Configuration
    module Rails3_1

      def default_sass_dir
        File.join("app", "assets", "stylesheets")
      end

      def default_images_dir
        File.join("app", "assets", "images")
      end

      def default_fonts_dir
        File.join("app", "assets", "fonts")
      end

      def default_javascripts_dir
        File.join("app", "assets", "javascripts")
      end

      def default_http_path
        CompassRails.prefix
      end

      def default_http_images_path
        "#{top_level.http_path}"
      end

      def default_http_generated_images_path
        "#{top_level.http_path}"
      end

      def default_http_javascripts_path
        "#{top_level.http_path}"
      end

      def default_http_fonts_path
        "#{top_level.http_path}"
      end

      def default_http_stylesheets_path
        "#{top_level.http_path}"
      end

    end
  end
end