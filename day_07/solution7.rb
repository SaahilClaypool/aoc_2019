# frozen_string_literal: true

# Day 2:

# op codes

def parse_input(input_file = './input.txt')
  File.open(input_file).read
      .strip.split(',')
      .map(&:to_i)
end

class Program
  attr_accessor :pc, :mem, :last_output

  def initialize(mem, inp = 1, input_list = nil, output_list = nil, id = 'p')
    @mem = mem
    @pc = 0
    @inp = inp
    @id = id

    @input_list = input_list
    @output_list = output_list
  end

  def op
    mode = @mem[@pc] / 100
    modes = []
    op = @mem[@pc] % 100
    (0..2).each { |i| modes << mode / (10**i) % 10 }
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
    opcode, modes = self.op
    case opcode
    when 1 # add
      a, ai, am = param(modes[0])
      b, bi, bm = param(modes[1])
      c, ci, cm = write_idx
      @mem[c] = a + b
    when 2 # mult
      a, ai, am = param(modes[0])
      b, bi, bm = param(modes[1])
      c, ci, cm = write_idx
      @mem[c] = a * b
    when 3 # input
      c, ci, cm = write_idx
      @mem[c] = input
    when 4 # output
      a, ai, am = param(modes[0])
      self.output(a)
      # return a.zero? # TODO this might break old programs
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
      # p "halt with #{opcode}, #{@id}"
      output(@last_output)
      return false
    end
    true
  end

  # Adjusted: 
  # First, get input for phase setting (0 to 4)
  # After, 
  def input
    if @input_list && @first_inp
      val = @input_list.next
      # puts "#{@id} next #{val}"
      val
    else
      @first_inp = true
      # puts "#{@id} got first #{@inp}"
      @inp
    end
  end

  #TODO 
  def output(val)
    @last_output = val
    if @output_list
      @output_list.push(val)
    else 
      # puts "output: #{val}"
    end
  end

  def run
    while step; end
    @last_output
  end

  def run_async
    handle = Thread.new {
      while step; end
      # puts "thread #{@id} over"
    }
    handle
  end

end

class Queue

  def initialize(id = 'q')
    @lock = Mutex.new
    @write_in = 0
    @read_in = 0
    @data = []
    @id = id
  end

  # get the next input - block until 
  def next
    val = nil
    while val.nil?
      @lock.synchronize {
        if @read_in < @write_in
          val = @data[@read_in]
          @read_in += 1
          return val
        end
      }
      sleep(0.001)
    end
    val
  end

  def push(val)
    # puts "\t#{@id} pushing #{val}"
    @lock.synchronize {
      @data <<  val
      @write_in += 1
    }
  end

end

def hookup(a, b, c, d, e, input_file = 'input.txt')
  # puts "\n\n"
  a_in = Queue.new
  10.times {a_in.push(0)}

  a_out = Queue.new('a')
  b_out = Queue.new('b')
  c_out = Queue.new('c')
  d_out = Queue.new('d')
  e_out = Queue.new('e')

  a = Program.new(parse_input(input_file), a, a_in,  a_out, 'a')
  b = Program.new(parse_input(input_file), b, a_out, b_out, 'b')
  c = Program.new(parse_input(input_file), c, b_out, c_out, 'c')
  d = Program.new(parse_input(input_file), d, c_out, d_out, 'd')
  e = Program.new(parse_input(input_file), e, d_out, e_out, 'e')

  ah = a.run_async
  bh = b.run_async
  ch = c.run_async
  dh = d.run_async
  eh = e.run_async

  ah.join
  # puts "a.join"

  bh.join
  # puts "b.join"

  ch.join
  # puts "c.join"

  dh.join
  # puts "d.join"

  eh.join
  # puts "e.join"

  final_output = e_out.next

  # puts "final output: #{final_output}"

  final_output
end


def solveA(filename = 'input.txt')
  max_v = 0
  max_ar = []
  [0, 1, 2, 3, 4].permutation.each do |p|
    v = hookup(*p, filename)
    if v > max_v
      max_v = v
      max_ar = p
    end
  end
  max_v
end


def hookupB(a, b, c, d, e, input_file = 'input.txt')
  # puts "\n\n"
  a_in = Queue.new
  1.times {a_in.push(0)}

  a_out = Queue.new('a')
  b_out = Queue.new('b')
  c_out = Queue.new('c')
  d_out = Queue.new('d')

  a = Program.new(parse_input(input_file), a, a_in,  a_out, 'a')
  b = Program.new(parse_input(input_file), b, a_out, b_out, 'b')
  c = Program.new(parse_input(input_file), c, b_out, c_out, 'c')
  d = Program.new(parse_input(input_file), d, c_out, d_out, 'd')
  e = Program.new(parse_input(input_file), e, d_out, a_in, 'e')

  ah = a.run_async
  bh = b.run_async
  ch = c.run_async
  dh = d.run_async
  eh = e.run_async

  ah.join
  # puts "a.join"

  bh.join
  # puts "b.join"

  ch.join
  # puts "c.join"

  dh.join
  # puts "d.join"

  eh.join
  # puts "e.join"

  final_output = e.last_output

  # puts "final output: #{final_output}"

  final_output

end

def solveB(filename = 'input.txt')
  max_v = 0
  max_ar = []
  [5, 6, 7, 8, 9].permutation.each do |p|
    v = hookupB(*p, filename)
    if v > max_v
      max_v = v
      max_ar = p
    end
  end
  max_v
end



def main
  v = solveA
  p "final solution A: #{v}"

  v = solveB
  p "final solution B: #{v}"


end

# require 'test/unit'
# class Tester < Test::Unit::TestCase
#   def test_a
#     assert_equal(43_210, solveA('sample.txt'))
#     assert_equal(54_321, solveA('sample2.txt'))
#     # assert_equal(65_210, solveA('sample3.txt'))
#     assert_equal(199_988, solveA('input.txt'))
#   end

#   def test_b
#     assert_equal(139_629_729, solveB('./sample3.txt'))
#   end
# end

main
def test_queue
  q = Queue.new
  t1 = Thread.new {
    loop do
      v = q.next
      p v
    end
  }

  t2 = Thread.new {
    loop do
      q.push(1)
      sleep(0.1)
    end
  }

  t1.join
  t2.join
end