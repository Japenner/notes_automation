# frozen_string_literal: true

require 'thor'

module NotesAutomation
  module Commands
    class BaseCommand < Thor
      # Customize the banner to display the subcommand and command usage more cleanly
      def self.banner(command, _namespace = nil, _subcommand = false) # rubocop:disable Style/OptionalBooleanParameter
        "#{basename} #{subcommand_prefix} #{command.usage}"
      end

      # Generate a prefix for subcommands (e.g., 'issue-generate' for Issue#generate)
      def self.subcommand_prefix
        name.gsub(/.*::/, '')
            .gsub(/^[A-Z]/, &:downcase)
            .gsub(/[A-Z]/) { |match| "-#{match.downcase}" }
      end

      # Helper method to log messages consistently across commands
      no_commands do
        def log(message, level = :info)
          @logger ||= Logger.new($stdout)
          @logger.public_send(level, message)
        end
      end

      # Define shared options here if needed, e.g., API keys, tokens, etc.
      # class_option :api_key, type: :string,
      #                        desc: 'API Key for OpenAI',
      #                        default: ENV['OPENAI_API_KEY']

      # class_option :pat, type: :string,
      #                    desc: 'GitHub Personal Access Token',
      #                    default: ENV['GITHUB_PAT_AD_HOC']
    end
  end
end
