
class Navigation
  @last_move = :up

  def initialize(game)
    @width = game[:board][:width]
    @height = game[:board][:height]
  end

  def move(board)
    next_move = rand_move
    dump(next_move)
    while collides(next_move, board)
      next_move = rand_move
      dump(next_move)
    end
    @last_move = next_move
    { move: next_move }
  end

  def rand_move
    (%i[up down left right] - [opposite(@last_move)]).sample
  end

  def opposite(direction)
    case direction
    when :up
      :down
    when :down
      :up
    when :left
      :right
    when :right
      :left
    end
  end

  def direction_to_coord(direction)
    { up: { x: 0, y: -1 },
      down: { x: 0, y: 1 },
      left: { x: -1, y: 0 },
      right: { x: 1, y: 0 } }[direction]
  end

  def collides(direction, board)
    coords = board[:you][:body][0].dup

    move_coords = direction_to_coord(direction)

    puts "Direction #{direction} => #{move_coords[:x]}/#{move_coords[:y]}"

    coords[:x] += move_coords[:x]
    coords[:y] += move_coords[:y]
    puts "New coords: #{coords[:x]}/#{coords[:y]}"

    collide_x = !coords[:x].between?(0, board[:board][:width] - 1)
    collide_y = !coords[:y].between?(0, board[:board][:height] - 1)

    puts 'X Collition ahead!' if collide_x
    puts 'Y Collition ahead!' if collide_y

    collide_x || collide_y
  end

  def dump(direction)
    puts "Snake moves #{direction}"
  end
end
