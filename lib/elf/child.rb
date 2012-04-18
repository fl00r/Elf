module Elf
  class Child
    def initialize(cmd)
      @cmd = cmd
      fire
    end

    def success=(&blk)
      @success = blk
      success if @status.exitstatus == 0
    end

    def success
      puts "Success: #{@cmd}"
      @success.call if @success
    end

    def error
      puts "Failed: #{@cmd}"
    end

    def fire
      fork_pid = ::Process.fork do
        puts "Fired: #{@cmd}"
        exec @cmd
      end
      pid, @status = ::Process.waitpid2(fork_pid)
      @status.exitstatus == 0 ? success : error
    end
  end
end