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

  -- TODO testing
  x = 0
  y = 5
  timer = 0
end

-- TODO testing
function love.update(dt)
  timer = timer + dt

  if timer > 1 then
    x = x + 1

    if x == x_max + 1 then
      x = 0
    end

    timer = timer - 1
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

  -- TODO testing some rectangles
  love.graphics.setColor(1, 0, 0)
  draw_cell(x, y)

  -- Print a welcome message
  love.graphics.setColor(1, 1, 1)

  love.graphics.printf("hello", 0, game_height / 2, game_width, "center")
end

function draw_cell(x, y)
  love.graphics.rectangle(
    "fill",
    x * cell_length,
    y * cell_length,
    cell_length,
    cell_length
  )
end
