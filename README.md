# sidekiq_profiling_middleware

Profile Sidekiq with StackProf & MemoryProfiler with optional support for S3 exports.

## Installation

Two middleware classes are available:

* `SidekiqProfilingMiddleware::StackProf`: requires [stackprof](https://github.com/tmm1/stackprof)
* `SidekiqProfilingMiddleware::MemoryProfile`: requires [memory_profiler](https://github.com/SamSaffron/memory_profiler)

(You should only use one at a time, otherwise that will be quite confusing)

```ruby
Sidekiq.configure_server do |config|
  ....
  config.server_middleware do |chain|
    chain.add SidekiqProfilingMiddleware::StackProf, only: [ThisReallySlowWorker].set, s3_bucket: "cj-profiling"
    # OR
    chain.add SidekiqProfilingMiddleware::StackProf, output_prefix: "tmp/#{Rails.env}_#{ENV["GIT_SHA"]}"
  end
end
```

## Concurrency (set it to 1)

The hooks provided by Ruby that are used by StackProf & MemoryProfiler are not able to distinguish threads well, so you will need to set your Sidekiq `concurrency` to `1`. This will ensure that only one job operates at a time ensuring other jobs don't confuse your memory profile or stacktraces.

With this in mind you should set this up on a separate Sidekiq instance so as not to drop the concurrency capability of your Sidekiq cluster.

## S3 exporting

If you run Sidekiq in a Dockerized environment like ECS or Kubernetes you will probably not want profiling reports dumped to a filesystem path as you don't want to bloat the container size and track down which Docker host contains the profiles. To solve this you can have profiles uploaded to S3 using the option `s3_bucket`.

The AWS SDK is used so you'll want to set your AWS config/credentials using environment variables or EC2 instance profiles (preferred when running inside AWS). See [Setup Config](https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/setup-config.html) for more info.

Alternatively you can configure the client using `SidekiqProfilingMiddleware::S3.client = .....`.