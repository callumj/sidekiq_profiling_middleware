# frozen_string_literal: true
Gem::Specification.new do |s|
  s.name        = "sidekiq_profiling_middleware"
  s.version     = "0.0.3"
  s.date        = "2010-04-28"
  s.summary     = "StackProf and MemoryProfiler middleware for Sidekiq"
  s.authors     = ["Callum Jones"]
  s.email       = "contact@callumj.com"
  s.files       = %w(
    lib/sidekiq_profiling_middleware/memory_profiler.rb
    lib/sidekiq_profiling_middleware/s3.rb
    lib/sidekiq_profiling_middleware/stack_prof.rb
    lib/sidekiq_profiling_middleware/util.rb
  )
  s.homepage    = "https://github.com/callumj/sidekiq_profiling_middleware"
  s.license     = "MIT"

  s.add_development_dependency "rubocop", "0.54.0"
end
