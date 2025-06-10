$:.unshift File.expand_path("../lib", __FILE__)
require 'date'
require 'dropsonde/version'

Gem::Specification.new do |s|
  s.name              = "dropsonde"
  s.version           = Dropsonde::VERSION
  s.date              = Date.today.to_s
  s.summary           = "A simple telemetry probe for gathering usage information about OpenVox and Puppet infrastructures."
  s.homepage          = "https://github.com/OpenVoxProject/dropsonde"
  s.license           = 'Apache-2.0'
  s.email             = "binford2k@overlookinfratech.com"
  s.authors           = ["Ben Ford"]
  s.require_path      = "lib"
  s.executables       = %w( dropsonde )
  s.files             = %w( README.md LICENSE CHANGELOG.md )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")
  s.add_dependency      "json"
  s.add_dependency      "gli"
  s.add_dependency      "httpclient"
  s.add_dependency      "little-plugger"
  s.add_dependency      "puppet_forge"
  s.add_dependency      "semantic_puppet"
  s.add_dependency      "inifile"
  s.add_dependency      "puppetdb-ruby"

  s.description       = <<~desc
  Dropsonde is a simple telemetry probe designed to run as a regular cron job. It
  will gather metrics defined by self-contained plugins that each defines its own
  partial schema and then gathers the data to meet that schema.
  desc

  s.post_install_message = <<~desc
  For portability reasons, this gem no longer depends on Puppet. You will need to
  install either Puppet or OpenVox gems manually.
  desc

end
