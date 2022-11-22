TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    self.bird = Bird()
    
    if love.keyboard.wasPressed('1') then
        gStateMachine:change('countdown')
        difficulty = 'easy'
    end
    if love.keyboard.wasPressed('2') then
        gStateMachine:change('countdown')
        difficulty = 'medium'
    end
    if love.keyboard.wasPressed('3') then
        gStateMachine:change('countdown')
        difficulty = 'hard'
    end
end

function TitleScreenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Speedy Bird', 0, 64, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press 1 for Easy Mode', 0, 200, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press 2 for Regular Mode', 0, 220, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press 3 for Hard Mode', 0, 240, VIRTUAL_WIDTH, 'center')
end