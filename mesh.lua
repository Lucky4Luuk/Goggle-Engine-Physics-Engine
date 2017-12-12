mesh = {}

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function string.split(str,sep)
   local sep, fields = sep or ":", {}
   local pattern = string.format("([^%s]+)", sep)
   string.gsub(str, pattern, function(c) fields[#fields+1] = c end)
   return fields
end

function mesh:new(filename, position, rotation)
  o = {vertices = {}, normals = {}, faces = {}, filename = filename, pos = position, rot = rotation, aabb = {{0,0,0},{0,0,0}}}
  setmetatable(o, self)
  self.__index = self
  return o
end

function mesh:getAABB()
  return self.aabb
end

function mesh:load()
  self.vertices = {}
  self.normals = {}
  self.faces = {}
  for line in io.lines(self.filename) do
    if string.starts(line, "v ") then
      local v = string.split(line:sub(3), " ")
      local pos = {tonumber(v[1]), tonumber(v[2]), tonumber(v[3])}
      table.insert(self.vertices, pos)
    elseif string.starts(line, "f ") then
      local data = line:sub(3)
      local verts = string.split(data, " ")
      local face = {}
      for i=1, #verts do
        local vi = tonumber(string.split(verts[i], "/")[1]) --Vertex Index
        table.insert(face, self.vertices[vi])
      end
      table.insert(self.faces, face)
    elseif string.starts(line, "vn ") then
      local vn = string.split(line:sub(4), " ")
      local nor = {tonumber(vn[1]), tonumber(vn[2]), tonumber(vn[3])}
      table.insert(self.normals, nor)
    end
  end
end

function applyRotationX(pos, ir)
  local r = ir / 180 * math.pi
  local y = pos[2]
  local z = pos[3]
  pos[2] = math.cos(r) * y - math.sin(r) * z
  pos[3] = math.cos(r) * z + math.sin(r) * y
end

function applyRotationY(pos, ir)
  local r = ir / 180 * math.pi
  local x = pos[1]
  local z = pos[3]
  pos[1] = math.cos(r) * x - math.sin(r) * z
  pos[3] = math.cos(r) * z + math.sin(r) * x
end

function applyRotationZ(pos, ir)
  local r = ir / 180 * math.pi
  local x = pos[1]
  local y = pos[2]
  pos[1] = math.cos(r) * x - math.sin(r) * y
  pos[2] = math.cos(r) * y + math.sin(r) * x
end

function mesh:getRotationY()
  return self.rot[2]
end

function mesh:setRotationY(r)
  self.rot[2] = r % 360
end

function mesh:draw(width, height, cam_pos, cam_rot)
  for i=1, #self.faces do
    local face = self.faces[i]
    local points = {}
    for j=1, #face do
      local opos = face[j] --Original Position
      local pos = {opos[1],opos[2],opos[3]}
      --Apply model rotations
      --applyRotationZ(opos, self.rot[3])
      applyRotationY(pos, self.rot[2])
      --applyRotationX(opos, self.rot[1])
      --Transform model to world space
      pos[1] = pos[1] + self.pos[1]
      pos[2] = pos[2] + self.pos[2]
      pos[3] = pos[3] + self.pos[3]
      --Transform model to camera space
      pos[1] = pos[1] - cam_pos[1]
      pos[2] = pos[2] - cam_pos[2]
      pos[3] = pos[3] - cam_pos[3]
      --Apply camera rotations

      --Calculate screen position
      if pos[3] > 0 then
        -- print(pos[1]*50)
        local spos = {(pos[1]*50)/(pos[3]/5), (pos[2]*50)/(pos[3]/5)}
        spos[1] = spos[1] + width/2
        spos[2] = spos[2] + height/2
        table.insert(points, spos[1])
        table.insert(points, spos[2])
      end
    end
    if #points > 3 then
      love.graphics.line(points)
    end
  end
end

return mesh
