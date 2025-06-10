# frozen_string_literal: true

# This uses Puppet's standard Dujour telemetry endpoint.
# It currently expects a report formatted precisely to meet Dujour's odd schema.
# At some point, we'll define our own report format and this submitter will
# transform it to meet the expected schema.
#
# This is currently the only operational submitter.
class Dropsonde::Submitter::Dujour
  def self.submit_report(options)
    client = HTTPClient.new

    endpoint = options[:endpoint] || Dropsonde.settings[:endpoint] || 'https://updates.puppet.com'
    port     = options[:port]     || Dropsonde.settings[:port]     || 443

    # The httpclient gem ships with some expired CA certificates.
    # This causes us to load the certs shipped with whatever
    # Ruby is used to execute this gem's commands, which are generally
    # more up-to-date, especially if using puppet-agent's Ruby.
    #
    # Note that this is no-op with Windows system Ruby.
    client.ssl_config.set_default_paths

    result = client.post("#{endpoint}:#{port}",
                         header: { 'Content-Type' => 'application/json' },
                         body: Dropsonde::Metrics.new.report.to_json)

    if result.status == 200
      data = JSON.parse(result.body)
      if data['newer']
        puts 'A newer version of the telemetry client is available:'
        puts "  -- #{data['link']}"
      else
        puts data['message']
      end
    else
      puts 'Failed to submit report'
      puts JSON.pretty_generate(result.body) if Dropsonde.settings[:verbose]
      exit 1
    end
  end
end
