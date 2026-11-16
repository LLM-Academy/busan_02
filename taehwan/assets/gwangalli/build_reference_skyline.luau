-- Edit-time background assembly from the reference's varied city-and-hill silhouette.
-- Fictional architecture only: no copied textures, brands, active interiors or prompts.
local district = assert(workspace:FindFirstChild("GwangalliExperience"), "GwangalliExperience is missing")
assert(not district:FindFirstChild("ReferenceSkyline"), "ReferenceSkyline exists; archive explicitly before rebuilding")
local skyline = Instance.new("Model")
skyline.Name = "ReferenceSkyline"
skyline:SetAttribute("ReferenceOnly", true)
local total = 0
local colors = {
 Color3.fromRGB(224,221,207), Color3.fromRGB(182,195,202),
 Color3.fromRGB(236,229,212), Color3.fromRGB(165,177,183),
 Color3.fromRGB(188,151,133), Color3.fromRGB(205,213,211),
}
local blue = Color3.fromRGB(79,116,137)
local teal = Color3.fromRGB(75,120,131)
local pale = Color3.fromRGB(214,221,217)
local trim = Color3.fromRGB(137,148,149)
local function block(parent, frame, name, size, pos, color, material, rotation)
 local p = Instance.new("Part")
 p.Name = name
 p.Size = size
 p.CFrame = frame * CFrame.new(pos) * (rotation or CFrame.identity)
 p.Color = color
 p.Material = material or Enum.Material.SmoothPlastic
 p.Anchored = true
 p.TopSurface = Enum.SurfaceType.Smooth
 p.BottomSurface = Enum.SurfaceType.Smooth
 p.Parent = parent
 total += 1
 return p
end
local ground = Instance.new("Model")
ground.Name = "Dry city ground and end gardens"
ground.Parent = skyline
for _,x in ipairs({-420,0,420}) do
 block(ground,CFrame.identity,"City ground",Vector3.new(420,4,270),Vector3.new(x,0,415),Color3.fromRGB(146,151,142),Enum.Material.Concrete)
end
-- A quiet rear lane and broad verge visually connect the individual structures.
block(ground,CFrame.identity,"Rear city lane",Vector3.new(1240,0.12,24),Vector3.new(0,2.06,397),Color3.fromRGB(86,94,96),Enum.Material.Asphalt)
block(ground,CFrame.identity,"Rear planted verge",Vector3.new(1240,0.16,18),Vector3.new(0,2.08,535),Color3.fromRGB(99,120,91),Enum.Material.Grass)

-- x, front-row center z, width, depth, height, silhouette, palette index.
local front = {
 {-576,340,52,52,33,"penthouse",1}, {-504,352,58,58,57,"banded",2},
 {-432,337,47,44,26,"stepped",5}, {-360,357,56,62,69,"curve",3},
 {-288,344,45,50,42,"balcony",6}, {-216,365,54,58,72,"stepped",2},
 {-144,336,40,44,29,"flat",1}, {-72,352,58,60,52,"penthouse",4},
 {0,340,50,50,36,"balcony",3}, {72,362,55,64,81,"curve",2},
 {144,346,44,46,45,"stepped",5}, {216,360,56,60,62,"banded",6},
 {288,338,42,44,27,"penthouse",1}, {360,355,58,62,76,"balcony",4},
 {432,341,49,48,39,"stepped",3}, {504,360,55,60,66,"curve",2},
 {576,344,50,50,31,"flat",5},
}
local rear = {
 {-546,457,34,44,64,"stepped",4}, {-339,476,42,48,79,"penthouse",3},
 {-126,445,36,42,58,"banded",6}, {90,469,40,46,82,"stepped",1},
 {303,450,38,44,71,"curve",2}, {528,478,44,50,78,"penthouse",6},
}
local function building(spec,index,isRear)
 local x,z,w,d,h,style,ci = table.unpack(spec)
 local model = Instance.new("Model")
 model.Name = string.format("%02d %s %s",index,isRear and "Rear" or "Front",style)
 model:SetAttribute("BackgroundOnly",true)
 local frame = CFrame.new(x,2,z)
 local wall = colors[ci]
 local panes = index%3 == 0 and teal or blue
 -- Secondary upper volumes make real roof-height variation rather than tall cloned boxes.
 local bodyHeight = style=="stepped" and h*0.72 or h
 block(model,frame,"Main city volume",Vector3.new(w,bodyHeight,d),Vector3.new(0,bodyHeight/2,0),wall,Enum.Material.Concrete)
 if style=="stepped" then
  block(model,frame,"Stepped upper storeys",Vector3.new(w*0.69,h-bodyHeight,d*0.78),Vector3.new(w*0.12,(h+bodyHeight)/2,d*0.08),wall,Enum.Material.Concrete)
 elseif style=="penthouse" then
  block(model,frame,"Setback penthouse",Vector3.new(w*0.52,5,d*0.55),Vector3.new(-w*0.13,h+2.5,d*0.1),colors[ci%6+1])
 elseif style=="curve" then
  local round = block(model,frame,"Rounded glazed corner",Vector3.new(h-3,12,12),Vector3.new(w/2-4,(h-3)/2+1.5,-d/2+4),panes,Enum.Material.Glass,CFrame.Angles(0,0,math.rad(90)))
  round.Shape = Enum.PartType.Cylinder
  round.Reflectance = 0.08
 end
 -- Calm opaque glazing bands read clearly at distance with no luminous materials/lights.
 local floors = math.max(2,math.floor(bodyHeight/9))
 for f=1,floors do
  local y = 4+(f-1)*8.7
  local bandWidth = style=="curve" and w-14 or w-6
  local offset = style=="curve" and -3 or 0
  local band = block(model,frame,"Quiet blue window band",Vector3.new(bandWidth,4.4,0.35),Vector3.new(offset,y,-d/2-0.2),panes,Enum.Material.Glass)
  band.Reflectance = 0.055
  if style=="balcony" and f%2==0 then
   block(model,frame,"Balcony slab",Vector3.new(w-4,0.55,3.5),Vector3.new(0,y-2.6,-d/2-1.5),pale)
   block(model,frame,"Balcony opaque rail",Vector3.new(w-4,1.3,0.3),Vector3.new(0,y-1.7,-d/2-3.1),pale)
  elseif style=="banded" then
   block(model,frame,"Fine pale floor stripe",Vector3.new(w,0.35,0.6),Vector3.new(0,y-2.7,-d/2-0.3),pale)
  end
 end
 -- Two vertical mullions break up each band without modelling hundreds of small windows.
 for _,sx in ipairs({-1,1}) do
  block(model,frame,"Facade mullion",Vector3.new(0.65,bodyHeight-3,0.65),Vector3.new(sx*w*0.19,bodyHeight/2,-d/2-0.4),wall)
 end
 block(model,frame,"Roof parapet crown",Vector3.new(w+0.8,0.9,d+0.8),Vector3.new(0,bodyHeight+0.45,0),pale)
 if style=="stepped" then
  block(model,frame,"Upper roof crown",Vector3.new(w*0.7,0.7,d*0.79),Vector3.new(w*0.12,h+0.35,d*0.08),pale)
 end
 block(model,frame,"Rooftop equipment",Vector3.new(w*0.18,2.8,d*0.18),Vector3.new(w*0.2,h+1.4,d*0.23),trim,Enum.Material.Metal)
 if not isRear then
  block(model,frame,"Ground-level plinth",Vector3.new(w+1,1.7,d+1),Vector3.new(0,0.85,0),colors[ci%6+1])
  -- Side-facing glazing gives the gaps between buildings depth.
  block(model,frame,"Side window strip",Vector3.new(0.3,bodyHeight*0.61,d*0.43),Vector3.new(w/2+0.18,bodyHeight*0.53,-d*0.06),panes)
 end
 model.Parent = skyline
 task.wait()
end
for i,spec in ipairs(front) do building(spec,i,false) end
for i,spec in ipairs(rear) do building(spec,#front+i,true) end

-- Bounded landscaping at the two ends, away from playable shop entrances.
for _,side in ipairs({-1,1}) do
 block(ground,CFrame.identity,"End garden bed",Vector3.new(12,0.5,112),Vector3.new(side*615,2.25,465),Color3.fromRGB(91,110,80),Enum.Material.Grass)
 for i=1,5 do
  local f = CFrame.new(side*615,2,413+i*18)
  block(ground,f,"Small tree trunk",Vector3.new(1.2,6,1.2),Vector3.new(0,3,0),Color3.fromRGB(94,76,59),Enum.Material.Wood)
  local leaves = block(ground,f,"City tree crown",Vector3.new(7,8,7),Vector3.new(0,8,0),Color3.fromRGB(76,103,77),Enum.Material.Grass)
  leaves.Shape = Enum.PartType.Ball
 end
end
-- Overlapping terrain creates a continuous low ridge, rather than distinct domes.
workspace.Terrain:SetMaterialColor(Enum.Material.Grass,Color3.fromRGB(49,77,63))
for i=0,8 do
 local x=-640+i*160
 local radius=180+12*math.sin(i*1.7)
 workspace.Terrain:FillBall(Vector3.new(x,-115+8*math.cos(i),710+15*math.sin(i)),radius,Enum.Material.Grass)
 task.wait()
end
assert(total <= 500,"Background part budget exceeded: "..total)
skyline:SetAttribute("PartCount",total)
skyline:SetAttribute("BasePartCount",total)
skyline:SetAttribute("BuildingCount",#front+#rear)
skyline.Parent = district
return {Model=skyline,Name=skyline:GetFullName(),BaseParts=total,Buildings=#front+#rear,ReferenceOnly=true}
