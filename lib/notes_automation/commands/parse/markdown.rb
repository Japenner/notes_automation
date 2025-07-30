# frozen_string_literal: true

require_relative '../../parse_markdown'

module NotesAutomation
  module Commands
    module Parse
      class Markdown
        def self.run(_path, options)
          logger = Logger.new($stdout)

          kwargs = { logger: logger, **options }
          parser = ParseMarkdown.new([], kwargs)
          parser.run
        end
      end
    end
  end
end
