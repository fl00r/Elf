module Elf
  class Child
    attr_reader :success

    def initialize(cmd, comment)
      @cmd = cmd
      @comment = comment
    end

    def on_success(&blk)
      @success = blk
      if @status && @status.exitstatus == 0
        success
      end
    end

    def fire_success
      puts "Success: #{@cmd} # #{@comment}"
      if @success
        @success.call
      end
    end

    def fire_error
      puts "Failed: #{@cmd} # #{@comment}"
    end

    def fire
      puts "Fired: #{@cmd} # #{@comment}"
      fork_pid = ::Process.fork do
        case @cmd
        when String
          exec @cmd
        when Symbol
          send @cmd
        when Array
          send @cmd[0], *@cmd[1..-1]
        end
      end
      fake = fork{ "sleep 10" }
      pid, @status = ::Process.waitpid2(fork_pid)
      @status.exitstatus == 0 ? fire_success : fire_error
      ::Process.kill(9, fake) rescue nil
      ::Process.waitall
    end
  end
end