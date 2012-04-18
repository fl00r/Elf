module Elf
  class Process
    def initialize(&blk)
      blk.call(self)
      st = ::Process.waitall
    end

    def fork(cmd)
      Elf::Fork.new(cmd)
    end

    def sync(cmd)
      Elf::Sync.new(cmd)
    end
  end
end