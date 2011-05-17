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
    @arithmaticStack = []
  end
  
  def handleModifier(input)
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
  attr_accessor :expression, :sign, :display, :total, :match, :numDice, :numSides
  def initialize()
    @modifier = 0
    @expression = ""
    @sign = 1
    @display = ""
    @total = 0
    @numDice = 1
    @numSides = 0
    @match = /(\d)*[dD](\d)+/
  end
  
  def handleModifier(expression)
    modHandler = ModifierHandler.new
    @modifier = modHandler.handleModifier(expression)
  end
  
  def supportsRoll(expression)
    if (expression =~ match) == nil
      return false
    else
      expression.scan(match) {|@numDice, @numSides|}
      @numDice = @numDice.to_i
      @numSides = @numSides.to_i
      handleModifier(expression)
      
      if @numDice == nil
        @numDice = 1
      end
    end
    return true
  end
  
  def roll(modifier = 0)
    srand()
    if @numSides == 0
      return
    end
    for i in 0...@numDice
      r = rand(@numSides) + 1
      @display << "#{r}"
      @total += r
      if i < @numDice-1
        @display << " + "
      end
    end
    if modifier > 0
      @total += modifier
      @display <<  "+ #{@modifier}"
    end
  end
end

class FudgeDice < BasicDice
  def initizlize()
    super
    @match = /(\d)*[dD]([fF])/
  end
  
  def supportsRole(expressions)
    if (expression =~ match) == nil
      return false
    else
      handleModifier(expression)
      expression.scan(match) {|@numDice|}
      if @numDice == nil
        @numDice = 1
      end
    end
  end
  
  def roll(modifier = 0)
    
  end
  
end

require "test/unit"

class TestLibraryFileName < Test::Unit::TestCase
  def testBaseDice1
    d = BasicDice.new
    d.roll
    assert(d.total == 0, "Failure message.")
  end
  
  def test_BasicDice2
    d = BasicDice.new
    d.numDice = 3
    d.numSides = 6
    d.roll
    assert(d.total >= 1, "Failure message.")
  end
  
  def test_BasicDice3
    d = BasicDice.new
    assert(d.supportsRoll("4d6(3-1)"), "Failed to support good die expression: 4d6")
  end
  
  def test_BasicDice4
    d = BasicDice.new
    assert(d.supportsRoll("d6"), "Failed to support good die expression: d6")
  end

  def test_BasicDice5
    d = BasicDice.new
    assert(!d.supportsRoll("ad6"), "Accepting bad expression: ad6")
  end

  def test_BasicDice5
    d = BasicDice.new
    assert(d.supportsRoll("4D6"), "Failed to support good die expression: 4D6")
  end
  def test_BasicDice6
    d = BasicDice.new
    assert(!d.supportsRoll("4D"), "Accepting bad expression: 4D")
  end
  def test_BasicDice7
    d = BasicDice.new
    assert(d.supportsRoll("4D6"), "Failed to support good die expression: 4D6")
    d.roll
    assert(d.total >= 1, "We didn't roll for some reason")
  end
  
  def test_HandleModifier1
    m = ModifierHandler.new
    assert(m.handleModifier("(4+5)") == 9, "Failed to handle simple modifier")
    
  end
  def test_HandleModifier2
    m = ModifierHandler.new
    assert(m.handleModifier("(5)") == 5, "Failed to handle simple modifier")
    
  end
  def test_HandleModifier3
    m = ModifierHandler.new
    assert(m.handleModifier("(-5)") == -5, "Failed to handle simple modifier")
  end
  def test_HandleModifier4
    m = ModifierHandler.new
    assert(m.handleModifier("(-a)") == 0, "Failed to handle simple modifier")
    
  end
  

  
end