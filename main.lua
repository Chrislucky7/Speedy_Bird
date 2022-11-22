--Speedy Bird
push = require 'push'
Class = require 'class'
require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/PlayState2'
require 'states/PlayState3'
require 'states/ScoreState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

difficulty = 'easy'

local background = love.graphics.newImage('background.png')

local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514

local bird = Bird()

local pipePairs = {}

--timer for spawning pipes
local spawnTimer = 0

--keep track of the last recorded value so that gap placement is 
local lastY = -PIPE_HEIGHT + math.random(80) + 20

local scrolling = true

local BACKGROUND_MUSIC_SOUND = 0.2
local EFFECTS_SOUND = 0.75

function love.load()
     love.graphics.setDefaultFilter('nearest','nearest')

     love.window.setTitle('Fifty Bird')

     smallFont = love.graphics.newFont('font.ttf', 8)
     mediumFont = love.graphics.newFont('flappy.ttf', 14)
     flappyFont = love.graphics.newFont('flappy.ttf', 28)
     hugeFont = love.graphics.newFont('flappy.ttf', 56)
     love.graphics.setFont(flappyFont)

     sounds = {
          ['jump'] = love.audio.newSource('sounds/Jump.wav', 'static'),
          ['death'] = love.audio.newSource('sounds/Hurt.wav', 'static'),
          ['hurt'] = love.audio.newSource('sounds/Explosion.wav', 'static'),
          ['score'] = love.audio.newSource('sounds/Scor3.wav', 'static'),
          ['music'] = love.audio.newSource('sounds/menuMusic.mp3', 'static')
     }

     sounds['jump']:setVolume(EFFECTS_SOUND)
     sounds['death']:setVolume(EFFECTS_SOUND-.25)
     sounds['score']:setVolume(EFFECTS_SOUND)
     sounds['hurt']:setVolume(EFFECTS_SOUND-.25)
     sounds['music']:setLooping(true)
     sounds['music']:setVolume(BACKGROUND_MUSIC_SOUND)
     sounds['music']:play()

     push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
          vsync = true,
          fullscreen = false,
          resizeable = true,
     })

     gStateMachine = StateMachine {
          ['title'] = function() return TitleScreenState() end,
          ['countdown'] = function() return CountdownState() end, 
          ['play'] = function() return PlayState() end,
          ['play2'] = function() return PlayState2() end,
          ['play3'] = function() return PlayState3() end,
          ['score'] = function() return ScoreState() end
     }
     gStateMachine:change('title')

     love.keyboard.keysPressed = {}
end

function love.resize(w, h)
     push:resize(w,h)
end

--cant define this in bird class because it would overwrite this function
function love.keypressed(key)
     love.keyboard.keysPressed[key] = true
     if key == 'escape' then
          love.event.quit()
     end
end

function love.keyboard.wasPressed(key)
     if love.keyboard.keysPressed[key] then
          return true 
     else
          return false
     end
end
 
function love.update(dt)

     backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

     groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

     gStateMachine:update(dt)

     love.keyboard.keysPressed = {}
end

function love.draw()
     push:start()

     love.graphics.draw(background, -backgroundScroll, 0)

     gStateMachine:render()
     
     love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

     push:finish() 

end

