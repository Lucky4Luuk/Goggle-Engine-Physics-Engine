require "physics"
local mesh = require "mesh"

local meshes = {}

local time = 0
local timestep = 1/60

function love.load()
  local i = #meshes+1
  table.insert(meshes, mesh:new("cube.obj", {0,0,2}, {0,45,0}))
  meshes[i]:load()
  i = i + 1
  table.insert(meshes, mesh:new("plane.obj", {0,1,0}, {0,45,0}))
  meshes[i]:load()
  i = i + 1
end

function FixedUpdate()
  for i=1, #meshes do
    meshes[i]:setRotationY(meshes[i]:getRotationY() + 15 * timestep)
  end
end

function love.update(dt)
  time = time + dt
  while time > timestep do
    FixedUpdate()
    time = time - timestep
  end
end

function love.draw()
  love.graphics.setColor(1,1,1,1)
  for i=1, #meshes do
    meshes[i]:draw(love.graphics.getWidth(), love.graphics.getHeight(), {0,0,-1}, {0,0,0})
  end
end
