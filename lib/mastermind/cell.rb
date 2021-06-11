class Cell
  attr_accessor :value, :match, :preferred_guesses, :valid_guesses

  def initialize(value = '-')
    @value = value
    @match = '0'
    @preferred_guesses = []
    @valid_guesses = ['red', 'blue', 'green', 'yellow', 'purple', 'pink']
  end
end
