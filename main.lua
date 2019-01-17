-- Draw a rectangle on the game grid at coordinates x and y
function draw_cell(x, y)
  love.graphics.rectangle(
    "fill",
    x * cell_length,
    y * cell_length,
    cell_length,
    cell_length
  )
end

function draw_cell_circle(x, y)
  love.graphics.circle(
    "fill",
    (2*x + 1) / 2 * cell_length,
    (2*y + 1) / 2 * cell_length,
    cell_length / 2
  )
end

-- Determine if a cell is part of the snake
function is_snake_cell(cell)
  for _, snake_cell in ipairs(snake_cells) do
    if snake_cell.x == cell.x and snake_cell.y == cell.y then
      return true
    end
  end

  return false
end

-- Return a cell where snake does not exist
function get_empty_cell()
  local rand_x = love.math.random(0, x_max)
  local rand_y = love.math.random(0, y_max)

  while is_snake_cell({x = rand_x, y = rand_y}) do
    rand_x = love.math.random(0, x_max)
    rand_y = love.math.random(0, y_max)
  end

  return {x = rand_x, y = rand_y}
end

-- Reset or start the game
function reset_game()
  snake_live = true
  timer = 0

  -- Coordinates for the player's snake. The end of the table is the
  -- snake's tail and the start of the table is the snake's head.
  local start_x = love.math.random(3, x_max)
  local start_y = love.math.random(0, y_max)

  snake_cells = {
    {x = start_x, y = start_y},
    {x = start_x - 1, y = start_y},
    {x = start_x - 2, y = start_y},
  }

  -- Coordinates for berry (food)
  berry_cell = get_empty_cell()

  -- Direction inputs
  this_direction = "right"
  prev_direction = "right"
end

function love.load()
  -- Minimum dimensions of game
  game_width = 400
  game_height = 300
  aspect_ratio = game_width / game_height

  -- Grid attributes
  cell_length = 10
  x_max = game_width / cell_length - 1
  y_max = game_height / cell_length - 1

  -- Set the window
  local window_flags = {
    minheight=game_height,
    minwidth=game_width,
    resizable=true,
  }

  love.window.setMode(game_width * 2, game_height * 2, window_flags)

  -- Add title to window
  love.window.setTitle("love-snake")

  -- Add background music
  music = love.audio.newSource("assets/background_music.wav", "stream")
  music:setLooping(true)
  music:play()

  -- Load berry eat sound effect
  sound_eat = love.audio.newSource("assets/berry_eat.mp3", "static")

  -- Game speed (how often in seconds the game state updates)
  game_speed = 0.069

  -- Global to determine state of snake game
  snake_live = true

  -- Start the game
  reset_game()
end

function love.update(dt)
  -- Add dt to timer
  if snake_live then
    timer = timer + dt

    if timer > game_speed then
      -- Find the next coordinate of the head
      if this_direction == "left" then
        next_x = snake_cells[1].x - 1
        next_y = snake_cells[1].y
      elseif this_direction == "right" then
        next_x = snake_cells[1].x + 1
        next_y = snake_cells[1].y
      elseif this_direction == "up" then
        next_x = snake_cells[1].x
        next_y = snake_cells[1].y - 1
      else
        -- Down
        next_x = snake_cells[1].x
        next_y = snake_cells[1].y + 1
      end

      -- Wrap around the stage as necessary
      if next_x == x_max + 1 then
        next_x = 0
      elseif next_x == -1 then
        next_x = x_max
      elseif next_y == y_max + 1 then
        next_y = 0
      elseif next_y == -1 then
        next_y = y_max
      end

      -- Check for collision with snake
      if is_snake_cell({x = next_x, y = next_y}) then
        snake_live = false

        return
      end

      -- Move the snake
      if next_x == berry_cell.x and next_y == berry_cell.y then
        sound_eat:play()
        berry_cell = get_empty_cell()
      else
        table.remove(snake_cells)
      end

      table.insert(snake_cells, 1, {x = next_x, y = next_y})

      -- Refresh the last used direction
      prev_direction = this_direction

      -- Refresh timer for next cycle
      timer = timer - game_speed
    end
  end
end

function love.draw()
  -- Dimensions of current window
  local window_width = love.graphics.getWidth()
  local window_height = love.graphics.getHeight()

  -- Scale to window while maintaining aspect ratio
  local scale_width
  local scale_height
  local translate_x
  local translate_y

  if window_width >= aspect_ratio * window_height then
    scale_height = window_height / game_height
    scale_width = scale_height

    translate_x = (window_width - game_width * scale_width) / 2
    translate_y = 0
  else
    scale_width = window_width / game_width
    scale_height = scale_width

    translate_x = 0
    translate_y = (window_height - game_height * scale_height) / 2
  end

  love.graphics.translate(translate_x, translate_y)
  love.graphics.scale(scale_width, scale_height)

  -- Draw a background colour
  love.graphics.setColor(0.069, 0.069, 0.069)

  love.graphics.rectangle("fill", 0, 0, game_width, game_height)

  -- Draw the snake
  for cell_index, cell in ipairs(snake_cells) do
    -- Use different colours for the head
    if cell_index == 1 then
      love.graphics.setColor(0.843, 0.851, 0.694)
    elseif cell_index == 2 then
      love.graphics.setColor(0.518, 0.675, 0.808)
    end

    -- Draw the cell
    draw_cell(cell.x, cell.y)
  end

  -- Draw the berry
  love.graphics.setColor(0.886, 0.627, 1)
  draw_cell_circle(berry_cell.x, berry_cell.y)

  -- Print a reset message if it's game over
  if not snake_live then
    love.graphics.setColor(1, 1, 1)

    love.graphics.printf(
      "press space to restart",
      0,
      game_height / 2,
      game_width,
      "center"
    )
  end
end

function love.keypressed(key)
    if (key == "right" or key == "d") and prev_direction ~= "left" then
      this_direction = "right"
    elseif (key == "left" or key == "a") and prev_direction ~= "right" then
      this_direction = "left"
    elseif (key == "down" or key == "s") and prev_direction ~= "up" then
      this_direction = "down"
    elseif (key == "up" or key == "w") and prev_direction ~= "down" then
      this_direction = "up"
    end

    if (not snake_live and key == "space") then
      reset_game()
    end
end
