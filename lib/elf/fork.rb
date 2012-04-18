module Elf
  class Fork < Child

    #
    # We can't use Thread's here. because they don't work :)
    #
    def fire
      pid = fork do
        super
      end
    end

  end
end