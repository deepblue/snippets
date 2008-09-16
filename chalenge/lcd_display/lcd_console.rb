%w(rubygems facets/ruby facets/enumerable/collect facets/bitmask).each{|lib| require lib }

IDENTITY = [
  0b1110111, # 0    -       6
  0b0010010, # 1   | |     5 4
  0b1011101, # 2    -       3
  0b1011011, # 3   | |     2 1
  0b0111010, # 4    -       0 
  0b1101011, # 5
  0b1101111, # 6
  0b1110010, # 7
  0b1111111, # 8
  0b1111011, # 9
]

class Board
  def initialize(scale, num)
    @scale  = scale
    @num    = num
  end
    
  def print
    numary = @num.to_s.split('').map(&:to_i)
    
    puts horizontal(numary, 6)
    @scale.times{ puts vertical(numary, 5, 4) }
    puts horizontal(numary, 3)
    @scale.times{ puts vertical(numary, 2, 1) }
    puts horizontal(numary, 0)
  end
    
  def horizontal(num, bit)
    map_with_digit(num) {|n| 
      " #{char(on?(n, bit), '-')*@scale} "
    }
  end
  
  def vertical(num, bit1, bit2)
    map_with_digit(num) {|n| 
      [char(on?(n, bit1), '|'), ' '*@scale, char(on?(n, bit2), '|')].join
    }
  end
  
  ##############################
  # Helpers
  
  def char(bool, symbol)
    bool ? symbol : ' '
  end
      
  def on?(n, bit)
    IDENTITY[n].bit?(bit)
  end
  
  def map_with_digit(num)
    num.map{|n| yield n}.join(' ')
  end
end

# Example
Board.new(3, 1234567890).print

# Result
#      ---   ---         ---   ---   ---   ---   ---   --- 
#   |     |     | |   | |     |     |   | |   | |   | |   |
#   |     |     | |   | |     |     |   | |   | |   | |   |
#   |     |     | |   | |     |     |   | |   | |   | |   |
#      ---   ---   ---   ---   ---         ---   ---       
#   | |         |     |     | |   |     | |   |     | |   |
#   | |         |     |     | |   |     | |   |     | |   |
#   | |         |     |     | |   |     | |   |     | |   |
#      ---   ---         ---   ---         ---   ---   ---