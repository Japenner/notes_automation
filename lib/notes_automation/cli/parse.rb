# frozen_string_literal: true

require 'logger'
require_relative '../commands/base_command'
require_relative '../commands/parse/markdown'

module NotesAutomation
  class CLI < Thor
    class Parse < Commands::BaseCommand
      DEFAULT_PATH = File.expand_path('~/repos/personal/obsidian').freeze

      method_option :recent, type: :numeric,
                             aliases: '-r',
                             desc: 'Number of recent entries to show (default: 15)',
                             default: 15

      method_option :path, type: :string,
                           aliases: '-p',
                           desc: 'Path to folder of .md files to publish',
                           default: DEFAULT_PATH

      method_option :use_git_times, type: :boolean,
                                    aliases: '-g',
                                    desc: 'Use git modified time instead of file mtime',
                                    default: true

      method_option :feeds, type: :array,
                            aliases: '-f',
                            desc: 'A directory to generate a separate feed for (multiple allowed)',
                            default: []

      method_option :ignore, type: :array,
                             aliases: '-i',
                             desc: 'A list of files to ignore.',
                             default: []

      desc 'markdown', 'Parse markdown notes'
      def markdown(dir)
        options[:dir] = dir || '.'
        NotesAutomation::Commands::Parse::Markdown.run(options)
      end
    end
  end
end
