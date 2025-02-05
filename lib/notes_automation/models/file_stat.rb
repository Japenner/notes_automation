# Represents file system stat information.
module NotesAutomation
  class FileStat
    attr_accessor :st_mtime, :st_ctime

    def initialize(st_mtime, st_ctime)
      @st_mtime = st_mtime
      @st_ctime = st_ctime
    end
  end
end
