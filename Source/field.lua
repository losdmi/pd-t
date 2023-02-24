import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

class("Field").extends(gfx.sprite)

function Field:init()
    Field.super.init(self)

    self:buildRects()
    self:buildBorderImage()
    self:setCenter(0, 0)
    self:moveTo(self.borderRect.x, self.borderRect.y)

    self.imageOn = self:buildImageOn()
    self.imageOff = self:buildImageOff()

    self.field = self:buildField()
end

function Field:buildRects()
    local midX <const> = 228
    local screenHeight <const> = 240

    self.rows = 20
    self.columns = 10
    self.tileSize = 10
    self.tilePadding = 1
    self.borderThickness = 2
    local borderPadding <const> = 2
    local borderBottomOffset <const> = 3

    local fieldWidth <const> = self.tileSize * self.columns + self.tilePadding * (self.columns - 1)
    local fieldHeight <const> = self.tileSize * self.rows + self.tilePadding * (self.rows - 1)
    local borderWidth <const> = fieldWidth + 2 * (self.borderThickness + borderPadding)
    local borderHeight <const> = fieldHeight + 2 * (self.borderThickness + borderPadding)

    local borderX <const> = midX - (borderWidth - 1) / 2
    local borderY <const> = screenHeight - (borderHeight + borderBottomOffset)
    local fieldX <const> = borderX + self.borderThickness + borderPadding
    local fieldY <const> = borderY + self.borderThickness + borderPadding

    self.borderRect = geo.rect.new(borderX, borderY, borderWidth, borderHeight)
    self.fieldRect = geo.rect.new(fieldX, fieldY, fieldWidth, fieldHeight)
end

function Field:buildBorderImage()
    local borderImage <const> = gfx.image.new(self.borderRect.width, self.borderRect.height)

    gfx.lockFocus(borderImage)

    local oldLineWidth <const> = gfx.getLineWidth()
    local oldStrokeLocation <const> = gfx.getStrokeLocation()

    gfx.setLineWidth(self.borderThickness)
    gfx.setStrokeLocation(gfx.kStrokeInside)
    gfx.drawRect(0, 0, self.borderRect.width, self.borderRect.height)

    gfx.setStrokeLocation(oldStrokeLocation)
    gfx.setLineWidth(oldLineWidth)

    gfx.unlockFocus()

    self:setImage(borderImage)
end

function Field:buildImageOn()
    local tileImage <const> = gfx.image.new(self.tileSize, self.tileSize, gfx.kColorWhite)
    gfx.pushContext(tileImage)
    gfx.drawRect(0, 0, self.tileSize, self.tileSize)
    gfx.fillRect(3, 3, 4, 4)
    gfx.popContext()
    return tileImage
end

function Field:buildImageOff()
    local tileImage <const> = gfx.image.new(self.tileSize, self.tileSize, gfx.kColorWhite)
    return tileImage
end

function Field:buildField()
    local field = {}

    for i = 1, self.rows do
        field[i] = {}
        for j = 1, self.columns do
            local sprite <const> = gfx.sprite.new()
            local x <const> = self.fieldRect.x + (j - 1) * (self.tileSize + self.tilePadding)
            local y <const> = self.fieldRect.y + (i - 1) * (self.tileSize + self.tilePadding)
            sprite:setCenter(0, 0)
            sprite:moveTo(x, y)
            sprite:add()
            field[i][j] = sprite
        end
    end

    return field
end

function Field:GetDimensions()
    return self.rows, self.columns
end

function Field:DrawAt(x, y, isActive)
    local image
    if (isActive) then
        image = self.imageOn
    else
        image = self.imageOff
    end

    self.field[y][x]:setImage(image)
end

function Field:Update()

end
