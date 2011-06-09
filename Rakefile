require 'bundler/gem_tasks'

Dir.glob('lib/tasks/*.rake').each { |r| import r }

require 'rcov/rcovtask'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :rcov => ["functional"] do
end

task :clean do
  puts 'Cleaning old coverage.data'
  FileUtils.rm('coverage.data') if(File.exists? 'coverage.data')
end

task :default => [:rcov, :doc]
