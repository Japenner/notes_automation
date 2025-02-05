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
        # The first line: second timestamp is the modified time.
        mtime = Time.iso8601(times[0].split(" ")[1]).to_f
        # The last line: first timestamp is the “creation” time.
        ctime = Time.iso8601(times[-1].split(" ")[0]).to_f
        GitStat.new(mtime, ctime)
      end
    end
  end
end
