import "CoreLibs/object"

import "tetromino"

local pd <const> = playdate

class("Tetris").extends()

function Tetris:init(rows, columns)
    self.rows = rows
    self.columns = columns

    self.field = buildField(rows, columns)

    self.timers = {}
    self.inputHandler = self:buildInputHandler()

    self.isGameOver = false

    self.tetrominosBag = {}
    self:initTetrominosBag()
    self:createNewTetromino()
end

-- rows - vertical dimension, row, like Y coordinate
-- columns - horizontal dimension, column, like X coordinate
-- returns field[rows][columns] (field[y][x])
function buildField(rows, columns)
    local field = {}

    for i = 1, rows do
        field[i] = {}
        for j = 1, columns do
            field[i][j] = 0
        end
    end

    field[5][5] = 1

    return field
end

function Tetris:buildInputHandler()
    local function buildTimer(fn)
        return pd.timer.keyRepeatTimerWithDelay(200, 100, fn)
    end

    return {
        upButtonDown = function()
            self.timers["upButtonTimer"] = buildTimer(function()
                self:moveTetrominoUp()
            end)
        end,
        upButtonUp = function()
            self.timers["upButtonTimer"]:remove()
        end,

        leftButtonDown = function()
            self.timers["leftButtonTimer"] = buildTimer(function()
                self:moveTetrominoLeft()
            end)
        end,
        leftButtonUp = function()
            self.timers["leftButtonTimer"]:remove()
        end,

        downButtonDown = function()
            self.timers["downButtonTimer"] = buildTimer(function()
                self:moveTetrominoDown()
            end)
        end,
        downButtonUp = function()
            self.timers["downButtonTimer"]:remove()
        end,

        rightButtonDown = function()
            self.timers["rightButtonTimer"] = buildTimer(function()
                self:moveTetrominoRight()
            end)
        end,
        rightButtonUp = function()
            self.timers["rightButtonTimer"]:remove()
        end,

        AButtonDown = function()
            self:rotateTetromino("right")
        end,

        BButtonDown = function()
            self:rotateTetromino("left")
        end
    }
end

function Tetris:GetInputHandler()
    return self.inputHandler
end

function Tetris:initTetrominosBag()
    local amount = 4
    self.tetrominosBag = {}
    for _, s in ipairs(GetShapes()) do
        for _ = 1, amount do
            table.insert(self.tetrominosBag, s)
        end
    end
end

function Tetris:getNextShape()
    if #self.tetrominosBag == 0 then
        self:initTetrominosBag()
    end
    return table.remove(self.tetrominosBag, math.random(#self.tetrominosBag))
end

function Tetris:createNewTetromino()
    local initialX <const> = self.columns / 2 - 1
    self.currentTetromino = Tetromino(initialX, 1, self:getNextShape())
    if self:isTetrominoPositionInvalid() then
        self:placeLastTetromino()
        self:gameOver()
    else
        self:placeTetrominoOnField()
    end
end

function Tetris:placeLastTetromino()
    local t = self.currentTetromino
    self.currentTetromino = nil

    local isTetrominoCollides = function ()
        local isCollides = false
        t:ForEachBrick(function (x, y)
            if self:isPointInsideField(x, y) and self:isPointTaken(x, y) then
                isCollides = true
            end
        end)
        return isCollides
    end

    while isTetrominoCollides() do
        t.y -= 1
    end

    t:ForEachBrick(function (x, y)
        if self:isPointInsideField(x, y) then
            self.field[y][x] += 1
        end
    end)
end

function Tetris:gameOver()
    self.isGameOver = true
    self:removeTimers()
    print("game over")
end

function Tetris:removeTimers()
    for _, t in pairs(self.timers) do
        t:remove()
    end
end

function Tetris:rotateTetromino(direction)
    self:moveTetromino(function ()
        if direction == "right" then
            self.currentTetromino:RotateRight()
            local success = self:tryPlaceTetrominoWithOffset()
            if not success then
                self.currentTetromino:RotateLeft()
            end
        end
        if direction == "left" then
            self.currentTetromino:RotateLeft()
            local success = self:tryPlaceTetrominoWithOffset()
            if not success then
                self.currentTetromino:RotateRight()
            end
        end
    end)
end

function Tetris:tryPlaceTetrominoWithOffset()
    local currentX, currentY = self.currentTetromino.x, self.currentTetromino.y

    local deltas <const> = {
        {x=0, y=0},

        {x=-1, y=0},
        {x=1,  y=0},
        {x=0,  y=-1},
        {x=0,  y=1},

        {x=-1, y=-1},
        {x=1,  y=-1},
        {x=-1, y=1},
        {x=1,  y=1},

        {x=-2, y=0},
        {x=2,  y=0},
        {x=0,  y=-2},
        {x=0,  y=2},
    }

    for _, d in ipairs(deltas) do
        dx, dy = d.x, d.y
        self.currentTetromino.x = currentX + dx
        self.currentTetromino.y = currentY + dy
        if not self:isTetrominoPositionInvalid() then
            return true
        end
    end

    self.currentTetromino.x = currentX
    self.currentTetromino.y = currentY

    return false
end

function Tetris:moveTetromino(fnUpdateAndCheck)
    if self.currentTetromino == nil then
        return
    end

    self:removeTetrominoFromField()
    local isTetrominoFixed = fnUpdateAndCheck()
    self:placeTetrominoOnField()

    if isTetrominoFixed then
        self:createNewTetromino()
    end
end

function Tetris:moveTetrominoUp()
    self:moveTetromino(function ()
        local oldY <const> = self.currentTetromino.y
        self.currentTetromino.y -= 1
        if self:isTetrominoPositionInvalid() then
            self.currentTetromino.y = oldY
        end
    end)
end

function Tetris:moveTetrominoLeft()
    self:moveTetromino(function ()
        local oldX <const> = self.currentTetromino.x
        self.currentTetromino.x -= 1
        if self:isTetrominoPositionInvalid() then
            self.currentTetromino.x = oldX
        end
    end)
end

function Tetris:moveTetrominoDown()
    self:moveTetromino(function ()
        local oldY <const> = self.currentTetromino.y
        self.currentTetromino.y += 1
        if self:isTetrominoPositionInvalid() then
            self.currentTetromino.y = oldY
            return true
        end
    end)
end

function Tetris:moveTetrominoRight()
    self:moveTetromino(function ()
        local oldX <const> = self.currentTetromino.x
        self.currentTetromino.x += 1
        if self:isTetrominoPositionInvalid() then
            self.currentTetromino.x = oldX
        end
    end)
end

function Tetris:isPointInsideField(x, y)
    return 1 <= x and x <= self.columns
           and
           1 <= y and y <= self.rows
end

function Tetris:isPointTaken(x, y)
    return self.field[y][x] > 0
end

function Tetris:isTetrominoPositionInvalid()
    local isInvalid = false
    local isBrickPositionInvalid <const> = function (x, y)
        if not self:isPointInsideField(x,y) or self:isPointTaken(x,y) then
            isInvalid = true
        end
    end

    self.currentTetromino:ForEachBrick(isBrickPositionInvalid)

    return isInvalid
end

function Tetris:placeTetrominoOnField()
    self.currentTetromino:ForEachBrick(function (x, y)
        self.field[y][x] += 1
    end)
end

function Tetris:removeTetrominoFromField()
    self.currentTetromino:ForEachBrick(function (x, y)
        self.field[y][x] -= 1
    end)
end

function Tetris:Update()
    return self.field, self.isGameOver
end
