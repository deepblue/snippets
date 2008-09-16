%w(rubygems highline/import yaml facets/ruby facets/random).each{|lib| require lib }

class Question < Struct.new(:statement, :yes, :no); end

class YamlStore
  def initialize(name)
    @name = name
  end
  
  def load(quiz)
    yml = YAML.load(File.read(@name)) rescue {}
    yml = {}
    quiz.animals = yml[:animals] || %w(코끼리)
    quiz.questions = (yml[:questions] || []).map{|ary| Question.new(*ary)}
  end
  
  def save(quiz)
    dump = {:animals => quiz.animals, :questions => quiz.questions.map{|q| q.to_a}}
    File.open(@name, 'w') {|f| f.write(dump.to_yaml) }
  end
end

class Quiz
  PROMPT = '=> '
  attr_accessor :animals, :questions
  
  def initialize
    @line = HighLine.new
    @store = YamlStore.new('animal.yml')
    @store.load(self)
  end
  
  def init_game
    @candidates   = @animals.dup
    @question_set = @questions.dup
    @true_steps   = []
    @false_steps  = []

    say "\n\n" + PROMPT + '동물을 하나 생각하세요...'
  end
  
  def start
    init_game
    start unless game_loop
  end
  
  def game_loop
    loop do
      if @candidates.length == 1
        final_question
        break want_quit?
        
      elsif @candidates.length == 2
        if random_guess(@candidates.at_rand!)
          break want_quit?
        end
        
      elsif @question_set.empty?
        defeated
        break want_quit?
        
      else
        pick_question
        
      end
    end
  end
  
  def pick_question
    # 전략이 필요하다!
    # 일단 내 전략은 random~~ 오예
    q = @question_set.at_rand!
    
    agreed = agree(PROMPT + q.statement)
    to_remove = agreed ? q.no : q.yes
    (agreed ? @true_steps : @false_steps) << q
    @candidates.reject!{|a| to_remove.include?(a)}
  end
  
  def random_guess(animal)
    agree(PROMPT + "#{animal} 맞지?").tap do |ret|
      say("으하하 나는 천재!") if ret
    end
  end
  
  def final_question
    agree(PROMPT + "#{@candidates.first} 맞지?") ?
      say("으하하 나는 천재!") :
      defeated
  end
  
  def defeated
    new_animal = ask(PROMPT + "내가 졌다. 근데 생각하던 동물은 뭐야?").to_s
    @animals.include?(new_animal) ? 
      say("우씨~ 사기꾼!") :
      add_animal(new_animal)
  end
  
  def add_animal(new_animal)
    @questions << new_question(new_animal, @animals.last)
        
    @animals << new_animal
    @true_steps.each {|q| q.yes << new_animal unless q.yes.include?(new_animal) }
    @false_steps.each{|q| q.no  << new_animal unless q.no.include?(new_animal)  }
    
    @store.save(self)
  end
  
  def new_question(new_animal, last)
    q = ask(PROMPT + "#{last}랑 #{new_animal}을 구분할 수 있는 문제를 하나 내줘~ 부탁이야")
    a = agree(PROMPT + "#{new_animal}는 #{q}... 예스야? 노야?")
    
    ret = Question.new(q.to_s, [], [])
    ret.send(a ? :yes : :no) << new_animal
    ret
  end
  
  def want_quit?
    agree(PROMPT + '그만 할래?')
  end
end

if __FILE__ == $0
  Quiz.new.start 
end