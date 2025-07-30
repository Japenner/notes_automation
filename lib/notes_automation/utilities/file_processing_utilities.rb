# frozen_string_literal: true

# -------------------------------
# File processing functions
# -------------------------------

module NotesAutomation
  module Utilities
    module FileProcessingUtilities
      # Given a full file path and the root directory, return a Page (if Markdown) or an Attachment.
      def handle_file(path, root, use_git_times)
        ext = File.extname(path)
        if ext == '.md'
          content = File.read(path)
          frontmatter, source = split_front_matter(content)
          links = findlinks(source)
          dir = File.dirname(path)
          filename = File.basename(path)
          # Compute the relative path by removing the root prefix.
          relpath = pathname(dir.sub(/^#{Regexp.escape(root)}/, '').sub(%r{^/}, ''))
          title = File.basename(filename, ext)
          titlepath = File.join(relpath, canonicalize(title))
          # Determine the timestamps.
          if frontmatter.key?('updated') && frontmatter.key?('created')
            t = FileStat.new(parse_fm_datetime(frontmatter['updated']),
                             parse_fm_datetime(frontmatter['created']))
          elsif use_git_times
            begin
              t = gitstat(dir, path)
            rescue StandardError
              info('File not in git, falling back to File.stat for', path)
              stat = File.stat(path)
              t = FileStat.new(stat.mtime.to_f, stat.ctime.to_f)
            end
          else
            stat = File.stat(path)
            t = FileStat.new(stat.mtime.to_f, stat.ctime.to_f)
          end

          return Page.new(
            title: title,
            canon_title: canonicalize(title),
            file: filename,
            relpath: relpath,
            fullpath: path,
            titlepath: titlepath,
            link_path: File.join(relpath, outname(filename)),
            links: links,
            backlinks: Set.new,
            frontmatter: frontmatter,
            ctime: t.st_ctime,
            mtime: t.st_mtime,
            rfc3339_ctime: rfc3339_time(t.st_ctime),
            rfc3339_mtime: rfc3339_time(t.st_mtime),
            created_date: formatted_time(t.st_ctime),
            updated_date: formatted_time(t.st_mtime),
            source: source
          )
        end

        # For non-Markdown files, treat them as attachments.
        dir = File.dirname(path)
        filename = File.basename(path)
        title = File.basename(filename, File.extname(filename))
        relpath = pathname(dir.sub(/^#{Regexp.escape(root)}/, '').sub(%r{^/}, ''))
        Attachment.new(
          title: title,
          canon_title: canonicalize(title),
          fullpath: path,
          link_path: File.join(relpath, filename),
          file: filename,
          relpath: relpath,
          links: [],
          backlinks: Set.new
        )
      end

      # Returns true if a file is empty (ignoring whitespace in the first 16 bytes).
      def is_empty_file(path)
        File.open(path, 'rb') { |f| f.read(16) =~ /\S/ ? false : true }
      end

      # Recursively build the file tree from the given directory.
      def build_file_tree_helper(node, ignore, root_path, index, attachments, use_git_times)
        raise 'Node must have a directory' unless node.dir

        full_dir = File.join(root_path, node.dir)
        # Use Dir.entries and sort case–insensitively.
        Dir.entries(full_dir).sort_by(&:downcase).each do |entry|
          next if ['.', '..'].include?(entry)

          if ignore.include?(entry)
            info('Ignoring file', entry)
            next
          end
          if ['Untitled.md', 'Untitled'].include?(entry)
            info('Ignoring untitled object', entry)
            next
          end
          entry_path = File.join(full_dir, entry)
          rel_entry = entry_path.sub(/^#{Regexp.escape(root_path)}/, '').sub(%r{^/}, '')
          if File.directory?(entry_path)
            # For directories, remove any leading "/" from the relative path.
            path = rel_entry
            subtree = build_file_tree_helper(FileTree.new(dir: path), ignore, root_path, index, attachments,
                                             use_git_times)
            node.children << subtree
          else
            if is_empty_file(entry_path)
              info('Ignoring empty file', entry)
              next
            end
            page_or_attach = handle_file(entry_path, root_path, use_git_times)
            if page_or_attach.is_a?(Page)
              # If the page has frontmatter with a "draft" key, skip it.
              next if page_or_attach.frontmatter['draft']

              index[page_or_attach.titlepath] = page_or_attach
            else
              attachments[page_or_attach.link_path] = page_or_attach
            end
            # Create a FileTree node for the file.
            node.children << FileTree.new(page: page_or_attach)
          end
        end
        node
      end

      # Build the entire file tree and return the tree along with indices for pages and attachments.
      def build_file_tree(dir, ignore, use_git_times)
        index = {}
        attachments = {}
        tree = build_file_tree_helper(FileTree.new(dir: dir), ignore, dir, index, attachments, use_git_times)
        [tree, index, attachments]
      end

      # After all pages are processed, calculate backlinks.
      def calculate_backlinks(pages, attachments)
        pages.each_value do |page|
          page.links.each do |link|
            linked = find(pages, attachments, link)
            if linked.nil?
              info('Unable to find link', link, page.title)
              next
            end
            linked.backlinks.add(page)
          end
        end
      end
    end
  end
end
