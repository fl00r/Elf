# Elf

Elves are creatures to manage background processes.

## Installation

Add this line to your application's Gemfile:

    gem 'elf'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elf

## Usage

This code will run 4 parallel processes and will work about 10 seconds

```ruby
require 'elf'

Elf::Process.new do |elf|
  elf.fork("sleep 10")
  elf.fork("sleep 10")
  elf.fork("sleep 10")
  elf.fork("sleep 10")
end
```

And this will run each process one by one

```ruby
require 'elf'

Elf::Process.new do |elf|
  elf.sync("sleep 10")
  elf.sync("sleep 10")
  elf.sync("sleep 10")
  elf.sync("sleep 10")
end
```

So why do we need this?

For example you have got some slow rake tasks, which should be started in particular order. Some of them could be started in parallel, while other shoud work synchronously.

You have got this task:

1. Download few big XML files from some server
2. Parse them and save to database
3. Then you need to combine all this new data and get new big XML file

```ruby
Elf::Process.new do |elf|
  # let's asynchronously download files and after file is downloaded we will start parse it
  elf.fork("wget file1.xml") do |f|
    f.on_success{ elf.fork("rake some_parser_rake_task") }
  end
  elf.fork("wget file2.xml") do |f|
    f.on_success{ elf.fork("rake some_parser_rake_task") }
  end
  elf.fork("wget file3.xml") do |f|
    f.on_success{ elf.fork("rake some_parser_rake_task") }
  end

  # Here we are waiting while all data downloaded and parsed and then start new rake task for generating new xml
  elf.sync("rake generate_new_xml")
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
