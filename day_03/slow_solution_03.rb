# frozen_string_literal: true

require 'set'

# Day 2:

# op codes

def parse_input(input_file); end

class Pos
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    x == other.x &&
      y == other.y
  end

  def eql?(other)
    x == other.x &&
      y == other.y
  end

  def step(dir)
    dx, dy = dir.to_xy
    Pos.new(@x + dx, @y + dy)
  end

  def to_s
    "#{x},#{y}"
  end

  def self.from_str(str)
    x, y = str.split(',').map(&:to_i)
    Pos.new(x, y)
  end

  def dist
    @x.abs + @y.abs
  end
end

UP = 1
DOWN = 2
LEFT = 3
RIGHT = 4

class Dir
  attr_accessor :dir
  def initialize(st)
    @dir = Dir.from_str(st)
  end

  def self.from_str(st)
    case st
    when 'R'
      RIGHT
    when 'L'
      LEFT
    when 'D'
      DOWN
    when 'U'
      UP
    end
  end

  def to_xy
    case @dir
    when UP
      [0, 1]
    when DOWN
      [0, -1]
    when RIGHT
      [1, 0]
    when LEFT
      [-1, 0]
    else
      puts "ERROR dir is #{dir}"
      exit
    end
  end
end

class Wire
  attr_accessor :segments
  def initialize
    @segments = Set.new([])
    @pos = Pos.new(0, 0)
  end

  def inst_to_command(str)
    dir = Dir.new(str[0])
    count = str[1..-1].to_i
    [dir, count]
  end

  def handle_inst(inp)
    dir, count = inst_to_command(inp)
    (0..count - 1).each do |_|
      @pos = @pos.step(dir)
      @segments += [@pos.to_s]
    end
  end
end

class Solution
  def initialize(inp)
    inst1, inst2 = parse_input(inp)
    @inst1 = inst1
    @inst2 = inst2
  end

  def parse_input(inp)
    inp.split("\n").map { |line| line.split(',') }
  end

  def solution_a
    wire_1 = Wire.new
    wire_2 = Wire.new
    @inst1.each do |inst|
      wire_1.handle_inst(inst)
    end
    @inst2.each do |inst|
      wire_2.handle_inst(inst)
    end
    intersect = (wire_1.segments & wire_2.segments).map do |str|
      Pos.from_str(str)
    end
    intersect.map(&:dist).min
  end

  def solution_b; end
end

def main
  puts 'Hello World'
  puts "Solution a: #{Solution.new(File.read('input.txt')).solution_a}"
end

require 'test/unit'

class Tester < Test::Unit::TestCase
  def test_sample_a
        s1 = Solution.new('R8,U5,L5,D3
U7,R6,D4,L4')
        assert_equal(6, s1.solution_a)

    s2 = Solution.new('R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83')
    assert_equal(159, s2.solution_a)

    s3 = Solution.new('R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7')
    assert_equal(135, s3.solution_a)
  end

  def test_a; end

  def test_sample_b; end

  def test_solutions; end
end

main
