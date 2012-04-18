module Elf
  class Sync < Child

    def fire
      ::Process.waitall
      super
    end

  end
end