local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

-- 10 * 10 = 100 + 9 = 109 + 8 = 117
-- 20 * 10 = 200 + 19 = 219 + 8 = 227

local borderRect <const> = geo.rect.new(170, 7, 117, 227)
gfx.setLineWidth(2)
gfx.setStrokeLocation(gfx.kStrokeInside)
gfx.drawRect(borderRect)
gfx.setStrokeLocation(gfx.kStrokeCentered)
gfx.setLineWidth(1)

local fieldRect <const> = geo.rect.new(174, 11, 109, 219)
-- gfx.drawRect(fieldRect)

local tileSize <const> = 10
local tileImage <const> = gfx.image.new(tileSize, tileSize, gfx.kColorWhite)
gfx.pushContext(tileImage)
gfx.drawRect(0, 0, tileSize, tileSize)
gfx.fillRect(3, 3, 4, 4)
gfx.popContext()

tileImage:draw(10, 10)
tileImage:draw(21, 21)

for i = 0, 9, 1 do
    for j = 0, 19, 1 do
        local x <const> = fieldRect.x + 11 * i
        local y <const> = fieldRect.y + 11 * j
        tileImage:draw(x, y)
    end
end



function pd.update()

end
