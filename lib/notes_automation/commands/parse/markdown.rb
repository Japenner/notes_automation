# frozen_string_literal: true

require_relative '../../parse/markdown'

module NotesAutomation
  module Commands
    module Parse
      class Markdown
        def self.run(path, options)
          logger = Logger.new($stdout)

          kwargs = { logger: logger, **options }
          parser = Parse::Markdown.new([], kwargs)
          parser.run
        end
      end
    end
  end
end
