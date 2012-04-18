module Elf
  class Child
    def initialize(cmd)
      @cmd = cmd
    end

    def on_success(&blk)
      @success = blk
      if @status && @status.exitstatus == 0
        success
      end
    end

    def success
      puts "Success: #{@cmd}"
      if @success
        fork do
          @success.call
        end
        ::Process.waitall
      end
    end

    def error
      puts "Failed: #{@cmd}"
    end

    def fire
      puts "Fired: #{@cmd}"
      fork_pid = ::Process.fork do
        exec @cmd
      end
      pid, @status = ::Process.waitpid2(fork_pid)
      @status.exitstatus == 0 ? success : error
    end
  end
end