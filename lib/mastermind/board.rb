class Board
  attr_reader :colors, :master_code_counts, :turns
  attr_accessor :grid, :master_code

  def initialize(input = {}) #board is initialized with default colors, grid, turns, and starting master code.
    @turns = input.fetch(:turns, default_turns)
    @colors = input.fetch(:colors, default_colors)
    @master_code = input.fetch(:master_code, random_code)
    @master_code_counts = input.fetch(:master_code_counts, find_color_counts)
    @grid = input.fetch(:grid, default_grid)
  end

  private
  
  def default_colors
    ['red', 'blue', 'green', 'yellow', 'purple', 'pink']
  end
  
  def default_turns
    12
  end

  def find_color_counts(code = master_code) #this creates a hash to be used as a master counter.
    counts = {}
    code.each do |element|
      if !counts[element]
        counts[element] = 0
      end
      counts[element] = counts[element] + 1
    end
    counts
  end

  def default_grid
    Array.new(turns) { Array.new(8) { Cell.new } }
  end

  def random_code
    [colors.sample, colors.sample, colors.sample, colors.sample]
  end

  public

  def display #prints every row of the grid in sequence.
    grid.each do |row|
      puts row.map { |cell| cell.value }.join(' ')
    end
  end

  def get_cell(x, y)
    grid[x][y]
  end

  def set_cell(x, y, value)
    get_cell(x, y).value = value
  end
end