$:.unshift File.expand_path("../lib", __FILE__)
require 'bundler'
require 'puppet_litmus/rake_tasks' if Bundler.rubygems.find_name('puppet_litmus').any?
require 'puppetlabs_spec_helper/rake_tasks'
require 'dropsonde/version'

task :default do
  system("rake -T")
end

require 'github_changelog_generator/task'
GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user = 'OpenVoxProject'
  config.project = 'dropsonde'
  config.future_release = Dropsonde::VERSION
end

require 'rspec/core/rake_task'
namespace :dropsonde do
  RSpec::Core::RakeTask.new(:acceptance) do |t|
    t.pattern = 'spec/acceptance/**{,/*/**}/*_spec.rb'
  end
end
