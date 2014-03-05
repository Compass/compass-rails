module CompassRails
  module Test
    module FileHelper
      include DebugHelper

      def mkdir_p(dir)
        debug(Rainbow("Creating Directory: #{dir}").foreground(:green))
        ::FileUtils.mkdir_p dir
        assert File.directory?(dir), "mkdir_p: #{dir} failed"
      end

      def rm_rf(path)
        debug(Rainbow("Removing: #{path}").foreground(:red))
        ::FileUtils.rm_rf(path)
        assert !File.directory?(path), "rm_rf: #{path} failed"
      end

      def cd(path, &block)
        debug(Rainbow("Entered: #{path}").foreground(:yellow))
        Dir.chdir(path, &block)
      end

      def inject_at_bottom(file_name, string)
        content = File.read(file_name)
        content = "#{content}#{string}"
        File.open(file_name, 'w') { |file| file << content }
      end

      def touch(file)
        debug(Rainbow("Touching File: #{file}").foreground(:green))
        ::FileUtils.touch(file)
      end

      def inject_into_file(file_name, replacement, position, anchor)
        case position
        when :after
          replace(file_name, Regexp.escape(anchor), "#{anchor}#{replacement}")
        when :before
          replace(file_name, Regexp.escape(anchor), "#{replacement}#{anchor}")
        else
          raise Compass::FilesystemConflict.new("You need to specify :before or :after")
        end
      end

      def replace(destination, regexp, string)
        content = File.read(destination)
        content.gsub!(Regexp.new(regexp), string)
        File.open(destination, 'wb') { |file| file.write(content) }
      end

    end
  end
end
