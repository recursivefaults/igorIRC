require 'cinch'

class Dance
  include Cinch::Plugin
  attr_accessor :all_steps
  match /^dance igor dance/i

  def initialize(bot)
    super
  #def get_steps()
    
    heads = ["o-"]
    arms = ["Z", "L", "\\", "|", "/", "]", "["]
    torsos = ["-"]
    legs = ["<", "\\", "/"]
    @all_steps = Array.new 
    
    heads.each do |h|
      arms.each do |a|
        torsos.each do |t|
          legs.each do |l|
            @all_steps << h + a + t + l
          end
        end
      end
    end
    
    #@all_steps = ["o-L-<", "o-\\-<", "o-|-<", "o-/-<", "o-]-<", "o-[-<",
    #             "o-L-\\", "o-\\-\\", "o-|-\\", "o-/-\\", "o-]-\\", "o-[-\\",
    #             "o-L-/", "o-\\-/", "o-|-/", "o-/-/", "o-]-/", "o-[-/"] 
  end
  
  def execute(m)
    
    #all_steps = get_steps()
    #get a number of dance steps (at least 3 and up to 10)
    r = Random.new()
    steps = r.rand(3..10)
    
    out = ""
    (0..steps).each do 
      out += "#{@all_steps[r.rand(0..@all_steps.length)].to_s}\n"
    end
    out += "...and JAZZ HANDS!"
    
    m.reply out
    
  end
end

