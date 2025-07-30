# frozen_string_literal: true

# -------------------------------
# Helper output functions
# -------------------------------

module NotesAutomation
  module Helpers
    module OutputHelpers
      # Print an informational message in yellow.
      def info(msg, *args)
        yellow = "\033[0;33m"
        reset  = "\033[0m"
        puts "#{yellow}#{msg}#{reset} #{args.join(' ')}"
      end

      # Print an error message in red.
      def err(msg, *args)
        red   = "\033[0;31m"
        reset = "\033[0m"
        puts "#{red}#{msg}#{reset} #{args.join(' ')}"
      end
    end
  end
end
