# frozen_string_literal: true

# Day 2:

# op codes

def parse_input(input_file = './input.txt')
  File.open(input_file).read
      .strip.split(',')
      .map(&:to_i)
end

class Program
  attr_accessor :pc, :mem

  def initialize(mem, inp = 1)
    @mem = mem
    @pc = 0
    @inp = inp
  end

  def op
    mode = @mem[@pc] / 100
    modes = []
    op = @mem[@pc] % 100
    (0..2).each { |i| modes << mode / (10**i) % 10 }
    p "#{op}, #{@mem[@pc]}, #{@pc}"
    @pc += 1
    [op, modes]
  end

  def param(mode = 0, position = 0)
    v = 0
    vi = 0
    if !mode.zero? || !position.zero?
      vi = @pc
    else
      vi = @mem[@pc]
    end
    @pc += 1
    v = @mem[vi]
    [v, vi, mode]
  end

  def write_idx
    param(0, 1)
  end

  def step
    p "#{@mem[0..10]}"
    opcode, modes = self.op
    case opcode
    when 1 # add
      a, ai, am = param(modes[0])
      b, bi, bm = param(modes[1])
      c, ci, cm = write_idx
      p "add #{a}:#{am} #{b}:#{bm} -> #{c}"
      @mem[c] = a + b
    when 2 # mult
      a, ai, am = param(modes[0])
      b, bi, bm = param(modes[1])
      c, ci, cm = write_idx
      @mem[c] = a * b
      p "mult #{a}:#{am} * #{b}:#{bm} -> #{c}"
    when 3 # input
      c, ci, cm = write_idx
      @mem[c] = input
      p "get -> #{c}"
    when 4 # output
      a, ai, am = param(modes[0])
      p "output: #{a}:#{am}, #{a.zero?}"
      return a.zero?
    when 5 # jump if true
      a, ai, am = param(modes[0])
      b, bi, bm = param(modes[1])
      if !a.zero?
        @pc = b
      end
    when 6
      a, ai, am = param(modes[0])
      b, bi, bm = param(modes[1])
      if a.zero?
        @pc = b
      end
    when 7
      a, ai, am = param(modes[0])
      b, bi, bm = param(modes[1])
      c, ci, cm = write_idx
      if a < b
        @mem[c] = 1
      else 
        @mem[c] = 0
      end
    when 8
      a, ai, am = param(modes[0])
      b, bi, bm = param(modes[1])
      c, ci, cm = write_idx
      if a == b
        @mem[c] = 1
      else 
        @mem[c] = 0
      end
    else
      p @mem
      p "halt with #{opcode}"
      return false
    end
    true
  end

  def input
    @inp
  end

end


def main
  # prg = Program.new(parse_input('old_input.txt'))
  # prg.mem[1] = 12
  # prg.mem[2] = 2

  # prg = Program.new([1,9,10,3,2,3,11,0,99,30,40,50])
  # prg = Program.new([1002, 4, 3, 4, 33])

  # part a

  # prg = Program.new(parse_input)

  # while prg.step; end

  # part b

  prg = Program.new(parse_input('input.txt'), 5)

  while prg.step; end

end

main
