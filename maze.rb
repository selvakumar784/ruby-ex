
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
    @maze_split.each_with_index do |val, idx|
      @maze[idx] = Hash.new()
      val.split('').each_with_index do |value, index|
        @maze[idx][index] = value;
      end
    end


    @start_x = 0
    @start_y = 0
    @end_x =0
    @end_y = 0
    
    #Find source and destination positions
    @maze.each do |key, value|
      value.each do |id, line|
        if line == 'A'
          @start_x = key
          @start_y = id
        end
        if line == 'B'
          @end_x = key
          @end_y = id
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

  def walk(x1, y1, x2, y2)
    
  end
  #Check if a position is already visited
  def alreadyseen(i, j)
    return true if @visited[i][j] == 1
  end

  def solvable_maze(x1, y1, x2, y2)
    #if destination reached, return true
    return true if (x1 == x2 && y1 == y2)
    
    if (x1 >=0 && x1 <= @xmax && y1 >=0 && y1 <= @ymax)
      #if already seen or found a block, return
      if @maze[x1][y1] == '#' || (@maze[x1][y1] == ' ' && alreadyseen(x1, y1))
        return
      else
        #Mark current pos as seen.
        @visited[x1][y1] = 1
        
        #Recurse for up, down, left and right positions.
        return true if solvable_maze(x1, y1 - 1, x2, y2) == true
        return true if solvable_maze(x1, y1 + 1, x2, y2) == true
        return true if solvable_maze(x1 - 1, y1, x2, y2) == true
        return true if solvable_maze(x1 + 1, y1, x2, y2) == true
        return false
      end
    end
    return false
  end
  def solvable_maze_steps(x1, y1, x2, y2, len, minimum, ind)
    #If destination reached, add number of steps taken for current route and return true
    if (x1 == x2 && y1 == y2)
      minimum[ind] = len 
      ind = ind + 1
      return true
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
        return true if solvable_maze_steps(x1, y1 - 1, x2, y2, len, minimum, ind) == true
        return true if solvable_maze_steps(x1, y1 + 1, x2, y2, len, minimum, ind) == true
        return true if solvable_maze_steps(x1 - 1, y1, x2, y2, len, minimum, ind) == true
        return true if solvable_maze_steps(x1 + 1, y1, x2, y2, len, minimum, ind) == true
        return false
      end
    end
    return false
  end

  def solvable?
    res = false;

    #Recurse for up, down, left and right positions
    res |= solvable_maze(@start_x - 1, @start_y, @end_x, @end_y)
    res |= solvable_maze(@start_x + 1, @start_y, @end_x, @end_y)
    res |= solvable_maze(@start_x, @start_y - 1, @end_x, @end_y)
    res |= solvable_maze(@start_x, @start_y + 1, @end_x, @end_y)
    return res;
  end

  def steps?
    res = false
    len = 0
    ind = 0
    minimum = Hash.new(0)
    
    res |= solvable_maze_steps(@start_x - 1, @start_y, @end_x, @end_y, len, minimum, ind)
    res |= solvable_maze_steps(@start_x + 1, @start_y, @end_x, @end_y, len, minimum, ind)
    res |= solvable_maze_steps(@start_x, @start_y - 1, @end_x, @end_y, len, minimum, ind)
    res |= solvable_maze_steps(@start_x, @start_y + 1, @end_x, @end_y, len, minimum, ind)
    
    #Find minimum step count
    min_steps = 999999;
    for i in 0...minimum.length
      min_steps = minimum[i] if minimum[i] < min_steps
    end
    return min_steps;
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

