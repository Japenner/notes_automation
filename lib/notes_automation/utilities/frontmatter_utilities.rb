# frozen_string_literal: true

require 'time'

module NotesAutomation
  module Utilities
    module FrontmatterUtilities
      # Parse a datetime from frontmatter (which may be a string or already a Time/DateTime object).
      def parse_fm_datetime(d)
        if d.is_a?(String)
          Time.iso8601(d).to_f
        else
          d.to_time.to_f
        end
      end
    end
  end
end
