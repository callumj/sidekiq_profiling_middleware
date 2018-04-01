# frozen_string_literal: true
require "sidekiq_profiling_middleware/util"
require "memory_profiler"

module SidekiqProfilingMiddleware
  class MemoryProfiler
    def initialize(output_prefix: nil, only: nil, s3_bucket: nil, memory_profiler_options: {})
      @options = memory_profiler_options

      @output_prefix = output_prefix || self.class.default_output_prefix
      @only = only
      @s3_bucket = s3_bucket
    end

    def call(worker, msg, queue)
      # bail out if whitelist doesn't match
      if only && !only.include?(worker.class)
        return yield
      end

      report = ::MemoryProfiler.report(options) do
        yield
      end

      out = "#{output_prefix}#{Util.worker_names[worker.class]}_#{Util.current_epoch_ms}.txt"

      unless s3_bucket
        report.pretty_print(to_file: out)
        return
      end

      require "sidekiq_profiling_middleware/s3"

      out = S3::Object.new(bucket: s3_bucket, key: out)
      report.pretty_print(out)
    ensure
      out.upload if out && s3_bucket
    end

    def self.default_output_prefix
      @default_output_prefix ||= Util.default_output_prefix("memory_profiler")
    end

    private

    attr_reader(
      :only,
      :options,
      :output_prefix,
      :s3_bucket,
    )
  end
end
