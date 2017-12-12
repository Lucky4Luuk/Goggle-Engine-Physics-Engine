function LINEvsTRIANGLE(triangle, line)
  --https://gamedev.stackexchange.com/questions/5585/line-triangle-intersection-last-bits
  local nor = triangle.nor
end

function AABBvsAABB(A, B)
  local A_size = {A[2][1]-A[1][1], A[2][2]-A[1][2], A[2][3]-A[1][3]}
  local B_size = {B[2][1]-B[1][1], B[2][2]-B[1][2], B[2][3]-B[1][3]}
  if math.abs(A[1][1] - B[1][1]) < A_size[1] + B_size[2] then
    if math.abs(A[1][2] - B[1][2]) < A_size[2] + B_size[2] then
      if math.abs(A[1][3] - B[1][3]) < A_size[3] + B_size[3] then
        return true
      end
    end
  end
  return false
end

function checkCollisions(meshes)
  for i=1, #meshes do
    for j=1, #meshes do
      if AABBvsAABB(meshes[i]:getAABB(), meshes[j]:getAABB()) then
        --Check collision
      end
    end
  end
end
