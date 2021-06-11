
require_relative './human_logic.rb'
require_relative './computer_logic.rb'


class Game

  attr_reader :players, :board
  attr_accessor :current_player, :other_player

  include HumanLogic
  include ComputerLogic

  @@game_over = false

  def initialize(players, board = Board.new)
    @players = players
    @board = board
    @current_player = players.first
    @other_player = players.last
  end

  private

  def switch_players
    @current_player, @other_player = @other_player, @current_player
  end

  def set_counters(array) #creates a counters hash for a given array. Used in the compare_guess method.
    counters = {}
    array.each do |element|
      if !counters[element]
        counters[element] = 0
      end
      counters[element] = counters[element] + 1
    end
    counters
  end

  def set_guess(row, guess)
    row[4].value = guess[0]
    row[5].value = guess[1]
    row[6].value = guess[2]
    row[7].value = guess[3]
  end

  def remove_memory_element(element, index)
    if current_player.memory[index].preferred_guesses.include?(element)
      current_player.memory[index].preferred_guesses.delete(element)
    end
    if current_player.memory[index].valid_guesses.include?(element)
      current_player.memory[index].valid_guesses.delete(element)
    end
  end

  def remove_memory_element_all(player, element)
    player.memory.each do |cell|
      if cell.valid_guesses.include?(element)
        cell.valid_guesses.delete(element)
      end
      if cell.preferred_guesses.include?(element)
        cell.preferred_guesses.delete(element)
      end
    end
  end

  # def add_preferred_guess(player, element, index) #CURRENTLY UNUSED. WAY TO MAKE SURE "preferred_guesses" ARRAY GETS NO DUPLICATES
  #   player.memory.each_with_index do |cell, cell_index|
  #     unless cell_index == index
  #       unless cell.preferred_guesses.include?(element)
  #         cell.preferred_guesses << element
  #       end
  #     end
  #   end
  # end

  def compare_guess(guess) #main comparison for both human and computer players
    code = board.master_code.clone
    counts = set_counters(code)
    comparison_array = ['-', '-', '-', '-']
    guess.each_with_index do |element, index| #checks for exact matches first.
      puts "X-iteration: current counts are #{counts}"
      if !code.any?(element) #complete miss, keep the blank and update the remembered elements
        puts "#{element} misses!"
        remove_memory_element_all(current_player, element)
      elsif code[index] == guess[index] #exact match, assign an X and decrement count
        puts "#{element} match! Assigning X..."
        comparison_array[index] = 'X'
        counts[element] -= 1
        current_player.memory[index].match = element
      else #element is present somewhere else, but not here. Update the memory and move to partial match evaluations.
        puts "Looks like #{element} is a partial match, will evaluate in O-iterations..."
        remove_memory_element(element, index)
      end
    end
    guess.each_with_index do |element, index| #now we can check for partial matches
      puts "O-iteration: current counts are #{counts}"
      if comparison_array[index] == 'X' || !counts[element]
        puts "#{element} already matched or unavailable, moving on..."
      else #if we get here, an O should be assigned, but only if there are remaining elements left in the counter
        if counts[element] > 0
          puts "#{element} available, assigning O..."
          comparison_array[index] = 'O'
          counts[element] -= 1
          current_player.memory.each_with_index do |memory_cell, memory_cell_index| #adds current element to the preferred arrays of every other cell except this one.
            unless memory_cell_index == index
              memory_cell.preferred_guesses << element
            end
          end
        else #if we get here, that means we still have a partial match, but it's already been covered by a previous iteration. so we do nothing.
          puts "#{element} already covered, moving on..."
        end
      end
    end
    puts "final counts for this comparison are #{counts}"
    comparison_array
  end

  def set_comparison(row, comparison)
    row[0].value = comparison[0]
    row[1].value = comparison[1]
    row[2].value = comparison[2]
    row[3].value = comparison[3]
  end

  def game_over?(guess)
    if guess == board.master_code
      @@game_over = true
    end
  end

  public

  def human_breaker?
    puts "Would you like to be the code breaker? Y/N"
    response = gets.chomp
    if response.upcase == 'Y'
      return true
    else
      return false
    end
  end

  def begin
    if human_breaker?
      human_play
    else
      switch_players
      computer_play
    end
  end

  def computer_play
    make_code
    turn = 0
    until turn == board.turns do
      computer_turn(turn)
      if @@game_over == true
        puts "#{current_player.name} cracked the code! Game over!"
        break
      else
        turn += 1
      end
    end
    if @@game_over == false && turn >= board.turns
      puts "#{current_player.name} loses! Wow, tough code!"
    end
  end

  def human_play
    turn = 0
    until turn == board.turns do
      human_turn(turn)
      if @@game_over == true
        puts "#{current_player.name} wins! Excellent job!"
        break
      else
        turn += 1
      end
    end
    if @@game_over == false && turn >= board.turns
      puts "Too bad! #{current_player.name} loses!"
    end
  end

end
