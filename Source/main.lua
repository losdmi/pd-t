local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry


local midX <const> = 228
local screenHeight <const> = 240

local nTilesHorizontal <const> = 10
local nTilesVertical <const> = 20
local tileSize <const> = 10
local tilePadding <const> = 1
local borderThickness <const> = 2
local borderPadding <const> = 2
local borderBottomOffset <const> = 3

local fieldWidth <const> = tileSize * nTilesHorizontal + tilePadding * (nTilesHorizontal - 1)
local fieldHeight <const> = tileSize * nTilesVertical + tilePadding * (nTilesVertical - 1)
local borderWidth <const> = fieldWidth + 2 * (borderThickness + borderPadding)
local borderHeight <const> = fieldHeight + 2 * (borderThickness + borderPadding)

local borderX <const> = midX - (borderWidth - 1) / 2
local borderY <const> = screenHeight - (borderHeight + borderBottomOffset)
local fieldX <const> = borderX + borderThickness + borderPadding
local fieldY <const> = borderY + borderThickness + borderPadding

local borderRect <const> = geo.rect.new(borderX, borderY, borderWidth, borderHeight)
local fieldRect <const> = geo.rect.new(fieldX, fieldY, fieldWidth, fieldHeight)


gfx.setLineWidth(borderThickness)
gfx.setStrokeLocation(gfx.kStrokeInside)
gfx.drawRect(borderRect)
gfx.setStrokeLocation(gfx.kStrokeCentered)
gfx.setLineWidth(1)

-- gfx.drawRect(fieldRect)


local tileImage <const> = gfx.image.new(tileSize, tileSize, gfx.kColorWhite)
gfx.pushContext(tileImage)
gfx.drawRect(0, 0, tileSize, tileSize)
-- gfx.drawRect(1, 1, tileSize - 2, tileSize - 2)
gfx.fillRect(3, 3, 4, 4)
-- gfx.fillRect(2, 2, 6, 6)
gfx.popContext()

tileImage:draw(10, 10)
tileImage:draw(21, 21)

for i = 0, 9, 1 do
    for j = 0, 19, 1 do
        local x <const> = fieldRect.x + i * (tileSize + tilePadding)
        local y <const> = fieldRect.y + j * (tileSize + tilePadding)
        tileImage:draw(x, y)
    end
end



function pd.update()

end
