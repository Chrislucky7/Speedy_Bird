PlayState3 = Class{__includes = BaseState}

PIPE_SPEED = 180
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState3:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.score = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState3:update(dt)
    self.timer = self.timer + dt

    if self.timer > 1.25 then
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-80, 80), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y
        table.insert(self.pipePairs, PipePair(y))
        self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do

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

function PlayState3:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    love.graphics.setFont(smallFont)
    love.graphics.print('Game Difficulty: ' .. difficulty, 8, 48)

    self.bird:render()
end

