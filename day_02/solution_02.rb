# frozen_string_literal: true

# Day 2:

# op codes

def parse_input (input_file)
  File.open(input_file).read
      .strip.split(',')
      .map(&:to_i)
end


class OpCode
  def initialize(st); end
end

class Solution
  def initialize(nums)
    # filename to open and parse
    @idx = 0
    @nums = nums
  end

  def handle_add
    a = @nums[@idx + 1]
    b = @nums[@idx + 2]
    c = @nums[@idx + 3]
    @nums[c] = @nums[a] + @nums[b]
  end

  def handle_mult
    a = @nums[@idx + 1]
    b = @nums[@idx + 2]
    c = @nums[@idx + 3]
    @nums[c] = @nums[a] * @nums[b]
  end

  def step
    opcode = @nums[@idx]
    # puts "@#{@idx}:#{opcode}:#{@nums}"
    if opcode == 1
      self.handle_add
    elsif opcode == 2
      self.handle_mult
    else
      return false
    end
    @idx += 4
    true
  end

  def setup_a
    @nums[1] = 12
    @nums[2] = 2
  end

  def solve_a
    while self.step; end
    return @nums[0]
  end

  def solution_a
    self.setup_a
    self.solve_a
  end

  def setup_b (saved, noun, verb)
    @idx = 0
    @nums = saved
    @nums[1] = noun
    @nums[2] = verb
    # puts "#{@nums}"
  end

  def solution_b
    desired = 19690720
    saved_nums = @nums.dup

    for n in 0..100 do
      for v in 0..100 do
        setup_b(saved_nums.dup, n, v)
        val = self.solve_a
        if (val == desired)
          return 100 * n + v
        end
      end
    end
    return -1
  end
end

def solution_b_static (fname)
  desired = 19690720

  for n in 0..100 do
    for v in 0..100 do
      s = Solution.new(parse_input(fname))
      s.setup_b(parse_input(fname), n, v)
      val = s.solve_a
      if (val == desired)
        return 100 * n + v
      end
    end
  end
  return -1
end

def main
  puts 'Hello World'
  # print 'solution A: ', Solution.new(parse_input('input.txt')).solution_a, "\n"
  print 'solution B: ', solution_b_static('input.txt'), "\n"
end

require 'test/unit'

class Tester < Test::Unit::TestCase
  def test_sample_a
    assert_equal(3500, Solution.new(parse_input('sample.txt')).solve_a)
    
  end

  def test_a; end

  def test_sample_b
    x = Solution.new([])
    x.setup_b(parse_input('sample.txt'), 12, 2)
    # assert_equal(3500, x.solve_a)
  end

  def test_solutions
    assert_equal(3765464, Solution.new(parse_input('input.txt')).solution_a)
    assert_equal(7610, solution_b_static('input.txt'))
    assert_equal(7610, Solution.new(parse_input('input.txt')).solution_b)
  end
end

main
