# frozen_string_literal: true

require 'pp'

class Segment
  attr_accessor :x, :y, :dir, :count, :rx, :ry

  # dir is always converted to either right or down
  def initialize(x, y, dir, count)
    @rx = x
    @ry = y
    if dir == 'L'
      dir = 'R'
      x -= count
    end

    if dir == 'U'
      dir = 'D'
      y -= count
    end
    @x = x
    @y = y
    @dir = dir
    @count = count
    if dir == 'D'
      @dx = 0
      @dy = count
    else
      @dx = count
      @dy = 0
    end
  end

  def coords
    [
      [@x, @y], # tl
      [@x + @dx, @y + @dy] # bot right
    ]
  end

  # return true and the point of intersection if it does intersect
  def intersect(other)
    tl, br = coords
    tl2, br2 = other.coords

    # get intersection rectangle
    x1 = [tl[0], tl2[0]].max
    x2 = [br[0], br2[0]].min
    y1 = [tl[1], tl2[1]].max
    y2 = [br[1], br2[1]].min

    # they do intersect
    [x1, y1] if x1 == x2 && y1 == y2
  end
end

class Inst
  attr_accessor :dir, :count
  def initialize(dir, count)
    @dir = dir
    @count = count
  end

  def to_s
    "#{@dir},#{@count}"
  end
end

class Wire
  attr_accessor :segments, :costs
  def initialize
    @segments = []
    @costs = [0]
    @x = 0
    @y = 0
  end

  def step(cmd)
    @segments.push(Segment.new(@x, @y, cmd.dir, cmd.count))
    @costs.push(@costs[-1] + cmd.count)
    case cmd.dir
    when 'U'
      @y -= cmd.count
    when 'D'
      @y += cmd.count
    when 'R'
      @x += cmd.count
    when 'L'
      @x -= cmd.count
    else
      puts 'ERROR'
    end
  end

  def overlap(other)
    ints = []
    @segments.each do |seg|
      other.segments.each do |oth|
        int = oth.intersect(seg)
        ints.push(int) if int
      end
    end
    ints.select do |x, y|
      x != 0 || y != 0
    end
  end

  def closest_overlap(other)
    overlap(other).map do |x, y|
      x.abs + y.abs
    end .min
  end

  def least_cost_overlap(other)
    ints = []
    @segments.each_with_index do |seg, i|
      other.segments.each_with_index do |oth, j|
        int = oth.intersect(seg)
        next unless int

        self_cost = @costs[i] + (seg.rx - int[0]).abs + (seg.ry - int[1]).abs
        other_cost = other.costs[j] + (oth.rx - int[0]).abs + (oth.ry - int[1]).abs
        ints.push([int, self_cost, other_cost])
      end
    end

    ints = ints.select do |int, _i, _j|
      int[0] != 0 || int[1] != 0
    end
    loc, c1, c2 = ints.inject([[0, 0], 10_0000000, 10_000000]) do |a, b|
      if (a[1] + a[2] < b[1] + b[2])
        a
      else
        b
      end
    end
    c1 + c2
  end
end

class Solution_3
  def initialize(inp)
    @cmds = inp.split("\n").map do |line|
      line.strip.split(',').map do |cmd|
        d = cmd[0]
        count = cmd[1..-1].to_i
        Inst.new(d, count)
      end
    end
  end

  def solution_a
    a = Wire.new
    @cmds[0].each do |c|
      a.step(c)
    end
    b = Wire.new
    @cmds[1].each do |c|
      b.step(c)
    end
    a.closest_overlap(b)
  end

  def solution_b
    a = Wire.new
    @cmds[0].each do |c|
      a.step(c)
    end
    b = Wire.new
    @cmds[1].each do |c|
      b.step(c)
    end
    a.least_cost_overlap(b)
  end
end

require 'test/unit'
class Tester < Test::Unit::TestCase
  def test_sample_a
    s1 = Solution_3.new('R8,U5,L5,D3
U7,R6,D4,L4')
    assert_equal(6, s1.solution_a)

    s2 = Solution_3.new('R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83')
    assert_equal(159, s2.solution_a)

    s3 = Solution_3.new('R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7')
    assert_equal(135, s3.solution_a)
  end

  def test_a; end

  def test_sample_b
    s = Solution_3.new('R8,U5,L5,D3
U7,R6,D4,L4')
    assert_equal(30, s.solution_b)
    s = Solution_3.new('R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83')
    assert_equal(610, s.solution_b)
    s = Solution_3.new('R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
      U98,R91,D20,R16,D67,R40,U7,R15,U6,R7')
    assert_equal(410, s.solution_b)
    end

  def test_solutions
    assert_equal(489, Solution_3.new(File.read('input.txt')).solution_a)
    assert_equal(93654, Solution_3.new(File.read('input.txt')).solution_b)
  end
end

s = Solution_3.new(File.read('input.txt'))
puts "Solution a: #{s.solution_a}"
# puts "Solution b: #{s.solution_b}"
