import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

class("Field").extends()

function Field:init()
    local midX <const> = 228
    local screenHeight <const> = 240

    local nTilesHorizontal <const> = 10
    local nTilesVertical <const> = 20
    self.tileSize = 10
    self.tilePadding = 1
    self.borderThickness = 2
    local borderPadding <const> = 2
    local borderBottomOffset <const> = 3

    local fieldWidth <const> = self.tileSize * nTilesHorizontal + self.tilePadding * (nTilesHorizontal - 1)
    local fieldHeight <const> = self.tileSize * nTilesVertical + self.tilePadding * (nTilesVertical - 1)
    local borderWidth <const> = fieldWidth + 2 * (self.borderThickness + borderPadding)
    local borderHeight <const> = fieldHeight + 2 * (self.borderThickness + borderPadding)

    local borderX <const> = midX - (borderWidth - 1) / 2
    local borderY <const> = screenHeight - (borderHeight + borderBottomOffset)
    local fieldX <const> = borderX + self.borderThickness + borderPadding
    local fieldY <const> = borderY + self.borderThickness + borderPadding

    self.borderRect = geo.rect.new(borderX, borderY, borderWidth, borderHeight)
    self.fieldRect = geo.rect.new(fieldX, fieldY, fieldWidth, fieldHeight)
end

function Field:draw()
    local oldLineWidth <const> = gfx.getLineWidth()
    local oldStrokeLocation <const> = gfx.getStrokeLocation()

    gfx.setLineWidth(self.borderThickness)
    gfx.setStrokeLocation(gfx.kStrokeInside)
    gfx.drawRect(self.borderRect)
    gfx.setStrokeLocation(oldStrokeLocation)
    gfx.setLineWidth(oldLineWidth)

    -- gfx.drawRect(fieldRect)


    local tileImage <const> = gfx.image.new(self.tileSize, self.tileSize, gfx.kColorWhite)
    gfx.pushContext(tileImage)
    gfx.drawRect(0, 0, self.tileSize, self.tileSize)
    -- gfx.drawRect(1, 1, tileSize - 2, tileSize - 2)
    gfx.fillRect(3, 3, 4, 4)
    -- gfx.fillRect(2, 2, 6, 6)
    gfx.popContext()

    tileImage:draw(10, 10)
    tileImage:draw(21, 21)

    for i = 0, 9, 1 do
        for j = 0, 19, 1 do
            local x <const> = self.fieldRect.x + i * (self.tileSize + self.tilePadding)
            local y <const> = self.fieldRect.y + j * (self.tileSize + self.tilePadding)
            tileImage:draw(x, y)
        end
    end
end