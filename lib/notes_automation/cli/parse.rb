# frozen_string_literal: true

require 'logger'
require_relative '../commands/base_command'
require_relative '../commands/parse/notes'

module NotesAutomation
  class CLI < Thor
    class Parse < Commands::ParseCommand
      # method_option :dir, type: :string,
      #                     aliases: '-d',
      #                     desc: 'The directory to build the script in',
      #                     default: '.'

      # method_option :filename, type: :string,
      #                          aliases: '-f',
      #                          desc: 'The name of the script file',
      #                          default: 'script'

      # option :gem_path, type: :string,
      #                   aliases: '-g',
      #                   default: "#{Dir.home}/repos/personal/jacobs_toolbox",
      #                   desc: "Path to the host gem's root directory"

      # option :prompt_path, type: :string,
      #                      aliases: '-p',
      #                      default:
      #                       "#{Dir.home}/Repos/personal/jacobs_toolbox/lib/jacobs_toolbox/prompts/build_script.md",
      #                      desc: 'Path to the prompt file with placeholders'

      desc 'parse', 'Parse markdown notes'
      def notes
        NotesAutomation::Commands::Parse::Notes.run(options)
      end
    end
  end
end
