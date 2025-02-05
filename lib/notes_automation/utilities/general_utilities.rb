# -------------------------------
# Utility functions
# -------------------------------

require 'fileutils'
require 'yaml'
require 'time'
require 'erb'

module NotesAutomation
  module GeneralUtilities
    FRONT_MATTER_REGEX = /\A\s*---(.*?)\n---\n/m # Matches YAML front matter at the very beginning of a file.
    WHITESPACE_REGEX = /[^\w\-\._~]/             # Matches any character that is not alphanumeric or one of the allowed punctuation.
    SANITIZE_PATH = /[^\w\-\._~\\\/]/            # Used to “sanitize” directory names.
    MARKDOWN_REGEX = /\.md$/                     # Matches filenames ending in .md

    # Parse YAML frontmatter and return a hash.
    def parse_frontmatter(raw_fm)
      anything = YAML.safe_load(raw_fm)
      if !anything
        {}
      elsif !anything.is_a?(Hash)
        raise "Expected frontmatter to be a Hash but got #{anything.class}"
      else
        anything
      end
    end

    # Split the frontmatter from the rest of the markdown content.
    def split_front_matter(buf)
      if (m = buf.match(FRONT_MATTER_REGEX))
        # m[1] contains the YAML block; the rest of the file is after the frontmatter.
        frontmatter = parse_frontmatter(m[1])
        # Remove the frontmatter section from the text.
        content = buf.sub(FRONT_MATTER_REGEX, '')
        [frontmatter, content]
      else
        [{}, buf]
      end
    end

    # Convert a markdown filename to an HTML filename.
    def outname(fname)
      clean = fname.gsub(WHITESPACE_REGEX, "_")
      clean.sub(MARKDOWN_REGEX, ".html")
    end

    # Sanitize a directory name.
    def pathname(dname)
      dname.gsub(SANITIZE_PATH, "_")
    end

    # Recursively make a directory if it does not exist.
    def mkdir(dir)
      FileUtils.mkdir_p(dir) unless File.directory?(dir)
      dir
    end

    # Format a timestamp (in seconds) as a human–readable date.
    def formatted_time(t)
      Time.at(t).strftime("%b %d, %Y")
    end

    # Convert a timestamp (seconds) into an RFC3339 string.
    def rfc3339_time(t)
      Time.at(t).iso8601
    end

    # Render a template from the "templates" folder using ERB.
    def render(template, locals = {})
      template_path = File.join("templates", template)
      content = File.read(template_path)
      # ERB will use keys in locals as local variables.
      ERB.new(content).result_with_hash(locals)
    end
  end
end
