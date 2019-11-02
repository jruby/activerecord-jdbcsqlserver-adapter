require 'bundler/gem_tasks'
require 'rake/testtask'
require_relative 'test/support/paths_sqlserver'
require_relative 'test/support/rake_helpers'

if defined? JRUBY_VERSION
  task test: ['test:jdbc']
else
  task test: ['test:dblib']
end
task default: [:test]

namespace :test do

  %w(dblib jdbc).each do |mode|

    Rake::TestTask.new(mode) do |t|
      t.libs = ARTest::SQLServer.test_load_paths
      t.test_files = test_files
      t.warning = !!ENV['WARNING']
      t.verbose = false
    end

    task "#{mode}:env" do
      ENV['ARCONN'] = mode
    end

    task mode => "test:#{mode}:env"
  end

end

namespace :profile do
  ['dblib'].each do |mode|
    namespace mode.to_sym do
      Dir.glob('test/profile/*_profile_case.rb').sort.each do |test_file|
        profile_case = File.basename(test_file).sub('_profile_case.rb', '')
        Rake::TestTask.new(profile_case) do |t|
          t.libs = ARTest::SQLServer.test_load_paths
          t.test_files = [test_file]
          t.verbose = true
        end
      end
    end
  end
end
