# frozen_string_literal: true

# -------------------------------
# FileTree class for organizing files
# -------------------------------

# Represents a node in the file tree.
module NotesAutomation
  class FileTree
    attr_accessor :dir, :page, :children, :basename, :reldir, :dirparts, :reldirparts

    # If dir is given (a string) then we compute additional info.
    def initialize(dir: nil, page: nil)
      @dir = dir
      if @dir.is_a?(String)
        @basename    = File.basename(@dir)
        @reldir      = pathname(@dir)
        @dirparts    = @dir.split('/')
        @reldirparts = @reldir.split('/')
      end
      @page     = page
      @children = []
    end

    # Return a hash of child pages indexed by titlepath.
    def child_pages(idx = {})
      @children.each do |child|
        if child.page.is_a?(Page)
          idx[child.page.titlepath] = child.page
        elsif child.dir
          child.child_pages(idx)
        end
      end
      idx
    end

    # Find a sub–directory node whose reldirparts end with the given dir.
    def find_dir(dir)
      return self if @reldirparts && @reldirparts[-1] == dir

      @children.each do |child|
        if child.dir
          found = child.find_dir(dir)
          return found if found
        end
      end
      nil
    end

    # Return backlinks for all direct children pages.
    def dir_backlinks
      backlinks = Set.new
      @children.each do |child|
        child.page&.backlinks&.each { |link| backlinks.add(link) }
      end
      backlinks
    end

    # Returns true if this node has any child directories.
    def has_child_dirs?
      @children.any?(&:dir)
    end

    # Yield a link to each directory page, all the way back to the root.
    def dirlinks
      raise 'No directory defined' unless @dir

      links = []
      @dirparts.each_index do |i|
        link = "/#{@reldirparts[0..i].join('/')}"
        links << "<a href=\"#{link}.html\">#{@dirparts[i]}</a>"
      end
      links
    end

    # Return a link to this directory.
    def dirlink
      raise 'No directory defined' unless @dir

      href = "/#{@reldirparts.join('/')}.html"
      "<a href=\"#{href}\" class=\"dirlink\">🔗</a>"
    end

    def to_s
      return File.basename(@dir) if @dir
      return @page.title if @page

      'FileTreeNode'
    end
  end
end
