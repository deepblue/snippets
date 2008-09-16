%w(rubygems facets/ruby facets/random).each{|lib| require lib}

class OnlyOnePlayer < Player
  def initialize(*args)
    @choose = [:rock, :paper, :scissors].pick
    super
  end
  attr_reader :choose
end