#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :jslint]

desc "Check the JavaScript source with JSLint - exit with status 1 if any of the files fail."
task :jslint do
  failed_files = []
  paths = Dir['public/**/*.js'].reject{|path| path =~ /public\/docs*\//}
  paths = paths.reject{|path| path =~ /public\/js\/ace\//}
  paths = paths.reject{|path| path =~ /public\/js\/annyang.*/}
  paths = paths.reject{|path| path =~ /public\/js\/console.*/}
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
