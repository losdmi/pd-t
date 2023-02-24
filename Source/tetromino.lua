import "CoreLibs/object"

class("Tetromino").extends()

function Tetromino:init(x, y)
    self.x = x
    self.y = y
end