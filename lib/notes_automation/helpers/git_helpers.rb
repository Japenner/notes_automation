# -------------------------------
# Git timestamp helper
# -------------------------------

module NotesAutomation
  module Helpers
    module GitHelpers
      # Get file timestamps from git history.
      def gitstat(dir, path)
        # Run git log with formatting to get commit dates.
        cmd = %(git -C "#{dir}" log --pretty=format:"%aI %cI" -- "#{path}")
        output = `#{cmd}`.strip
        times = output.split("\n")
        updated_at = Time.iso8601(times[0].split(" ")[1]).to_f
        created_at = Time.iso8601(times[-1].split(" ")[0]).to_f
        GitStat.new(updated_at, created_at)
      end
    end
  end
end
