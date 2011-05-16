# hello plugin for igor version 2

require 'cinch'

class Hello
  include Cinch::Plugin

  match /^hello/i, method: :say_hello
  match /^slap/i, method: :say_ow

  def say_hello(m)
      m.reply "Hello, #{m.user.nick}" if !(m.user.nick =~ /.*igor.*/i)
  end

  def say_ow(m)
    m.reply "is violence really nessisary, #{m.user.nick}?"
  end
  
end