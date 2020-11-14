keybindings = Class{}

function keybindings:list(key)
    if edit == true then
        InputKey = tostring (key)
        if love.keyboard.isDown(key) then
            edit = false
        end
    end

    if edit == false then
        p1keyUpOpen, p1keyDownOpen, p2keyUpOpen, p2keyDownOpen = false, false, false, false
    end
end

