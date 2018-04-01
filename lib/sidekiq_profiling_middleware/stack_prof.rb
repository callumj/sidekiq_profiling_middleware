# frozen_string_literal: true
require "sidekiq_profiling_middleware/util"
require "stackprof"

module SidekiqProfilingMiddleware
  class StackProf
    def initialize(output_prefix: nil, only: nil, s3_bucket: nil, stack_prof_options: {})
      stack_prof_options[:mode] ||= :cpu
      stack_prof_options[:interval] ||= 1000
      @options = stack_prof_options

      @output_prefix = output_prefix || self.class.default_output_prefix
      @only = only
      @s3_bucket = s3_bucket
    end

    def call(worker, msg, queue)
      # bail out if whitelist doesn't match
      if only && !only.include?(worker.class)
        return yield
      end

      out = "#{output_prefix}#{Util.worker_names[worker.class]}_#{Util.current_epoch_ms}.dump"

      unless s3_bucket
        ::StackProf.run(options.merge(out: out)) { yield }
        return
      end

      require "sidekiq_profiling_middleware/s3"

      out = S3::Object.new(bucket: s3_bucket, key: out)
      rep = ::StackProf.run(options) { yield }
      Marshal.dump(rep, out)
    ensure
      out.upload if out && s3_bucket
    end

    def self.default_output_prefix
      @default_output_prefix ||= Util.default_output_prefix("stackprof")
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
