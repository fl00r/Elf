# -*- encoding: utf-8 -*-
require File.expand_path('../lib/elf/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Petr Yanovich"]
  gem.email         = ["fl00r@yandex.ru"]
  gem.description   = %q{Elves are creatures to manage background processes}
  gem.summary       = %q{Elves are creatures to manage background processes}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "elf"
  gem.require_paths = ["lib"]
  gem.version       = Elf::VERSION
end
