# frozen_string_literal: true

# Day 7:

# op codes

def parse_input(input_file = 'input.txt')
  File.read(input_file).split('').map(&:to_i)
end

class Image
  attr_accessor :width, :height

  def initialize(digits, width = 25, height = 6)
    @width = width
    @height = height
    @digits = digits
    @frame = []

    (0..height - 1).each do |_h|
      row = []
      (0..width - 1).each do |_w|
        row << 2
      end
      @frame << row
    end
  end

  def rep
    (0..@height - 1).each do |r|
      row = []
      (0..@width - 1).each do |c|
        c = @frame[r][c]
        l = ' '
        l = if c == 1
              'x'
            elsif c == 2
              '.'
            else
              ' '
            end
        print l
      end
      puts ''
    end
  end

  def apply(layer)
    (0.. @height - 1).each do |r|
      (0.. @width - 1).each do |c|
        idx = r * @width + c
        ch = layer[idx]
        @frame[r][c] = ch if @frame[r][c] == 2 # only draw on transparent layers
      end
    end
  end

  def collapse
    (0..num_layers - 1).each do |l|
      layer = get_layer(l)
      apply(layer)
    end
  end

  # return the start and end index of a layer
  def get_layer_idx(n = 0)
    start_idx = n * (@width * @height)
    end_idx = (n + 1) * (@width * @height)
    [start_idx, end_idx - 1]
  end

  def num_layers
    l = @digits.length / (@width * @height)
    l
  end

  def get_layer(n = 0)
    s, e = get_layer_idx(n)
    @digits[s..e]
  end
end

class Solution
  def initialize(nums); end

  def self.solution_a(image)
    min0 = nil
    ml = 0
    hsh = 0
    (0..image.num_layers - 1).each do |l|
      layer = image.get_layer(l)
      num0 = layer.select { |val| val == 0 }.length

      next unless min0.nil? || num0 < min0

      min0 = num0

      ml = l

      pp "min layer: idx: #{l}, num_zero: #{min0}, length: #{layer.length}"

      num1 = layer.select { |val| val == 1 }.length
      num2 = layer.select { |val| val == 2 }.length
      pp "#{num1} * #{num2} = #{num1 * num2}"
      hsh = num1 * num2
    end

    p 'best layer'
    p image.get_layer(ml)

    hsh
  end

  def solution_b; end
end

def main
  im = Image.new(parse_input)
  # im = Image.new([0,2,2,2,1,1,2,2,2,2,1,2,0,0,0,0], 2, 2)

  im.rep

  im.collapse

  puts ""
  
  im.rep 

end

main

exit

require 'test/unit'

class Tester < Test::Unit::TestCase
  def test_sample_a
    im = Image.new([1, 2, 1, 0, 0, 2, 7, 1, 9, 0, 1, 2], 3, 2)
    assert_equal(2, im.num_layers)
    assert_equal([0, 5], im.get_layer_idx(0))
    assert_equal(2, Solution.solution_a(im))
  end

  def test_a; end

  def test_sample_b; end

  def test_solutions; end
end
