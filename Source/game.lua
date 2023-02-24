import "CoreLibs/object"

import "field"
import "tetris"

local pd <const> = playdate

class("Game").extends()

function Game:init()
    self.field = Field()
    local rows <const>, columns <const> = self.field:GetDimensions()
    self.logic = Tetris(rows, columns)
end

function Game:Initialize()
    self.field:add()
    pd.inputHandlers.push(self.logic:GetInputHandler())
end

function Game:Update()
    local drawAt <const> = function (x, y, isActive)
        return self.field:DrawAt(x, y, isActive)
    end
    self.logic:Update(drawAt)
    self.field:Update()
end