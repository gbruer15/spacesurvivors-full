local playerfunctions = {}
require('Game/missile')
function playerfunctions.make()
	local self = {}
	setmetatable(self, {__index = playerfunctions})

	require("1stPartyLib/display/rectangle")
	self.drawBox = rectangle.make(90,125)

	self.collisionBox = rectangle.make(70,100)

	self.x = window.width/2
	self.y = window.height/2

	self.missiles = {}

	return self
end

function playerfunctions:update(dt)
	self.x,self.y = MOUSE.x,MOUSE.y
end

function playerfunctions:draw()
	love.graphics.setColor(255,0,0)
	self.drawBox:draw('fill',self.x,self.y)

	love.graphics.setColor(0,255,0,100)
	self.collisionBox:draw('fill',self.x,self.y)	
end

function playerfunctions:fireMissile()
	table.insert(self.missiles,missile.make(self.x,self.y-self.drawBox.height/2, 500,-math.pi/2))
end

function playerfunctions:keypressed(key)

end

function playerfunctions:mousepressed(x,y,button)

end

return playerfunctions