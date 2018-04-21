require 'fileutils'
require 'htmlbeautifier'
require 'diffy'

module RSpec
  module Snapshot
    module Matchers
      # Matcher class, compares two snapshots
      class MatchSnapShot
        def initialize(metadata, snapshot_name)
          @metadata = metadata
          @snapshot_name = snapshot_name
        end

        def matches?(actual)
          @actual = HtmlBeautifier.beautify(actual)
          snap_path = File.join(snapshot_dir, "#{@snapshot_name}.snap")
          dir = File.dirname(snap_path)
          FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

          if File.exist?(snap_path)
            @expected = File.read(snap_path)
            @actual == @expected
          else
            store_snapshot(@actual, snap_path)
          end
        end

        def failure_message
          "\nSnapshots do not match:\n\n #{diff}"
        end

        private

        def store_snapshot(snapshot, snap_path)
          message = "Generating snapshot: #{snap_path}"
          RSpec.configuration.reporter.message(message)
          File.write(snap_path, snapshot)
          true
        end

        def diff
          diff_string = Diffy::Diff.new(@expected, @actual).to_s
          diff_string.gsub('\ No newline at end of file', '')
        end

        def snapshot_dir
          if RSpec.configuration.snapshot_dir.to_s == 'relative'
            File.dirname(@metadata[:file_path]) << '/__snapshots__'
          else
            RSpec.configuration.snapshot_dir
          end
        end
      end
    end
  end
end
