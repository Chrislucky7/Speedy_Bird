Pipe = Class{}
--more memory efficient
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

PIPE_SPEED = 60

PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
     self.x = VIRTUAL_WIDTH

     self.y = y

     self.width = PIPE_IMAGE:getWidth()
     self.height = PIPE_HEIGHT

     self.orientation = orientation
end

function Pipe:update(dt)
     
end

function Pipe:render()
     love.graphics.draw(PIPE_IMAGE, self.x, (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 0, 1, self.orientation == 'top' and -1 or 1) --if the pipe is designated to top then its y scale will be -1 while mirrors the image along the y-axis, and if it isn't a top then it will be set as 1
end