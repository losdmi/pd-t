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
    local logicField, isGameOver = self.logic:Update()
    self.field:Update(logicField)

    if isGameOver then
        pd.inputHandlers.pop()
        -- self.field:Clear()
    end
end