BULLET = class("BULLET")

function BULLET:initialize(x,y,xDir,yDir,origin)
    self.xPos = x
    self.yPos = y
    self.width = 10
    self.height = 10
    self.lifeTimer = 3
    self.xDirection = xDir
    self.yDirection = yDir
    self.Origin     = origin
    self.Type       = "BULLET"
    self.Collider = Collider:addRectangle(x,y,self.width,self.height)
    Collider:addToGroup(self.Origin ,self.Collider)
    self.img = love.graphics.newImage('gL2DSPACEWARBullet.png')
end

function BULLET:gDraw()
    love.graphics.draw(self.img,self.xPos+self.width/2, self.yPos+self.height/2,self.angle,1,1,self.width/2,self.height/2)
end

function BULLET:gUpdate(dt)
    self.lifeTimer = self.lifeTimer - dt
    self.Collider:move(self.xDirection ,self.yDirection )
    self.xPos = self.xPos + self.xDirection;
    self.yPos = self.yPos + self.yDirection;
end

function BULLET:Destroy()
    --Collider:setGhost(self.Collider)
    Collider:removeFromGroup(self.Origin ,self.Collider)
    Collider:remove(self.Collider)
    self.xPos = nil
    self.yPos = nil
    self.width = nil
    self.height = nil
    self.bColor = nil
    self.drawnBrick = nil
    self = nil
end