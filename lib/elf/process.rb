module Elf
  class Process
    def initialize(&blk)
      blk.call(self)
    end

    def fork(cmd)
      Elf::Process::Fork.new(cmd)
    end

    def sync
      Elf::Process::Sync.new(cmd)
    end
  end
end