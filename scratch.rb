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

