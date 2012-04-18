module Elf
  class Fork < Child
    alias :sync_fire :fire

    def fire
      fork do
        sync_fire
      end
    end

  end
end