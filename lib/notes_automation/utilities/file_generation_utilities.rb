# frozen_string_literal: true

# -------------------------------
# Static file generation functions
# -------------------------------

require 'fileutils'
# require 'rouge' # for syntax highlighting

module NotesAutomation
  module Utilities
    module FileGenerationUtilities
      LINK_REGEX = /\[\[(.*?)\]\]/ # Regex for wiki‐style links: [[some link]]

      # Use Rouge to generate a stylesheet (using the “github” theme).
      def generate_stylesheet
        theme = Rouge::Theme.find('github')
        css = theme ? theme.render(scope: '.highlight') : ''
        mkdir('output')
        File.write(File.join('output', 'pygments.css'), css)
      end

      # Copy static files (css and svg) from the templates directory to the output directory.
      def copy_static(from_dir, to_dir)
        Dir.glob(File.join(from_dir.to_s, '*.{css,svg}')).each do |file|
          FileUtils.cp(file, to_dir)
        end
      end

      # Strip a "fancy" link name – if a pipe or hash is present, return only the first part.
      def strip_fancy_name(link)
        if link.include?('|')
          link.split('|').first
        elsif link.include?('#')
          link.split('#').first
        else
          link
        end
      end

      # Find all wiki–style links in a markdown document.
      def findlinks(md)
        md.scan(LINK_REGEX).flatten.map { |link| strip_fancy_name(link) }
      end

      # Return the canonical (lowercase) form of a title.
      def canonicalize(title)
        title.downcase
      end

      # Given a relative path, return a canonical form.
      def canonical_path(relative_path)
        path = File.dirname(relative_path)
        page = File.basename(relative_path)
        if path && !path.empty?
          "#{pathname(path)}/#{canonicalize(page)}"
        else
          canonicalize(page)
        end
      end

      # Find a page or attachment from its link.
      def find(pages, attachments, link)
        clink = canonical_path(link)
        pages.each do |relpath, page|
          return page if page.canon_title == clink || relpath == clink
        end
        attachments.each do |link_path, attach|
          return attach if attach.file == link || link_path == link
        end
        nil
      end

      # Split a list of files into markdown files and non-markdown files.
      def split_files(files)
        md_files = files.select { |f| f.end_with?('.md') }
        non_md = files.reject { |f| f.end_with?('.md') }
        [md_files, non_md]
      end
    end
  end
end
