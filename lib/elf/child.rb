module Elf
  class Child
    def initialize(cmd)
      @cmd = cmd
      fire
    end

    def fire
      fork_pid = Process.fork do
        puts "#{cmd} fired"
        exec "#{cmd}"
      end
      pid, @status = Process.wait2(fork_pid)
      success if @status.exitstatus == 0
    end

    def success=(&blk)
      @success = blk
      success if @status.exitstatus == 0
    end

    def success
      @success.call if @success
    end
  end
end