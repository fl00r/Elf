# encoding: utf-8
require 'spec_helper'

describe Elf::Process do
  it "should run 3 parallel processes" do
    start = Time.now
    Elf::Process.new do |elf|
      elf.fork("sleep 1")
      elf.fork("sleep 2")
      elf.fork("sleep 2")
    end
    (Time.now-start).to_i.must_equal(2)
  end

  it "should run 3 sequenced processes" do
    start = Time.now
    Elf::Process.new do |elf|
      elf.sync("sleep 1")
      elf.sync("sleep 1")
      elf.sync("sleep 1")
    end
    (Time.now-start).to_i.must_equal(3)
  end

  it "should run 4 combined processes" do
    start = Time.now
    Elf::Process.new do |elf|
      elf.fork("sleep 1")
      elf.fork("sleep 1")
      elf.sync("sleep 1")
      elf.sync("sleep 1")
      elf.fork("sleep 1")
    end
    (Time.now-start).to_i.must_equal(4)
  end

  it "should fire success process" do
    start = Time.now
    Elf::Process.new do |elf|
      elf.fork("sleep 1") do |fork|
        fork.on_success do
          elf.fork("sleep 1")
        end
      end
      elf.sync("sleep 1") do |fork|
        fork.on_success do
          elf.sync("sleep 1")
        end
      end
      elf.sync("sleep 1")
    end
    (Time.now-start).to_i.must_equal(5)
  end

  it "should work with deep nested success jobs" do
    start = Time.now
    Elf::Process.new do |elf|
      elf.fork("sleep 1") do |f1|
        f1.on_success do
          elf.fork("sleep 1") do |f2|
            f2.on_success do
              elf.fork("sleep 1") do |f3|
                f3.on_success do
                  elf.fork("sleep 1")
                end
              end
            end
          end
        end
      end
    end
    (Time.now-start).to_i.must_equal(4)
  end

  it "should work with deep nested complex sync async success jobs" do
    start = Time.now
    Elf::Process.new do |elf|
      elf.fork("sleep 1") do |f1|
        f1.on_success do
          elf.fork("sleep 1") do |f2|
            f2.on_success do
              elf.fork("sleep 1") do |f3|
                f3.on_success do
                  elf.fork("sleep 1")
                  elf.fork("sleep 1")
                  elf.fork("sleep 1")
                end
              end
            end
          end
          elf.sync("sleep 1")
          elf.fork("sleep 1")
        end
      end
    end
    (Time.now-start).to_i.must_equal(6)
  end

  it "should work with sync jobs in success callback" do
    start = Time.now
    Elf::Process.new do |elf|
      elf.fork("sleep 1", "first async") do |f|
        f.on_success do
          elf.sync("sleep 1", "first sync callback")
          elf.sync("sleep 1", "second sync callback")
        end
      end
      elf.fork("sleep 1", "second async") do |f|
        f.on_success do
          elf.fork("sleep 1", "first async callback") do |f1|
            f1.on_success do
              elf.fork("sleep 1", "one more async call")
              elf.sync("sleep 1", "one more sync call")
            end
          end
          elf.fork("sleep 1", "second async callback")
        end
      end
    end
    (Time.now-start).to_i.must_equal(4)
  end

  it "should run Ruby method in background" do
    start = Time.now
    Elf::Process.new do |elf|
      elf.fork([:sleep, 1], "async sleep")
      elf.fork([:sleep, 1], "async sleep")
      elf.fork([:sleep, 1], "async sleep")
    end
    (Time.now-start).to_i.must_equal(1)
  end

  it "should run Ruby method in background" do
    start = Time.now
    Elf::Process.new do |elf|
      elf.sync([:sleep, 1], "async sleep")
      elf.fork([:sleep, 1], "async sleep")
      elf.fork([:sleep, 1], "async sleep")
    end
    (Time.now-start).to_i.must_equal(2)
  end
end