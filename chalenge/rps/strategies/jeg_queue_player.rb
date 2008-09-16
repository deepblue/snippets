class JEGQueuePlayer < Player
  QUEUE = [ :rock, :paper, :scissors ]

  def initialize( opponent )
    super
    @index = 0
  end

  def choose
    choice = QUEUE[@index]

    @index += 1
    @index = 0 if @index == QUEUE.size

    choice
  end
end
