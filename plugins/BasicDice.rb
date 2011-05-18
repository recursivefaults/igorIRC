=begin
  TODO Update the ModifierHandler to be safer. Right now it does no checking
  TODO Unit test complete Die expressions with modifiers
  TODO Write the handler that will execute the Chain of Command and split die expressions
=end
class ModifierHandler
  attr_accessor :modifier
  def initialize
    @modifier = 0
    @match = /\(([^\)]*)\)/
  end
  
  def handle_modifier(input)
    if (input =~ @match) == nil
      return 0
    else
      arithmatic = input.scan(@match)
      begin
        @modifier = eval(arithmatic[0].to_s)
      rescue
        @modifier = 0
      end
    end

    return modifier
  end    
end
class BasicDice
  attr_accessor :expression, :sign, :display, :total, :match, :num_dice, :num_sides
  def initialize()
    @modifier = 0
    @expression = ""
    @sign = 1
    @display = ""
    @total = 0
    @num_dice = 1
    @num_sides = 0
    @match = /(\d)*[dD](\d)+/
  end
  
  def handle_modifier(expression)
    modHandler = ModifierHandler.new
    @modifier = modHandler.handle_modifier(expression)
  end
  
  def supports_roll(expression)
    if (expression =~ @match) == nil
      return false
    else
      expression.scan(@match) {|@num_dice, @num_sides|}
      @num_dice = @num_dice.to_i
      @num_sides = @num_sides.to_i
      handle_modifier(expression)
      
      if @num_dice == nil
        @num_dice = 1
      end
    end
    return true
  end
  
  def roll(modifier = 0)

    if @num_sides == 0
      return
    end
    for i in 0...@num_dice
      srand()
      r = rand(@num_sides) + 1
      @display << "#{r}"
      @total += r
      if i < @num_dice-1
        @display << " + "
      end
    end
    append_modifier
  end
  def append_modifier
    if @modifier > 0
      @total += @modifier
      @display << " + #{@modifier}"
    end
  end
  def append_total
    @display << " = #{@total}"
  end
end

class FudgeDice < BasicDice
  def initialize()
    super
    @match = /(\d)*[dD][fF]/
  end
  
  def supports_roll(expression)
    if (expression =~ @match) == nil
      return false
    else
      handle_modifier(expression)
      expression.scan(@match) {|@num_dice|}
      if @num_dice == nil || @num_dice[0] == nil
        @num_dice = 1
      else
        @num_dice = @num_dice[0].to_i
      end
    end
    return true
  end
  
  def roll(modifier = 0)
    for i in 0...@num_dice
      srand()
      r = rand(3)
      case r        
        when 2
          @total += 1
          @display << "[+]"
        when 1
          @display << "[ ]"
        when 0
          @total += -1
          @display << "[-]"
        end
      if i != @num_dice -1
        @display << " "
      end
    end
    append_modifier
    append_total
  end
end

require "test/unit"

class TestLibraryFileName < Test::Unit::TestCase
  def test_HandleModifier1
    m = ModifierHandler.new
    assert(m.handle_modifier("(4+5)") == 9, "Failed to handle simple modifier")
    
  end
  def test_HandleModifier2
    m = ModifierHandler.new
    assert(m.handle_modifier("(5)") == 5, "Failed to handle simple modifier")
    
  end
  def test_HandleModifier3
    m = ModifierHandler.new
    assert(m.handle_modifier("(-5)") == -5, "Failed to handle simple modifier")
  end
  def test_HandleModifier4
    m = ModifierHandler.new
    assert(m.handle_modifier("(-a)") == 0, "Failed to handle simple modifier")
  end
  
  def testBaseDice1
    d = BasicDice.new
    d.roll
    assert(d.total == 0, "Failure message.")
  end
  
  def test_BasicDice2
    d = BasicDice.new
    d.num_dice = 3
    d.num_sides = 6
    d.roll
    assert(d.total >= 1, "Failure message.")
  end
  
  def test_BasicDice3
    d = BasicDice.new
    assert(d.supports_roll("4d6(3-1)"), "Failed to support good die expression: 4d6")
  end
  
  def test_BasicDice4
    d = BasicDice.new
    assert(d.supports_roll("d6"), "Failed to support good die expression: d6")
  end

  def test_BasicDice5
    d = BasicDice.new
    assert(!d.supports_roll("ad6"), "Accepting bad expression: ad6")
  end

  def test_BasicDice5
    d = BasicDice.new
    assert(d.supports_roll("4D6"), "Failed to support good die expression: 4D6")
  end
  def test_BasicDice6
    d = BasicDice.new
    assert(!d.supports_roll("4D"), "Accepting bad expression: 4D")
  end
  def test_BasicDice7
    d = BasicDice.new
    assert(d.supports_roll("4D6"), "Failed to support good die expression: 4D6")
    d.roll
    assert(d.total >= 1, "We didn't roll for some reason")
  end
  
  def test_FudgeDice1
    d = FudgeDice.new
    assert(d.supports_roll("df"), "Failed to support valid fudge roll (df)")
    d.roll
    assert(d.display != "", "Empty display, failed to roll.")
    puts("Fudge Test 1: #{d.display}")
  end
  def test_FudgeDice2
    d = FudgeDice.new
    assert(d.supports_roll("2Df"), "Failed to support valid fudge roll (2df)")
    d.roll
    assert(d.display != "", "Empty display, failed to roll.")
    puts("Fudge Test 2: #{d.display}")
  end
  def test_FudgeDice3
    d = FudgeDice.new
    assert(d.supports_roll("4dF"), "Failed to support valid fudge roll (2df)")
    d.roll
    assert(d.display != "", "Empty display, failed to roll.")
    puts("Fudge Test 3: #{d.display}")
  end
  def test_FudgeDice4
    d = FudgeDice.new
    assert(d.supports_roll("4DF(+3)"), "Failed to support valid fudge roll (2df)")
    d.roll
    assert(d.display != "", "Empty display, failed to roll.")
    puts("Fudge Test 4: #{d.display}")
  end
  

  

  
end