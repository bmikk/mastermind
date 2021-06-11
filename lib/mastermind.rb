

require_relative 'mastermind/player.rb'
require_relative 'mastermind/cell.rb'
require_relative 'mastermind/board.rb'
require_relative 'mastermind/game.rb'
require_relative 'mastermind/human_logic.rb'
require_relative 'mastermind/computer_logic'


module Mastermind

  puts "----------Welcome to Mastermind!----------"
  puts ''
  puts ''
  puts "What is your name?"
  human_name = gets.chomp
  game = Game.new([Player.new(human_name), Player.new('Computer')]).begin

end 


