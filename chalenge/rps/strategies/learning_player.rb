%w(rubygems facets/ruby facets/random facets/enumerable/probability).each{|lib| require lib}

class LearningPlayer < Player
  ALL = [:rock, :paper, :scissors]
  
  def initialize(*args)
    @seq = [], [], [], []
  end
  
  def choose
    prob = probabilities
    pick = [:rock, :paper, :scissors].
            shuffle.
            sort{|x, y| prob[y] <=> prob[x] }
    beater pick.first
  end
  
  def result(you, them, win_lose_or_draw)
    @seq[1] << keys([last(1),     them].flatten)
    @seq[2] << keys([last(2,1),   them].flatten)
    @seq[3] << keys([last(3,2,1), them].flatten)
    @seq[0] << them.to_s
  end
  
protected
  def last(*ns)
    ns.map{|n| @seq[0][-n]}
  end
  
  def keys(vals)
    vals.compact.map(&:to_s).join('_')
  end
  
  def probabilities
    ps = (0..3).to_a.map{|i| look_back(i) }
    
    ret = (0..3).to_a.map do |pick|
      ps[0][pick].to_f * 0.4 + ps[1][pick].to_f * 0.3 + ps[2][pick].to_f * 0.2 + ps[1][pick].to_f * 0.1
    end
    
    { :rock => ret[0], :paper => ret[1], :scissors => ret[2] }
  end
    
  def look_back(ind)
    ps = @seq[ind].probability
    base = ind > 0 ? keys((1..ind).to_a.map{|i| @seq[0][-i]}) : nil
    
    ALL.map do |pick|
      ps[keys([base, pick])]
    end
  end
  
  def beater(pick)
    rules = {:rock => :paper, :paper => :scissors, :scissors => :rock}
    rules[pick]
  end
end