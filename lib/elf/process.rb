module Elf
  class Process
    def initialize(&blk)
      pid = blk.call(self)
      ::Process.waitall
    end

    def fork(cmd)
      elf = Elf::Fork.new(cmd)
      yield elf if block_given?
      pid = elf.fire
    end

    def sync(cmd)
      elf = Elf::Sync.new(cmd)
      yield elf if block_given?
      elf.fire
    end
  end
end