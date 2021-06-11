module HumanLogic

  def request_guess
    "#{current_player.name}: Make your guess! Choose four of the following colors: #{board.colors}"
  end

  def get_human_guess #NEED TO CHECK FOR VALID INPUT
    puts "First color:"
    first_color = gets.chomp
    puts "Second color:"
    second_color = gets.chomp
    puts "Third color:"
    third_color = gets.chomp
    puts "Fourth color:"
    fourth_color = gets.chomp
    guess = [first_color, second_color, third_color, fourth_color]
    guess.each do |element|
      if !board.colors.include?(element) #NEED TO FIX THIS CHECK
        puts "Oops! Something isn't right there. Let's try again."
      end
    end
  end

  def human_turn(turn) #for human breaker only
    current_row = board.grid[turn]
    puts "Turn #{turn + 1}"
    puts request_guess
    player_guess = get_human_guess
    set_guess(current_row, player_guess)
    comparison = compare_guess(player_guess)
    set_comparison(current_row, comparison)
    board.display
    game_over?(player_guess)
  end

end