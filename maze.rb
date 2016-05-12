
MAZE1 = %{#####################################
# #   #     #A        #     #       #
# # # # # # ####### # ### # ####### #
# # #   # #         #     # #       #
# ##### # ################# # #######
#     # #       #   #     # #   #   #
##### ##### ### ### # ### # # # # # #
#   #     #   # #   #  B# # # #   # #
# # ##### ##### # # ### # # ####### #
# #     # #   # # #   # # # #       #
# ### ### # # # # ##### # # # ##### #
#   #       #   #       #     #     #
#####################################}
# Maze 1 should SUCCEED

MAZE2 = %{#####################################
# #       #             #     #     #
# ### ### # ########### ### # ##### #
# #   # #   #   #   #   #   #       #
# # ###A##### # # # # ### ###########
#   #   #     #   # # #   #         #
####### # ### ####### # ### ####### #
#       # #   #       # #       #   #
# ####### # # # ####### # ##### # # #
#       # # # #   #       #   # # # #
# ##### # # ##### ######### # ### # #
#     #   #                 #     #B#
#####################################}
# Maze 2 should SUCCEED

MAZE3 = %{#####################################
# #   #           #                 #
# ### # ####### # # # ############# #
#   #   #     # #   # #     #     # #
### ##### ### ####### # ##### ### # #
# #       # #  A  #   #       #   # #
# ######### ##### # ####### ### ### #
#               ###       # # # #   #
# ### ### ####### ####### # # # # ###
# # # #   #     #B#   #   # # #   # #
# # # ##### ### # # # # ### # ##### #
#   #         #     #   #           #
#####################################}

class Maze
  def initialize(maze)
    @maze = maze
    #Split the given input string
    @maze_split = @maze.split("\n")
    
    #calulate rows and columns
    @ymax = @maze_split[0].length
    @xmax = @maze_split.length

    #Create a two dimensional hash
    @maze = Hash.new()
    @maze_split.each_with_index do |x, i|
      @maze[i] = Hash.new()
      x.split('').each_with_index do |y, j|
        @maze[i][j] = y;
      end
    end

    @start_x = 0
    @start_y = 0
    @end_x =0
    @end_y = 0
    
    #Find source and destination positions
    @maze.each do |x1, row|
      row.each do |y1, col|
        if col == 'A'
          @start_x = x1
          @start_y = y1
        end
        if col == 'B'
          @end_x = x1
          @end_y = y1
        end
      end
    end

    #Create a visited 2D hash
    @visited = Hash.new()
    for i in 0..@xmax
      @visited[i] = Hash.new()
      for j in 0..@ymax
        @visited[i][j] = 0
      end
    end
  end

  #Check if a position is already visited
  def alreadyseen(i, j)
    return true if @visited[i][j] == 1
  end

  def solvable_maze(x1, y1)
    #if destination reached, return true
    return true if (x1 == @end_x && y1 == @end_y)
    
    if (x1 >= 0 && x1 <= @xmax && y1 >= 0 && y1 <= @ymax)
      #if already seen or found a block, return
      if @maze[x1][y1] == '#' || (@maze[x1][y1] == ' ' && alreadyseen(x1, y1))
        return
      else
        #Mark current pos as seen.
        @visited[x1][y1] = 1
        
        #Recurse for up, down, left and right positions.
        return true if solvable_maze(x1, y1 - 1) == true
        return true if solvable_maze(x1, y1 + 1) == true 
        return true if solvable_maze(x1 - 1, y1) == true
        return true if solvable_maze(x1 + 1, y1) == true
        return false
      end
    end
    return false
  end

  def solvable_maze_steps(x1, y1, len, step_counts, index)
    #If destination reached, add number of steps taken for current route and return true
    if (x1 == @end_x && y1 == @end_y)
      step_counts[index] = len 
      index = index + 1
    end

    if (x1 >= 0 && x1 <= @xmax && y1 >= 0 && y1 <= @ymax)
      #if already seen or found a block, return
      if @maze[x1][y1] == '#' || (@maze[x1][y1] == ' ' && alreadyseen(x1, y1))
        return
      else
        #Mark current pos as seen.
        @visited[x1][y1] = 1
        
        #Increment step coount and recurse for up, down, left and right positions.
        len = len + 1
        solvable_maze_steps(x1, y1 - 1, len, step_counts, index)
        solvable_maze_steps(x1, y1 + 1, len, step_counts, index)
        solvable_maze_steps(x1 - 1, y1, len, step_counts, index)
        solvable_maze_steps(x1 + 1, y1, len, step_counts, index)
      end
    end
  end

  def solvable?
    res = false;

    #Recurse for up, down, left and right positions
    res |= solvable_maze(@start_x - 1, @start_y)
    res |= solvable_maze(@start_x + 1, @start_y)
    res |= solvable_maze(@start_x, @start_y - 1)
    res |= solvable_maze(@start_x, @start_y + 1)
  end

  def steps?
    len = 0
    index = 0
    step_counts = Hash.new(0)
    
    solvable_maze_steps(@start_x - 1, @start_y, len, step_counts, index)
    solvable_maze_steps(@start_x + 1, @start_y, len, step_counts, index)
    solvable_maze_steps(@start_x, @start_y - 1, len, step_counts, index)
    solvable_maze_steps(@start_x, @start_y + 1, len, step_counts, index)
    
    #Find minimum step count
    min_steps = 999999;
    for i in 0...step_counts.length
      min_steps = step_counts[i] if step_counts[i] < min_steps
    end
    min_steps
  end
end

maze1_result = Maze.new(MAZE1).solvable?
maze1_steps = Maze.new(MAZE1).steps?
puts "#{maze1_result}, #{maze1_steps}"

maze2_result = Maze.new(MAZE2).solvable?
maze2_steps = Maze.new(MAZE2).steps?
puts "#{maze2_result}, #{maze2_steps}"

maze3_result = Maze.new(MAZE3).solvable?
maze3_steps = Maze.new(MAZE3).steps?
puts "#{maze3_result}, #{maze3_steps}"

