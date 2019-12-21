class C
    @@test_static = 0
    def self.x
        puts "#{self}, #{@@test_static}"
        @@test_static += 1
    end

    def initialize
    end

    def y 
        C.x
    end
end

class D < C
end

C.x # prints D because D has inherited its own instance
D.x # shares the same static variables
C.x # shares the same static variables
D.x # shares the same static variables

l = D.new()
l.y # can't do this no static from object

m = C.new()
m.y

p $:


class C
    def pub
        p "I am pub"
        priv
        self.priv
    end

    private_methods :priv

    def priv
        p "I am private"
    end


    def my_yielder(nums)
        for i in (0..nums - 1)
            puts block
            if block
                block.call(i)
        end
    end
end
end


def my_yielder(nums = 10, &block) # denotes a block

    for i in (0..nums - 1)
        # if block
        if block_given? # also works if implicit block given
            block.call(i)
            yield i
        else
            puts "no block : #{block}"
        end
    end
end

my_yielder

my_yielder {|i| puts "given block #{i}"}

my_yielder {|i| puts "given block #{i}"}
