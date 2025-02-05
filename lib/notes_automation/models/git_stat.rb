# Represents file timestamp information from Git.
module NotesAutomation
  class GitStat
    attr_accessor :st_mtime, :st_ctime

    def initialize(st_mtime, st_ctime)
      @st_mtime = st_mtime
      @st_ctime = st_ctime
    end
  end
end
