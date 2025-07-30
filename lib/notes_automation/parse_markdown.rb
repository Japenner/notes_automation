# frozen_string_literal: true

# This class reads a directory of Markdown files (and other attachments), parses frontmatter,
# renders markdown to HTML (with syntax‐highlighting), generates various pages (index, feed, search),
# and builds a file tree structure.

require 'pathname'

require_relative './helpers'
require_relative './utilities'
require_relative './utilities/general_utilities'

module NotesAutomation
  class ParseMarkdown < Thor
    include Helpers::GitHelpers
    include Helpers::OutputHelpers
    include Utilities::GeneralUtilities
    include Utilities::FileGenerationUtilities
    include Utilities::FileProcessingUtilities
    include Utilities::HtmlGenerationUtilities
    include Utilities::FrontmatterUtilities
    include Utilities::MarkdownUtilities
    include Utilities::LinkingUtilities

    DEFAULT_IGNORES = Set.new(%w[.DS_Store private .obsidian .github .git .gitignore])

    def initialize(args = [], options = {}, config = {})
      super(args, options, config)

      @dir = File.expand_path(options[:dir])
      @recent = options[:recent]
      @use_git_times = options[:use_git_times]
      @ignore = options[:ignore] || DEFAULT_IGNORES
      @feeds = options[:feeds] || []
      @logger = options[:logger] || Logger.new($stdout)
    end

    no_commands do
      def run
        # Normalize the directory path.
        tree, pages, attachments = build_file_tree(dir, ignore, use_git_times)
        calculate_backlinks(pages, attachments)

        outdir = Pathname.new(mkdir('output'))

        generate_stylesheet
        copy_static(Pathname.new('templates'), outdir)
        copy_attachments(attachments, outdir)

        substitute_images(pages, attachments)
        substitute_crosslinks(pages)

        # Render the markdown to HTML pages.
        generate_html_pages(pages, outdir)
        generate_search(pages, outdir)
        generate_index_page(tree, pages, outdir, recent)
        generate_feeds(tree, pages, feeds, outdir, recent)
        generate_dir_pages(tree, pages, outdir)
        generate_lastweek_page(pages, outdir)
      rescue StandardError => e
        @logger.error("Error while parsing markdown: #{e.message}")
      end
    end

    private

    attr_accessor :feeds, :ignore, :logger, :dir, :recent, :use_git_times
  end
end
