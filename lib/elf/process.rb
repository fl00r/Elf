module Elf
  class Process
    def initialize(&blk)
      @pids = []
      @pids << blk.call(self)
      ::Process.waitall
    ensure
      # killall!
    end

    def fork(cmd, comment=nil)
      elf = Elf::Fork.new(cmd, comment)
      fire(elf)
    end

    def sync(cmd, comment=nil)
      elf = Elf::Sync.new(cmd, comment)
      fire(elf)
    end

    def fire(elf)
      yield elf if block_given?
      @pids << elf.fire
    end

    def killall!
      @pids.each do |pid|
        begin
          ::Process.kill(9, pid)
        rescue ::Errno::ESRCH
          # ok
        end
      end
    end
  end
end