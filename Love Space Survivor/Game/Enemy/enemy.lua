local enemy = {}
enemy.__index = enemy
require('Game/laser')
function enemy.make(att)
	local self = {}
	setmetatable(self, enemy)

	require("1stPartyLib/display/rectangle")

	self.x = att.x or 0
	self.y = att.y or 0

	self.Image = att.Image or images.enemySpaceship
	self.color = att.color or {255, 255, 255}

	local width = att.width or 50
	local scale = width/self.Image.width
	self.drawBox = rectangle.make(width,scale*self.Image.height, self)
	self.collisionBox = self.Image == images.enemySpaceship and rectangle.make(scale*88,scale*205,self)
	self.collisionBox = self.collisionBox or rectangle.make(width,self.Image.height*scale,self)

	self.drawBox.height = self.drawBox.width/self.Image.width*self.Image.height
	self.drawBox.dy = self.drawBox.height/2

	self.yspeed = att.yspeed or 100
	self.xspeed = att.xspeed or math.random(-10,10)*5
	if self.xspeed*self.xspeed <= 400 then
		self.xspeed = 0
	end

	self.firing = att.firing
	self.fireDelay = att.fireDelay or 1
	self.fireCountdown = att.fireCountdown or self.fireDelay

	self.missileSpeed = att.missileSpeed or  100

	self.health = att.health or 1

	self.loot = att.loot or math.ceil(self.drawBox.width * (math.random() + 0.5))
	self.points = math.ceil(self.loot * 1.4)
	
	self.polygon = {}
	self:updatePolygon()

	return self
end

function enemy:update(dt)
	self.y = self.y + self.yspeed*dt
	self.x = self.x + self.xspeed*dt

	self.fireCountdown = self.fireCountdown - dt
	if self.fireCountdown <= 0 and self.firing then
		self:fireMissile()
		self.fireCountdown = self.fireDelay
	end

	self:updatePolygon()
end

function enemy:draw(drawColBox, colBoxMode)
	love.graphics.setColor(self.color)
	if self.HELP then
		love.graphics.setColor(self.color[1],self.color[2],0)
	end
	love.graphics.draw(self.Image.image,self.drawBox:getLeft(),self.drawBox:getTop(),0,self.drawBox.width/self.Image.width, self.drawBox.height/self.Image.height)

	if drawColBox then
		love.graphics.setColor(color or {0,255,0,255})
		if self.HELP then
			love.graphics.setColor(255,255,0)
		end
		self.collisionBox:draw(colBoxMode or 'line')
		-- local p = self:getPolygon()
		-- love.graphics.polygon('line',p)
	end
end

function enemy:fireMissile()
	table.insert(STATE.enemyMissiles,laser.make{
													x=self.x
													,y=self.drawBox:getBottom()
													,speed=self.missileSpeed
													,angle=math.pi/2
													,width=5 --* self.drawBox.width / 60
												}
											)
	sounds.chirp:play()
end

function enemy:updatePolygon()
	local l,t, w,h = self.collisionBox:getRect()
	self.polygon[1] = l
	self.polygon[2] = t

	self.polygon[3] = l+w
	self.polygon[4] = t

	self.polygon[5] = l+w
	self.polygon[6] = t+h

	self.polygon[7] = l
	self.polygon[8] = t+h
end

return enemy