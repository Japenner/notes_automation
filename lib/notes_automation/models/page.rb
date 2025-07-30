# frozen_string_literal: true

# Represents a Markdown content page.
module NotesAutomation
  class Page
    attr_accessor :backlinks, :canon_title, :created_date, :ctime, :file, :frontmatter,
                  :fullpath, :html_escaped_content, :html, :link_path, :links, :mtime,
                  :relpath, :rfc3339_ctime, :rfc3339_mtime, :source, :title, :titlepath,
                  :updated_date

    def initialize(backlinks: Set.new, links: [], frontmatter: {}, **kwargs)
      @backlinks            = backlinks
      @links                = links
      @frontmatter          = frontmatter

      @canon_title          = kwargs[:canon_title]
      @created_date         = kwargs[:created_date]
      @ctime                = kwargs[:ctime]
      @file                 = kwargs[:file]
      @fullpath             = kwargs[:fullpath]
      @html                 = ''
      @html_escaped_content = ''
      @link_path            = kwargs[:link_path]
      @mtime                = kwargs[:mtime]
      @relpath              = kwargs[:relpath]
      @rfc3339_ctime        = kwargs[:rfc3339_ctime]
      @rfc3339_mtime        = kwargs[:rfc3339_mtime]
      @source               = kwargs[:source]
      @title                = kwargs[:title]
      @titlepath            = kwargs[:titlepath]
      @updated_date         = kwargs[:updated_date]
    end

    # Two pages are equal if their titles match.
    def ==(other)
      other.is_a?(Page) && other.title == @title
    end

    def hash
      [@title].hash
    end

    # Yield a link for each directory in the page’s titlepath.
    def dirlinks
      parts = @titlepath.split('/')[0...-1]
      links = []
      parts.each_with_index do |part, i|
        link = "/#{parts[0..i].join('/')}"
        links << "<a href=\"#{link}.html\">#{part}</a>"
      end
      links
    end
  end
end
