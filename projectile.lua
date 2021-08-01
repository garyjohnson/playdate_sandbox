require "global_vars"
require "entity"

Projectile = Entity:extend()

function Projectile:new(world, hitCallback, x, y, angle, direction, power)
  Projectile.super.new(self)

  self.world = world
  self.hitCallback = hitCallback

  self.originX = x
  self.originY = y
  self.x = x
  self.y = y
  self.direction = direction
  self.angle = angle
  self.power = power * 8
  self.radius = 3
  self.time = 0
end

function Projectile:update(dt)
  Projectile.super.update(self, dt)

  self.time = self.time + dt

  self.x = self.originX + (self.power * math.cos(self.angle) * self.time * self.direction)
  self.y = self.originY + (self.power * math.sin(self.angle) * self.time + (GRAVITY_ACCELERATION * self.time * self.time / 2.0))

  if self:collidesWithTerrain(self.world.terrain) then
    self.world.terrain:hit(self.x, self.y, 25)
    self.hitCallback(self)
  end
end

function Projectile:draw()
  Projectile.super.draw(self)

  love.graphics.setColor(WHITE)
  love.graphics.circle("line", self.x, self.y, self.radius)
end

function Projectile:collidesWithTerrain(terrain)
  local groundPoint = terrain:findHighestYPoint(self.x - self.radius, self.radius * 2)
  return self.y >= groundPoint
end
