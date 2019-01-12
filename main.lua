function love.load()
  -- Minimum dimensions of game
  game_width = 400
  game_height = 300
  aspect_ratio = game_width / game_height

  -- Set the window
  local window_flags = {
    centered=true,
    minheight=game_height,
    minwidth=game_width,
    resizable=true,
  }

  love.window.setMode(game_height, game_width, window_flags)

end

function love.draw()
  -- Dimensions of current window
  local window_width = love.graphics.getWidth()
  local window_height = love.graphics.getHeight()

  -- Scale to window while maintaining aspect ratio
  local scale_width
  local scale_height

  if window_width >= aspect_ratio * window_height then
    scale_height = window_height / game_height
    scale_width = scale_height
  else
    scale_width = window_width / game_width
    scale_height = scale_width
  end

  love.graphics.scale(scale_width, scale_height)

  love.graphics.printf("hello", 0, game_height / 2, game_width, "center")
end
