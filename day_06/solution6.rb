# frozen_string_literal: true

require 'pp'

# Day 2:

# op codes

def parse_input(input_file); end

class Orbit
  attr_accessor :name, :children, :parent
  def initialize(name, parent = nil)
    @children = []
    @name = name
    @searched = false
    @parent = parent
  end

  def rep(level = 0)
    r = ' ' * level + name.to_s
    r += ' parent: ' + @parent.name if @parent
    puts r
    children.each { |child| child.rep(level + 1) }
  end

  def weight(level = 0)
    w = @children.reduce(level) { |sum, child| sum + child.weight(level + 1) }
    w
  end

  # Return -1 if not reachable, return depth if reachable
  def search(other = 'SAN', cost = -2)
    return cost if @name == other

    return -1 if @searched

    @searched = true

    @children.each do |child|
      d = child.search(other, cost + 1)
      return d if d != -1
    end

    @parent.search(other, cost + 1)
  end
end

class OrbitMap
  attr_accessor :worlds, :root

  def self.parse_input(inp)
    world_map = {}
    world_map['COM'] = Orbit.new('COM')
    root = world_map['COM']
    lines = inp. split("\n")
    lines.map do |line|
      center, outer = line.split(')')
      # pp "#{center}, #{outer}"

      if world_map.key?(center)
        # puts "Error: world already made #{center}"
      else
        world_map[center] = Orbit.new(center)
      end
      center = world_map[center]

      if world_map.key?(outer)
        world_map[outer].parent = center
      else
        world_map[outer] = Orbit.new(outer, center)
      end

      center.children.push(world_map[outer])
    end
    [world_map, root]
  end

  def initialize(inp)
    @worlds, @root = OrbitMap.parse_input(inp)
  end
end

class Solution
  def initialize(nums); end

  def solution_a; end

  def solution_b; end
end

def main
  puts 'day_06'
end

main
require 'test/unit'
class Tester < Test::Unit::TestCase
  def test_sample
    st = "COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L"

    s = OrbitMap.new(st)
    assert_equal(42, s.root.weight)
  end

  def test_a
    s = OrbitMap.new(File.read('input.txt'))
    assert_equal(151_345, s.root.weight)
  end

  def test_b
    s = OrbitMap.new(File.read('input.txt'))
    assert_equal(391, s.worlds['YOU'].search)
  end
end

# load 'solution6.rb'
