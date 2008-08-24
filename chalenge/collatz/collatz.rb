%w(rubygems facets/ruby facets/memoize).each{|lib| require lib}

class Fixnum
  def next_number
    even? ? self / 2 :
      self * 3 + 1
  end
end

class Solver
  def collatz_from(num)
    num == 1 ? [1] :
      [num] + collatz_from(num.next_number)
  end
  memoize :collatz_from

  def find_length(num)
    collatz_from(num).length
  end

  def max_length(from, to)
    (from..to).to_a.map{|n| find_length(n)}.max
  end  
end

require 'benchmark'

describe "3N + 1" do
  describe "Fixnum" do
    it "should calculate next number" do
      4.next_number.should == 4/2
      5.next_number.should == 5*3+1
    end
  end
  
  describe "Solver" do
    it "should calculate 3N+1" do
      answer = [22, 11, 34, 17, 52, 26, 13, 40, 20, 10, 5, 16, 8, 4, 2, 1]
      Solver.new.collatz_from(22).should == answer
      Solver.new.find_length(22).should == answer.length
    end

    it "should calculate max length" do
      Solver.new.max_length(1,10).should == 20
      Solver.new.max_length(100,200).should == 125
      Solver.new.max_length(900,1000).should == 174
    end
    
    it "should benchmark" do
      puts Benchmark.measure { Solver.new.max_length(1, 10000)}
    end
  end
end