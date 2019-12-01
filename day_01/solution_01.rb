# frozen_string_literal: true

# Day 1:

class SpaceModule
  def initialize(mass)
    # mass of the mod (int)
    @mass = mass
  end

  def calculate
    [0, (@mass / 3) - 2].max
  end

  # fuel has weight, so do the same process but check how much fuel the fuel needs
  def calculate_with_fuel
    s = 0
    res = calculate
    until res.zero?
      s += res
      @mass = res
      res = calculate
    end
    s
  end
end

class Solution
  def initialize(input_file)
    # filename to open and parse
    @input_file = input_file
  end

  def solution_a
    s = 0
    File.open(@input_file).each do |line|
      s += SpaceModule.new(line.to_i).calculate
    end
    s
  end

  def solution_b_lame
    s = 0
    File.open(@input_file).each do |line|
      s += SpaceModule.new(line.to_i).calculate_with_fuel
    end
    s
  end

  def solution_b
    # The & tries to turn the param into a Proc. The method name is passed in
    File.open(@input_file)
        .map { |line| SpaceModule.new(line.to_i) }
        .map(&:calculate_with_fuel)
        .reduce(0) { |sum, val| sum + val }
  end
end

def main
  puts 'Hello World'
  puts 'solution A: ', Solution.new('input.txt').solution_a
  puts 'solution B: ', Solution.new('input.txt').solution_b
end

require 'test/unit'

class Tester < Test::Unit::TestCase
  def test_sample_a
    assert_equal(2, SpaceModule.new(12).calculate)
    assert_equal(654, SpaceModule.new(1969).calculate)
    assert_equal(33_583, SpaceModule.new(100_756).calculate)
  end

  def test_a
    # 12 & 14 -> 2 + 2 = 4
    assert_equal(4, Solution.new('test_input.txt').solution_a)
  end

  def test_sample_b
    assert_equal(2, SpaceModule.new(12).calculate_with_fuel)
    assert_equal(966, SpaceModule.new(1969).calculate_with_fuel)
  end

  def test_solutions
    assert_equal(3_515_171, Solution.new('input.txt').solution_a)
    assert_equal(5_269_882, Solution.new('input.txt').solution_b)
  end
end

main
