import "CoreLibs/timer"
import "CoreLibs/sprites"

import "game"

local pd <const> = playdate
local gfx <const> = pd.graphics

local game <const> = Game()
game:Initialize()

-- function buildImage()
--     local image <const> = gfx.image.new(10, 10)
--     gfx.pushContext(image)
--     gfx.drawRect(0, 0, 10, 10)
--     gfx.fillRect(3, 3, 4, 4)
--     gfx.popContext()
--     return image
-- end

-- local image = buildImage()
-- local sprite = gfx.sprite.new(image)
-- sprite:moveTo(200, 120)
-- sprite:add()
-- local borderRect <const> = pd.geometry.rect.new(10, 10, 10, 10)
-- gfx.drawRect(borderRect)


---@diagnostic disable-next-line: duplicate-set-field
function pd.update()
    pd.timer.updateTimers()
    game:Update()
    gfx.sprite.update()
end
