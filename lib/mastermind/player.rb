class Player
  attr_reader :name, :memory

  def initialize(name)
    @name = name
    @memory = default_memory
  end

  private

  def default_memory
    Array.new(4) { Cell.new }
  end
end