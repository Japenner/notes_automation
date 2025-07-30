# frozen_string_literal: true

# Represents a non–Markdown attachment (e.g. images, PDFs, videos).
module NotesAutomation
  class Attachment
    attr_accessor :title, :canon_title, :fullpath, :link_path, :file, :relpath, :links, :backlinks

    def initialize(title:, canon_title:, fullpath:, link_path:, file:, relpath:, links: [], backlinks: Set.new)
      @title       = title
      @canon_title = canon_title
      @fullpath    = fullpath
      @link_path   = link_path
      @file        = file
      @relpath     = relpath
      @links       = links
      @backlinks   = backlinks
    end

    # Two attachments are considered equal if their titles match.
    def ==(other)
      other.is_a?(Attachment) && other.title == @title
    end

    def hash
      [@title].hash
    end
  end
end
