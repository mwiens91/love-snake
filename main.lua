function love.load()
  -- Minimum dimensions of game
  game_width = 400
  game_height = 300
  aspect_ratio = game_width / game_height

  -- Set the window
  local window_flags = {
    minheight=game_height,
    minwidth=game_width,
    resizable=true,
  }

  love.window.setMode(game_width * 2, game_height * 2, window_flags)

  -- Add background music
  music = love.audio.newSource("assets/background_music.wav", "stream")
  music:setLooping(true)
  music:play()
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

  love.graphics.printf("hello", 0, game_height / 2, game_width, "center")
end
