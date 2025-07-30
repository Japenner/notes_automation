# frozen_string_literal: true

require 'thor'

require_relative 'cli/parse'

module NotesAutomation
  class CLI < Thor
    package_name 'Notes Automation'

    desc 'parse', 'Commands related to parsing'
    subcommand 'parse', CLI::Parse

    # Add an exit behavior to suppress the deprecation warning
    def self.exit_on_failure?
      true
    end
  end
end
