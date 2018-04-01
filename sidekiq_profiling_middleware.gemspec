# frozen_string_literal: true
Gem::Specification.new do |s|
  s.name        = "sidekiq_profiling_middleware"
  s.version     = "0.0.1"
  s.date        = "2010-04-28"
  s.summary     = "StackProf and MemoryProfiler middleware for Sidekiq"
  s.description = "StackProf and MemoryProfiler middleware for Sidekiq"
  s.authors     = ["CallumJones"]
  s.email       = "contact@callumj.com"
  s.files       = %w(
    lib/sidekiq_profiling_middleware/memory_profiler.rb
    lib/sidekiq_profiling_middleware/stack_prof.rb
    lib/sidekiq_profiling_middleware/util.rb
  )
  s.homepage    = "http://rubygems.org/gems/sidekiq_profiling_middleware"
  s.license     = "MIT"

  s.add_development_dependency "rubocop"
end
