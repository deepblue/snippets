%w(rubygems facets/ruby facets/random).each{|lib| require lib}

class DelegatePlayer < Player
  def initialize(opponent)
    classes = Player.module_eval("@@players") - [self.class]
    @players = classes.map{|k| k.new(opponent)}
  end
  
  def choose
    @last_player = @players.pick
    @last_player.choose
  end
  
  def result(you, them, win_lose_or_draw)
    @last_player.result(you, them, win_lose_or_draw)
  end
end