require 'rspec/snapshot/matchers/match_snapshot'

module RSpec
  module Snapshot
    # Matchers providing snapshot testing capabilities.
    module Matchers
      def match_snapshot(snapshot_name)
        MatchSnapShot.new(self.class.metadata, snapshot_name)
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Snapshot::Matchers
end
