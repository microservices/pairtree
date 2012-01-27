Dir.glob('lib/tasks/*.rake').each { |r| import r }

require 'rake'
require 'rspec/core/rake_task'

begin
  if RUBY_VERSION < "1.9"
require 'rcov/rcovtask'
desc "Generate code coverage"
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec', '--exclude', 'gems']
end
  end
rescue
end

RSpec::Core::RakeTask.new(:spec)

task :clean do
  puts 'Cleaning old coverage.data'
  FileUtils.rm('coverage.data') if(File.exists? 'coverage.data')
end

task :default => [:rcov, :doc]
