#dice.rb
require 'cinch'

require_relative '../lib/dice_engine'

class Dice
  include Cinch::Plugin

  attr_accessor :debug_mode

  def initialize(bot)
    super
    
    #set the debug mode
    @debug_mode = true
  end
  
  #respond to dice, roll or rpg
  match /^dice\s*/i
  match /^roll\s*/i
  match /^rpg\s*/i

  def execute(m)
    begin
      d = Library::Dice.new
      
      #remove the command reom the message
      expression = m.message
      expression = expression.sub("dice ","")
      expression = expression.sub("roll ","")
      expression = expression.sub("rpg ","")
      
      m.reply expression
      
      m.reply d.roll(expression)
        
    rescue Exception => e
      m.reply e.message
      m.reply e.backtrace if @debug_mode == true
    end
  end
  
  def old_execute(m)
    begin

m.reply ";:#{m.message.split(m.message, /\s/).to_s};:"
      #parse out the dice expression and any comments.
      #should call an external class that can be reused: i.e. result = Dice.parse_for_expression(message)
      dice = parse_input(m)
      
      m.reply "Do you want me to roll some dice, #{m.user.nick}?"
      m.reply "how about I roll #{dice[0]} dice with #{dice[1]} sides"
      r = Random.new()

      out = "rolling #{dice[2]} for #{m.user.nick}: "
      #should call an external class that can be reused: i.e. result = Dice.roll(expression)
      total = 0
      (1..dice[0].to_i).each do |i|
        tmp = r.rand(0..dice[1].to_i)+1
        out += "#{tmp.to_s}," 
        total += tmp
      end
      
      out.chomp!
      out += ": #{total}"
      m.reply "#{out} <<but this should really have a template>>"
      
    rescue Exception => e
      m.reply e.message
      m.reply e.backtrace if @debug_mode == true
    end 
  end
  
  def parse_input(message)
    
    out = Array.new
    #assume format of "command dice expression comment"
    
    split_text = out.split(out, /\s/)
message.reply split_text.to_s    
    input = message.message.gsub(/^dice\s*/, "")
    
    out = input.split(/d/i)
    out << message.message.gsub(/^dice\s*/, "")
    return out
  end
  
end
