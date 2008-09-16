%w(rubygems facets/ruby facets/random).each{|lib| require lib}

class RandomPlayer < Player
  def choose
    [:rock, :paper, :scissors].pick
  end
end