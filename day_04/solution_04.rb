require 'pp'
# frozen_string_literal: true

# Day 2:

# op codes

class Guesser
  def initialize(min, max)
    @min = min
    @max = max
  end

  def is_valid(num)
    prev = '-1'
    found_match = false
    num.to_s.chars.each do |c|
      if c.to_i < prev.to_i
        return false
      end
      if prev == c
        found_match = true
      end
      prev = c
    end
    return found_match
  end

  def is_valid_b(num)
    prev = '0'
    found_match = false
    invalid = '-1'
    cs = num.to_s.chars
    (1..cs.count - 1).each  {|i| 
      c = cs[i]
      next if invalid == c
      prev = cs[i - 1]
      nxt = '-1'
      nxt = cs[i + 1] if i < cs.count - 1

      if c.to_i < prev.to_i
        return false
      end

      # puts "#{prev}, #{c}, #{nxt}"
      if c == prev 
        if nxt != prev
          # puts "found"
          found_match = true
        else 
          invalid = c
        end
      end
    }
    puts "#{num} is valid" if found_match
    return found_match
  end

  def solve_a
    (@min..@max).select { |v| is_valid(v) }.count
  end

  def solve_b
    (@min..@max).select { |v| is_valid_b(v) && is_valid(v) }.count
  end
end

g = Guesser.new(231_832, 767_346)

pp g.is_valid_b('123444')
pp g.is_valid_b('111122')
pp g.is_valid_b('112233')

# pp g.solve_a # 1330
pp g.solve_b # 
