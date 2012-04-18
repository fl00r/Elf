module Elf
  class Fork < Child

    #
    # We can't use Thread's here. because the don't work :)
    #
    def fire
      fork do
        super
      end
    end

  end
end