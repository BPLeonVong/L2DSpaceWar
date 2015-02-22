class = require "middleclass"

GAME = class("GAME")

--to do: art, clean up

function GAME:initialize()
    self.gShip = SHIP:new(100,100)
    Collider:addToGroup("SHIP1",self.gShip.Collider)
    self.gShip2 = SHIP:new(600,400)
    Collider:addToGroup("SHIP2",self.gShip2.Collider)
    
    self.gBulletArray = {}
    self.Life1 = 5
    self.Life2 = 5
end

function GAME:gDraw()

    for a, bullets in ipairs (self.gBulletArray)do
        bullets:gDraw()
    end
    
    self.gShip:gDraw()
    self.gShip2:gDraw()
    love.graphics.print("Ship 1 Lives: "..self.Life1 ,100,10)
    love.graphics.print("Ship 2 Lives: "..self.Life2 ,550,10)
    
end

function GAME:gUpdate(dt)
   
    
    if self.gShip.ShootTimer < 2 then
        self.gShip.ShootTimer = self.gShip.ShootTimer + dt
    else
        self.gShip.CanShoot = true
    end
    
    if self.gShip2.ShootTimer < 2 then
        self.gShip2.ShootTimer = self.gShip2.ShootTimer + dt
    else
        self.gShip2.CanShoot = true
    end
    
    for a, bullets in ipairs (self.gBulletArray)do
        bullets:gUpdate(dt)
    end
    for a, bullets in ipairs (self.gBulletArray)do
        if bullets.lifeTimer <= 0 then
            bullets:Destroy()
            table.remove(self.gBulletArray,a)
        end
    end 
    
    self.gShip:gUpdate()
    self.gShip2:gUpdate()
    
    self:CheckKeyPress()
    self:CheckRotation()
end


function GAME:onCollide(dt,shape_a,shape_b)
    
    if shape_a == self.gShip.Collider or shape_b == self.gShip.Collider then
    
        for a, bullet in ipairs(self.gBulletArray)do
            if bullet.Collider == shape_a or bullet.Collider == shape_b then
                bullet:Destroy()
                table.remove(self.gBulletArray,a)
                self.gShip = SHIP:new(100,100)
                self.Life1 = self.Life1-1
                Collider:addToGroup("SHIP1",self.gShip.Collider)
                if self.Life1 == 0 then
                    GameStart = false;
                end
                return
            end
        end  
    elseif shape_a == self.gShip2.Collider or shape_b == self.gShip2.Collider then
        for a, bullet in ipairs(self.gBulletArray)do
            if bullet.Collider == shape_a or bullet.Collider == shape_b then
                bullet:Destroy()
                table.remove(self.gBulletArray,a)
                self.gShip2 = SHIP:new(600,400)
                self.Life2 = self.Life2-1
                Collider:addToGroup("SHIP2",self.gShip2.Collider)
                if self.Life2 == 0 then
                    GameStart = false;
                end
                return
            end
        end  
    else
        return
    end
end




function GAME:CheckKeyPress()
 if love.keyboard.isDown('up') then
        local x,y = self.gShip2.Collider:center()
        self.gShip2.velocityX = 1* math.cos(self.gShip2.Collider:rotation())
        self.gShip2.velocityY = 1* math.sin(self.gShip2.Collider:rotation())
    end
    if love.keyboard.isDown('down') then
        if self.gShip2.CanShoot then
            local x,y = self.gShip2.Collider:center()
            rotationXPoints = math.cos(self.gShip2.Collider:rotation())
            rotationYPoints = math.sin(self.gShip2.Collider:rotation())
            table.insert(self.gBulletArray,BULLET:new(x,y,3*rotationXPoints,3*rotationYPoints,"SHIP2"))
            self.gShip2.CanShoot = false
            self.gShip2.ShootTimer = 0
        end
    end
 if love.keyboard.isDown('right') then
        self.gShip2.Collider:rotate(math.pi/100)
        self.gShip2.angle = self.gShip2.angle+math.pi/100
    end
    if love.keyboard.isDown('left') then
        self.gShip2.Collider:rotate(-math.pi/100)
        self.gShip2.angle = self.gShip2.angle-math.pi/100
    end 
   
    if love.keyboard.isDown('w') then
        local x,y = self.gShip.Collider:center()
        self.gShip.velocityX = 1* math.cos(self.gShip.Collider:rotation())
        self.gShip.velocityY = 1* math.sin(self.gShip.Collider:rotation())
    end
   
    if love.keyboard.isDown('s') then
        if self.gShip.CanShoot then
            local x,y = self.gShip.Collider:center()
            rotationXPoints = math.cos(self.gShip.Collider:rotation())
            rotationYPoints = math.sin(self.gShip.Collider:rotation())
            table.insert(self.gBulletArray,BULLET:new(x,y,3*rotationXPoints,3*rotationYPoints,"SHIP1"))
            self.gShip.CanShoot = false
            self.gShip.ShootTimer = 0
        end
    end
    if love.keyboard.isDown('a') then
        self.gShip.Collider:rotate(-math.pi/100)
        self.gShip.angle = self.gShip.angle-math.pi/100
    end
    if love.keyboard.isDown('d') then
        self.gShip.Collider:rotate(math.pi/100)
        self.gShip.angle = self.gShip.angle+math.pi/100
    end
    
end

function GAME:CheckRotation()
    if math.deg(self.gShip.Collider:rotation()) > 360 or math.deg(self.gShip.Collider:rotation()) < -360 then
        self.gShip.Collider:setRotation(0)
    end
 
    if math.deg(self.gShip2.Collider:rotation()) > 360 or math.deg(self.gShip2.Collider:rotation()) < -360 then
        self.gShip2.Collider:setRotation(0)
    end
end