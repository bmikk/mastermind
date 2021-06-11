#TODO:
  #refactor code to better organize?
  #add more game options -- difficulty.
  #remove puts statements
  #remove unnecessary comments



#Could add options for: 
  #changing the game length (difficulty), 
  #prompts or pauses between computer turns for better readability,
  #final prompts for playing again or exiting.




#BRAINSTORMING NOTES:

#ideally, how should the gameplay logic be structured?

#ready to play a game? Y/N
  #if no, exit
  #if yes, continue
#What is your name?
  #set player with input name, continue
#Would you like to be the Code Breaker? (Y/N)
  #using all previous input:
    #initialize a player with the given name,
    #run either the Code Breaker or Code Maker logic depending on the input.

#Code Breaker Logic
  #create a new board with the computer setting the master code.
  #prompt human player for a guess
  #compare that guess with the master code
    #for each exact match, assign an X
    #for each partial match, assign an O if not already represented by an X or O
    #assign nothing for each miss
  #if all 4 colors are guessed correctly, declare a winner and end the game.
  #if not all guessed correctly and turn limit is not reached, continue.
  #if not all guessed correctly and turn limit IS reached, end the game and declare a loss.

#Code Maker Logic
  #create a new board with the human player setting the master code.
  #ask player if they are ready for computer to start guessing
  #if yes, run a computer guess:
    #have computer pick a random combination of colors for the first guess
    #compare the computer guess
      #for each exact match, the computer will remember it and make that same guess for the rest of the round.
      #for each 0, have the computer remember remember to use that color in a different slot, but not in that exact slot in the next guess.
      #for each miss, have the computer remember and make sure it does not use that color at all in any more guesses.
  #if computer did not win, prompt the player if they are ready for the computer to take its next turn
  #repeat until there is either a winner or loser.


  


  #so how do we do the logic for computer guesses?
  #first, computer tries a random combination of colors, lets say blue-red-pink-yellow
  #then we run a comparison.
  #after that comparison, the computer has information it needs to remember:
    #it needs to remember to save any exact matches
    #it needs to remember to actively look for any partial matches it discovers
    #it needs to remember which colors are complete misses, and not to use those colors any more.
  #how to accomplish this?
    #an array can remember exactly which colors are exact matches, and update its guesses accordingly.
      #so if blue and red are exact matches, pink is a miss, and yellow is an O, it could create: 
        #an array that marks ['blue', 'red', '-', '-'].
        #then, it needs to remember that yellow is present, but not in the location it tried.
          #what if we created an array of cells that each remember which color has been tried?
          #each cell would have a key for each color, and the computer could check the values of each cell to determine what it should guess.
          #so for a given cell, it would need to know:
            #do any of the colors register as an exact match?
              #if yes, use that color as its guess for that cell for the remainder.
                #how to accomplish this?
                  #when preparing a guess, have the computer first check each cell to see if it has found a match. If it has, use it and move on to evaluate the next cell.
            #do any of the colors read as not present?
              #if yes, do NOT use that color for ANY guesses for the remainder.
                #how to accomplish this?
                #after a comparison, change the values of appropriate color keys to "Not Present".
                  #if a color is a complete miss, have it change the values of that color key in ALL cells to "Not Present"
                  #if a color is a partial match, have it change the key for that color on that particular cell to "Not Present", but not any other cells.
            #then, for that cell, it can pick a random sample of remaining valid guesses.
            #in other words, when preparing a guess, the computer would: 
              #see if it must use a color because of a previous exact match guess:
              #otherwise, build an array of valid guesses for that cell.
            #by now, each cell will have an array of valid possible guesses to choose from, so we can initiate a guess with a sample from each array


#if each cell includes an array of valid possible guesses, we could manipulate those arrays depending on the comparisons.
#so we would start full random, with each cell guess array containing every color as a valid guess.
#then, if a comparison finds an exact match:
  #remove every item from that cell's guess array except for the matched guess.
#or if a comparisons finds a partial guess, 
  #remove that color from that cell's guess array,  
  #and populate every other cell's "preferred" array that does not yet possess an exact match with that color
  
#then when preparing a guess, the computer would give priority first 
  #to an established match, 
  #then to a sample from the preferred array, and
  #finally to a remaining valid guess if no other choice. 

#another way to accomplish that would be to have a cell with a "match" key that would be filled by default with 0 or something,
#then a "preferred" array of colors starting at empty, and then also a 
#array of all remaining valid guesses, starting with all the colors.

    #if we do that, the logic when preparing a guess would be:
      #for each cell in the memory array:
        #if cell[match] != "0"
          #guess[current_index] = cell[match]
        #elsif !cell[preferred].empty?
          #guess[current_index] = cell[preferred_guesses].sample
        #else
          #guess[current_index] = cell[valid_guesses].sample
        #end
      #end
      #return guess

    #this would leave us with a whittled down 4-item array of valid guesses to use in a comparison.

  #then, the logic for running a comparison would almost identical to the player_turn method, just substituting "computer" for "player" in the naming:

  #but this doesn't update the cells or valid guesses. How do we do that? We need different comparison logic. 
  #in addition to the comparison itself to check for matches, we then need to take that and update the "memory" array for future guesses.
  #so our comparison instead needs to be:

=begin
  def compare_guess(guess)
    code = board.master_code.clone
    counts = set_counters(code)
    comparison_array = ['-', '-', '-', '-']
    guess.each_with_index do |element, index|
      puts "current counts are #{counts}"
      if !code.any?(element) #complete miss, keep the blank and move on.
        cell[valid_guesses].delete_at(cell[valid_guesses].find_index(element)) #removes the current element from the array of valid guesses
        next
      elsif code[index] == guess[index] #exact match, assign an X and move on
        comparison_array[index] = 'X'
        counts[element] -= 1
        #then we need to set a match for that cell in the "memory"
        cell[match] = element
      else #if we get here, an O should be assigned, but only if there are remaining elements left in the counter
        if counts[element] > 0
          comparison_array[index] = 'O'
          counts[element] -= 1
          cell[valid_guesses].delete_at(cell[valid_guesses].find_index(element))
          #then we need to add this element to the preferred arrays of every other cell except this one.
          memory.each_with_index do |cell, cell_index|
            unless cell_index == index
              cell[preferred_guesses] << element
            else
              next
            end
          end
        else #if we get here, that means we still have a partial match, but it's already been covered by a previous iteration. so we do nothing.
          next
        end
      end
    end
    puts "final counts for this comparison are #{counts}"
    comparison_array
  end
=end

    #we could further simplify this by creating the following methods:
      #a method that will search an array for a given element and remove it if it finds it.
      #maybe a method that adds an element to a specific array if certain parameters are met.

  #additionally, what do we need in order for this logic to work?
    #an array of cells that each have keys for:
      #match
      #preferred_guesses
      #valid_guesses
    #why not just add these keys to the cell class? 
    #then we also need a "memory" array somewhere to save our remembered guesses. Where to put it?
      #with the player class? So we would initialize a player with one? And it would just go unused with a human player?
        #less good, because there's really no other reason to make the computer a "player"
      #maybe a new ComputerPlayer class? Not a bad idea. No reason not to add more classes as needed, other than just added complexity.
