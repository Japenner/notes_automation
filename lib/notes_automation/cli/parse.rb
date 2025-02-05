# frozen_string_literal: true

require 'logger'
require_relative '../commands/base_command'
require_relative '../commands/parse/notes'

module NotesAutomation
  class CLI < Thor
    class Parse < Commands::ParseCommand
      method_option :recent, type: :integer,
                             aliases: '-r',
                             desc: 'Number of recent entries to show (default: 15)',
                             default: 15

      method_option :path, type: :string,
                           aliases: '-p',
                           desc: 'Path to folder of .md files to publish',
                           default: File.expand_path("~/repos/personal/obsidian")

      method_option :use_git_times, type: :string,
                                    aliases: '-g',
                                    desc: 'Use git modified time instead of file mtime',
                                    default: true

      method_option :feed, type: :array,
                           aliases: '-f',
                           desc: 'A directory to generate a separate feed for. Can be given multiple times',
                           default: []

      method_option :help, type: :nil,
                           aliases: '-h',
                           desc: 'Prints this help',

      desc 'parse', 'Parse markdown notes'
      def notes
        NotesAutomation::Commands::Parse::Notes.run(options)
      end
    end
  end
end
