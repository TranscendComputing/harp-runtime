#!/usr/bin/env rake
require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  # Probably not in dev/test
end

task :default => [:spec, :jslint, "analyzer:all"]

desc "Check the JavaScript source with JSLint - exit with status 1 if any of the files fail."
task :jslint do
  failed_files = []
  paths = Dir['public/**/*.js'].reject{|path| path =~ /public\/docs*\//}
  paths = paths.reject{|path| path =~ /public\/js\/ace\//}
  paths = paths.reject{|path| path =~ /public\/js\/annyang.*/}
  paths = paths.reject{|path| path =~ /public\/js\/console.*/}
  paths = paths.reject{|path| path =~ /public\/js\/enc-base64-min.*/}
  paths = paths.reject{|path| path =~ /public\/js\/hmac-sha256.*/}
  paths = paths.reject{|path| path =~ /public\/vendor\/.*/}
  paths.each do |fname|
    cmd = "jslint #{fname}"
    results = %x{#{cmd}}
    unless results =~ /^jslint: No problems found in/
      puts "#{fname}:"
      puts results
      failed_files << fname
    end
  end
  if failed_files.size > 0
    exit 1
  end
end

begin
  namespace :analyzer do
    desc "run all code analyzing tools (flog)"

    task :all => ["flog:total", "flay:flay"]

    namespace :flog do
      require 'flog_cli'
      desc "Analyze total code complexity with flog"
      task :total do
        threshold = 10
        flog = FlogCLI.new
        flog.flog %w(app lib spec)
        average = flog.average.round(1)
        total_score = flog.total_score
        puts "Average complexity: #{flog.average.round(1)}"
        puts "Total complexity: #{flog.total_score.round(1)}"
        flog.report
        fail "Average code complexity has exceeded max! (#{average} > #{threshold})" if average > threshold
      end
    end

    namespace :flay do
      require 'flay_task'
      FlayTask.new() do |t|
        t.verbose = true
        t.threshold = 2000
      end
    end
  end
rescue LoadError => err
  # not in dev/test env - skip installing these tasks
end
