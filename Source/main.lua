import "CoreLibs/timer"
import "CoreLibs/sprites"

import "game"

local pd <const> = playdate
local gfx <const> = pd.graphics

local game <const> = Game()
game:Initialize()

---@diagnostic disable-next-line: duplicate-set-field
function pd.update()
    pd.timer.updateTimers()
    game:Update()
    gfx.sprite.update()
end
