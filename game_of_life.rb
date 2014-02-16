GRID_SIZE = 40

class Array
  def rjust(n, x); Array.new([0, n-length].max, x)+self end
  def ljust(n, x); dup.fill(x, length...n) end
end

class GameOfLife
  include Enumerable

  def initialize(grid)
    @current_round = Round.new(grid)
    puts @current_round.render
    puts "----------------------------------------------------------------"
    self.each do |round|
      puts round
      puts "----------------------------------------------------------------"
      sleep 2
    end
  end

  def to_s
    @current_round.render
  end

  def each(&block)
    (0..Float::INFINITY).each do |i|
      @current_round = @current_round.mutate
      block.call(@current_round.render)
    end
  end

end

class Round



  def prepare_grid(grid)
    new_grid = grid.dup
    if grid[0].any? { |el| el } || grid[-1].any? { |el| el } || grid.transpose[0].any? { |el| el } || grid.transpose[-1].any? { |el| el }
      new_grid = new_grid.map {|line| line.rjust(new_grid.size + 1, false).ljust(new_grid.size + 2, false) }
      new_grid = new_grid.rjust(new_grid.size + 1, new_grid[0].map {false} ).ljust(new_grid.size + 2, new_grid[0].map { false })
    end
    new_grid
  end


  def initialize(grid)
    @grid = grid
  end

  def render
    @grid.map do |line|
      line.map { |e| e ? "*" : "." }.join
    end.join("\n")
  end

  def mutate
    new_grid = Array.new(GRID_SIZE, Array.new(GRID_SIZE, false))
    neighbour_count_grid = neighbour_count

    (0..GRID_SIZE-1).each do |row|
      (0..GRID_SIZE-1).each do |col|
        if has_life? row, col
          new_grid[row][col] = [2,3].include? neighbour_count_grid[row][col]
        else
          new_grid[row][col] = neighbour_count_grid[row][col] == 3
        end
      end
    end
    Round.new(new_grid)
  end

  def neighbour_count
    neighbour_grid = Array.new(GRID_SIZE, Array.new(GRID_SIZE, false))
    (0..GRID_SIZE-1).each do |row|
      (0..GRID_SIZE-1).each do |col|
        result = neighbours_surrounding(row, col).inject(0) do |mem, co_ord|
          mem += 1 if has_life?(co_ord[0], co_ord[1])
          mem
        end
        neighbour_grid[row][col] = result
      end
    end
    neighbour_grid
  end


  def neighbours_surrounding(x, y)
    possible_results = [
                        [x-1, y-1],
                        [x-1, y],
                        [x-1, y+1],
                        [x, y-1],
                        [x, y+1],
                        [x+1, y-1],
                        [x+1, y],
                        [x+1, y+1]
                       ]

    result = possible_results.select do |arr|
      arr[0] >= 0 &&
        arr[1] >= 0 &&
        arr[0] <= GRID_SIZE-1 &&
        arr[1] <= GRID_SIZE-1
    end
    result
  end

  def has_life?(x,y)
    @grid[x][y]
  end

  def calculate_bounds
    @grid.each do |line|

    end
  end

  def calculate_min_width
    min_height = nil
    max_height = nil
    min_width = nil
    max_width = nil

    @grid.each_with_index do |el, i|
      line.each_with_index do |el, j|
        max_width  = j if el && (!max_width  || j > max_width)
        max_height = i if el && (!max_height || i > max_height)
      end
    end
    min
  end

end

vals = [true, false]

grid = []

GRID_SIZE.times do
  row = []
  GRID_SIZE.times do
    row << vals.sample
  end
  grid << row
end

GameOfLife.new(grid)
