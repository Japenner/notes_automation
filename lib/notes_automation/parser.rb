#!/usr/bin/env ruby
# This class reads a directory of Markdown files (and other attachments), parses frontmatter,
# renders markdown to HTML (with syntax‐highlighting), generates various pages (index, feed, search),
# and builds a file tree structure.

require 'pathname'

module NotesAutomation
  class Parser
    include GeneralUtilities
    include FileGenerationUtilities
    include GitHelpers
    include OutputHelpers
    include FileProcessingUtilities
    include HtmlGenerationUtilities
    include FrontmatterUtilities
    include MarkdownUtilities
    include LinkingUtilities

    # Matches YAML front matter at the very beginning of a file.
    FRONT_MATTER_RE = /\A\s*---(.*?)\n---\n/m
    # Matches any character that is not alphanumeric or one of the allowed punctuation.
    WHITESPACE_RE  = /[^\w\-\._~]/
    # Matches filenames ending in .md
    MARKDOWN_RE    = /\.md$/
    # Used to “sanitize” directory names.
    SANITIZE_PATH  = /[^\w\-\._~\\\/]/
    # Regex for wiki‐style links: [[some link]]
    LINK_RE        = /\[\[(.*?)\]\]/
    # Regex for image “wikilinks”: ![[some image]]
    IMAGE_LINK_RE  = /!\[\[(.*?)\]\]/
    # For crosslink replacement (again, using [[...]] syntax)
    CROSSLINK_RE   = /\[\[(.*?)\]\]/

    # Parse a directory of markdown files.
    # Parameters:
    # - mddir: the directory to parse
    # - recent: number of recent posts to show
    # - use_git_times: whether to use git for file timestamps
    # - ignore: a set of folder names to ignore
    # - feeds: an array of directories for which to generate separate feeds
    def parse(mddir, recent, use_git_times, ignore: Set.new, feeds: [])
      # Normalize the directory path.
      dir = File.expand_path(mddir)
      tree, pages, attachments = build_file_tree(dir, ignore, use_git_times)
      calculate_backlinks(pages, attachments)

      outdir = Pathname.new(mkdir("output"))

      generate_stylesheet
      copy_static(Pathname.new("templates"), outdir)
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
    end
  end
end



# -------------------------------
# Main entry point: process command–line options
# -------------------------------

if __FILE__ == $0
  require 'set'
  options = {
    recent: 15,
    path: File.expand_path("~/repos/personal/obsidian"),
    use_git_times: false,
    feed: []
  }

  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{$0} [options]"

    opts.on("--recent N", Integer, "Number of recent entries to show (default: 15)") do |n|
      options[:recent] = n
    end

    opts.on("--path PATH", String, "Path to folder of .md files to publish") do |p|
      options[:path] = p
    end

    opts.on("--use-git-times", "Use git modified time instead of file mtime") do
      options[:use_git_times] = true
    end

    opts.on("--feed FEED", "A directory to generate a separate feed for. Can be given multiple times") do |feed|
      options[:feed] << feed
    end

    opts.on("-h", "--help", "Prints this help") do
      puts opts
      exit
    end
  end

  opt_parser.parse!(ARGV)

  default_ignores = Set.new(%w[.DS_Store private .obsidian .github .git .gitignore])
  parse(options[:path], options[:recent], options[:use_git_times],
        ignore: default_ignores, feeds: options[:feed])
end
