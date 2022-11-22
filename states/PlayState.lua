PlayState = Class{__includes = BaseState}

--change across playStates#
PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.score = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    self.timer = self.timer + dt

   --change across playStates#
    if self.timer > 2.75 then
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-70, 70), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        -- add a new pipe pair at the end of the screen at our new Y
        table.insert(self.pipePairs, PipePair(y))

        -- reset timer
        self.timer = 0
    end

    -- for every pair of pipes..
    for k, pair in pairs(self.pipePairs) do
        -- update position of pair

        if not pair.scored then
            if self.bird.x > pair.x + PIPE_WIDTH then
                self.score = self.score +1
                pair.scored = true
                sounds['score']:play()
            end
        end
        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- simple collision between bird and all pipes in pairs 
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['death']:play()
                sounds['hurt']:play()
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    self.bird:update(dt)

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['death']:play()
        sounds['hurt']:play()
        gStateMachine:change('score', {
            score = self.score
        })
    end



end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    love.graphics.setFont(smallFont)
    love.graphics.print('Game Difficulty: ' .. difficulty, 8, 48)

    self.bird:render()
end

