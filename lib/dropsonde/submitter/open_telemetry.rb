# frozen_string_literal: true

# This currently doesn't actually exist.
# It's just a placeholder for someday when it does exist!
class Dropsonde::Submitter::OpenTelemetry
  def self.submit_report(options)
    puts 'When Vox Pupuli has its own telemetry server, this will post there.'
    puts options.inspect
  end
end
