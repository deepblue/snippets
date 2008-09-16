class ShadowPlayer < Player
  def choose
    @last || :rock
  end
  
  def result(you, them, win_lose_or_draw)
    @last = them
  end
end