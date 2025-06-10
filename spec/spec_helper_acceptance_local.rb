# frozen_string_literal: true

require 'ostruct'
require 'puppet/info_service'
require 'puppet/info_service/class_information_service'

def run_local_command(command, opts = {})
  result = Open3.capture3(command)
  if opts[:expect_failures] || result[2] != 0
    if opts[:expect_failures]
      return OpenStruct.new(
        stdout: "ERROR: #{result[0]}",
        stderr: result[1],
        exit_code: result[2],
      )
    else
      puts "COMMAND: #{command}"
      puts "STDOUT: #{result[0]}"
      puts "STDERR: #{result[1]}"
      puts "STATUS_CODE: #{result[2]}"
    end
  end
  OpenStruct.new(
    stdout: result[0],
    stderr: result[1],
    exit_code: result[2],
  )
end

class CISest
  def classes_per_environment(_env_hash)
    {
      production:
        {
          '/etc/puppetlabs/code/environments/production/modules/stdlib/manifests/init.pp':
          {
            classes: [{ name: 'stdlib' }],
          },
        },
    }
  end
end

class EnvList
  def list
    [OpenStruct.new(name: 'production')]
  end

  def get(env)
    raise 'Unexpected environment' unless [:production, 'production'].include? env

    OpenStruct.new(modules: [
       OpenStruct.new(
         name: 'mysql',
         slug: 'puppetlabs-mysql',
         version: '11.0.1',
         forge_module?: true,
         dependencies: [
           { name: 'puppetlabs/stdlib', version_requirement: '>= 3.2.0 < 8.0.0' },
           { name: 'puppetlabs/resource_api', version_requirement: '>= 1.0.0 < 2.0.0' },
         ],
         all_manifests: [],
       ),
       OpenStruct.new(
         name: 'apache',
         slug: 'puppetlabs-apache',
         version: '6.0.0',
         forge_module?: true,
         dependencies: [
           { name: 'puppetlabs/stdlib', version_requirement: '>= 4.13.1 < 8.0.0' },
           { name: 'puppetlabs/concat', version_requirement: '>= 2.2.1 < 8.0.0' },
         ],
         all_manifests: [],
       ),
       OpenStruct.new(
         name: 'concat',
         slug: 'puppetlabs-concat',
         version: '7.0.1',
         forge_module?: true,
         dependencies: [{ name: 'puppetlabs/stdlib', version_requirement: '>= 4.13.1 < 8.0.0' }],
         all_manifests: [],
       ),
       OpenStruct.new(
         name: 'stdlib',
         slug: 'puppetlabs-stdlib',
         version: '7.0.1',
         forge_module?: true,
         dependencies: [],
         all_manifests: ['/etc/puppetlabs/code/environments/production/modules/stdlib/manifests/init.pp'],
       ),
       OpenStruct.new(
         name: 'my_private_module',
         slug: 'my_private_module',
         version: '4.1.0',
         forge_module?: false,
         dependencies: [
           { name: 'private_module_1', version_requirement: '>= 4.24.0 < 8.0.0' },
           { name: 'private_module_2', version_requirement: '>= 4.4.1 < 9.0.0' },
           { name: 'puppetlabs/powershell', version_requirement: '>= 2.1.4 < 6.0.0' },
           { name: 'puppetlabs/reboot', version_requirement: '>=2.0.0 < 5.0.0' },
         ],
         all_manifests: [],
       ),
     ])
  end
end

RSpec.configure do |c|
  c.formatter = :documentation
  c.before :each do
    allow(Puppet).to receive(:lookup).with(:environments).at_least(2).and_return(EnvList.new)
    allow(Puppet::InfoService::ClassInformationService).to receive(:new).and_return(CISest.new)
  end
end
