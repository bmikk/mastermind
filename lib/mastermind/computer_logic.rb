module ComputerLogic

  def get_computer_guess
    puts "Hmm, I'll try this..."
    guess = []
    current_player.memory.each_with_index do |memory_cell, index|
      puts "Remembered match for cell #{index + 1} is #{memory_cell.match}"
      puts "Remembered preferred guesses for cell #{index + 1} are #{memory_cell.preferred_guesses}"
      puts "Remembered valid guesses for cell #{index + 1} are #{memory_cell.valid_guesses}"
      if memory_cell.match != "0"
        guess << memory_cell.match
      elsif !memory_cell.preferred_guesses.empty?
        guess << memory_cell.preferred_guesses.sample
      else
        guess << memory_cell.valid_guesses.sample
      end
    end
    puts "My guess is #{guess}"
    guess
  end

  def computer_turn(turn)
    current_row = board.grid[turn]
    puts "Turn #{turn + 1}"
    player_guess = get_computer_guess
    set_guess(current_row, player_guess)
    comparison = compare_guess(player_guess)
    set_comparison(current_row, comparison)
    board.display
    game_over?(player_guess)
  end

  def make_code
    puts "Ok #{other_player.name}, choose a code for the computer to break! Pick four of the following colors: #{board.colors}"
    board.master_code = get_human_guess
  end

end