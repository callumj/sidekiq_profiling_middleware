# frozen_string_literal: true
module SidekiqProfilingMiddleware
  class Util
    BOOTED_AT_FORMAT = "%m-%d-%H-%M-%S"

    def self.default_output_prefix(name)
      "tmp/#{name}_bootedat#{Time.now.strftime(BOOTED_AT_FORMAT)}_"
    end

    def self.worker_names
      # allocate hash for quickly converting class names to
      # nice names a file system would like
      @worker_names ||= Hash.new do |hash, worker_name|
        hash[worker_name] = worker_name.to_s.gsub(/\W+/, "_").gsub(/(^_|_$)/, "")
      end
    end

    def self.current_epoch_ms
      (Time.now.utc.to_f * 1000).to_i
    end
  end
end
