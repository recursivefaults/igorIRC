# igor v2
# an igor IRC bot written in ruby using Cinch DSL

require 'cinch'

#plugins
require_relative 'plugins/hello.rb'
require_relative 'plugins/dice.rb'
require_relative 'plugins/dance.rb'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.otherworlders.org"
    c.channels = ["#igor_dev"]
    c.nick = "igor_dev"
    c.plugins.plugins = [Hello, Dice, Dance]
    c.plugins.prefix = ""
    
    @admin = ["papaganoush"]
    @versoin = "1.0.1"
    @release_date = 2011/2/1
    @author = "http://scr.im/papaganoush"
  end

  helpers do
    def is_admin?(user, channel)
      true if @admin.include?(user.nick) || user.nick =~ /(:?gm|dm)/i || Channel(channel).opped?(user)
    end  
  end

  #self reporting messages
  on :message, /^info(?:rmation)?\s/ do |m, channel|
    m.reply "My name is #{bot.nick}. I was created by #{@author}. My current version is #{@version}. I was turned on on the morning of #{@release_date}. Would you like to play a game?"
  end
  
  # manage the joining and parting of the bot from channels
  # todo: allow any user to force the bot to leave using a pass phrase override
  on :message, /^join (.+)/ do |m, channel|
    if is_admin?(m.user, channel)
      #m.user.send "joining #{channel}"
      bot.join(channel)
    end
  end

  on :message, /^part(?: (.+))?/ do |m, channel|
    # Part current channel if none is given
    channel = channel || m.channel

    if channel
      bot.part(channel) if is_admin?(m.user, channel)
    end
  end
  
  on :invite do |m|
    if is_admin?(m.user, m.channel)
      #m.user.send "joining #{channel}"
      bot.join(m.channel)
    end
  end  
end

bot.start