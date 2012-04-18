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
      elf.sync("sleep 2")
      elf.sync("sleep 3")
    end
    (Time.now-start).to_i.must_equal(6)
  end
end