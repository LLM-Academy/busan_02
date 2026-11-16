-- Edit-time assembly. Run once from Studio; creates no runtime scripts.
local district = assert(workspace:FindFirstChild("GwangalliExperience"), "GwangalliExperience is missing")
assert(not district:FindFirstChild("ShopsV2"), "ShopsV2 already exists; archive it explicitly before rebuilding")
local shops = Instance.new("Model")
shops.Name = "ShopsV2"
shops:SetAttribute("CafeDeliveryPosition", Vector3.new(-225, 7, 210))
shops:SetAttribute("HotelLobbyPosition", Vector3.new(240, 7, 207))
shops:SetAttribute("HotelRooftopPosition", Vector3.new(240, 68, 220))
local C = {
 cream = Color3.fromRGB(246,233,206), wood = Color3.fromRGB(142,92,60),
 walnut = Color3.fromRGB(76,49,39), mint = Color3.fromRGB(155,203,180),
 coral = Color3.fromRGB(226,119,105), blue = Color3.fromRGB(54,90,154),
 navy = Color3.fromRGB(39,57,77), brass = Color3.fromRGB(185,151,86),
 white = Color3.fromRGB(248,246,232), glass = Color3.fromRGB(180,215,220),
 pink = Color3.fromRGB(239,173,187), gold = Color3.fromRGB(237,194,90),
 dark = Color3.fromRGB(45,48,52), green = Color3.fromRGB(83,126,84),
}
local partCount = 0
local function part(parent, base, name, size, pos, color, material, rot, kind)
 local p = Instance.new(kind or "Part")
 p.Name = name
 p.Size = size
 p.CFrame = base * CFrame.new(pos) * (rot or CFrame.identity)
 p.Anchored = true
 p.Color = color or C.white
 p.Material = material or Enum.Material.SmoothPlastic
 p.TopSurface = Enum.SurfaceType.Smooth
 p.BottomSurface = Enum.SurfaceType.Smooth
 p.Parent = parent
 partCount += 1
 return p
end
local function ball(parent, base, name, size, pos, color)
 local p = part(parent, base, name, Vector3.new(size,size,size), pos, color)
 p.Shape = Enum.PartType.Ball
 return p
end
local function sign(parent, base, name, text, size, pos, color, ink, face)
 local board = part(parent, base, name, size, pos, color)
 local gui = Instance.new("SurfaceGui")
 gui.Name = "ReadableSign"
 gui.Face = face or Enum.NormalId.Front
 gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
 gui.PixelsPerStud = 35
 gui.LightInfluence = 0.2
 gui.Parent = board
 local label = Instance.new("TextLabel")
 label.Size = UDim2.fromScale(1,1)
 label.BackgroundTransparency = 1
 label.Font = Enum.Font.SourceSansSemibold
 label.TextSize = 38
 label.TextWrapped = true
 label.TextScaled = false
 label.TextColor3 = ink or C.white
 label.Text = text
 label.Parent = gui
 return board
end
local function prompt(p, action, kind, object)
 p:SetAttribute("InteractionKind", kind)
 local pp = Instance.new("ProximityPrompt")
 pp.ActionText = action
 pp.ObjectText = object
 pp.MaxActivationDistance = 12
 pp.RequiresLineOfSight = false
 pp.HoldDuration = 0.25
 pp.Parent = p
end
local function glow(p)
 local light = Instance.new("PointLight")
 light.Color = Color3.fromRGB(255,220,166)
 light.Brightness = 0.65
 light.Range = 17
 light.Shadows = false
 light.Parent = p
end
local function glass(parent, base, name, size, pos)
 local p = part(parent,base,name,size,pos,C.glass,Enum.Material.Glass)
 p.Transparency = 0.68
 return p
end
local function plant(parent, base, x, z, y)
 part(parent,base,"Terracotta planter",Vector3.new(3,2,3),Vector3.new(x,y+1,z),C.coral)
 ball(parent,base,"Soft topiary",4,Vector3.new(x,y+3,z),C.green)
end
local function seat(parent,base,x,z,heading,color)
 local f = base * CFrame.new(x,0,z) * CFrame.Angles(0,math.rad(heading),0)
 local s = part(parent,f,"ChairSeat",Vector3.new(3.4,0.7,3.4),Vector3.new(0,5,0),color,nil,nil,"Seat")
 part(parent,f,"Chair back",Vector3.new(3.4,3,0.5),Vector3.new(0,6.5,1.55),color)
 for _, dx in ipairs({-1.2,1.2}) do
  for _, dz in ipairs({-1.2,1.2}) do
   part(parent,f,"Chair leg",Vector3.new(0.35,1.65,0.35),Vector3.new(dx,3.825,dz),C.walnut)
  end
 end
 return s
end
local function tableSet(parent,base,x,z,color)
 part(parent,base,"Cafe table",Vector3.new(5.5,0.6,5.5),Vector3.new(x,6.2,z),C.wood)
 part(parent,base,"Table pedestal",Vector3.new(1,3,1),Vector3.new(x,4.5,z),C.brass)
 part(parent,base,"Table foot",Vector3.new(3,0.25,3),Vector3.new(x,3.15,z),C.brass)
 seat(parent,base,x,z+5,0,color)
 seat(parent,base,x,z-5,180,color)
end
local function cup(parent,base,x,y,z)
 local p = part(parent,base,"Porcelain cup",Vector3.new(0.8,0.9,0.8),Vector3.new(x,y,z),C.cream)
 p.Shape = Enum.PartType.Cylinder
 p.CFrame = base * CFrame.new(x,y,z) * CFrame.Angles(0,0,math.rad(90))
 part(parent,base,"Coffee surface",Vector3.new(0.57,0.05,0.57),Vector3.new(x,y+0.46,z),C.walnut)
end
local function shell(name,x,w,depth,height,wall,floorColor,trim)
 local model = Instance.new("Model")
 model.Name = name
 model.Parent = shops
 local b = CFrame.new(x,0,195)
 model:SetAttribute("FrontDoorPosition",Vector3.new(x,3,195))
 -- Every entrance has a clear 14 by 13 stud opening; no invisible threshold glass.
 part(model,b,"Dry interior floor",Vector3.new(w,1.25,depth),Vector3.new(0,2.375,depth/2),floorColor,Enum.Material.WoodPlanks)
 part(model,b,"Left wall",Vector3.new(1,height,depth),Vector3.new(-w/2,3+height/2,depth/2),wall)
 part(model,b,"Right wall",Vector3.new(1,height,depth),Vector3.new(w/2,3+height/2,depth/2),wall)
 part(model,b,"Back wall",Vector3.new(w, height,1),Vector3.new(0,3+height/2,depth),wall)
 for _, side in ipairs({-1,1}) do
  local span = w/2-7
  glass(model,b,"Display glazing",Vector3.new(span,11,0.35),Vector3.new(side*(7+span/2),9,0.3))
  part(model,b,"Window sill",Vector3.new(span,1,1),Vector3.new(side*(7+span/2),3.5,0),trim)
  part(model,b,"Front corner pier",Vector3.new(2,height,2),Vector3.new(side*(w/2-0.5),3+height/2,0.5),wall)
  part(model,b,"Entry jamb",Vector3.new(0.8,13,1),Vector3.new(side*7.4,9.5,-0.1),trim)
 end
 part(model,b,"Entrance lintel",Vector3.new(15.6,0.8,1),Vector3.new(0,16.4,-0.1),trim)
 part(model,b,"Upper facade",Vector3.new(w,height-13.8,1),Vector3.new(0,16.8+(height-13.8)/2,0.5),wall)
 part(model,b,"Ceiling",Vector3.new(w,0.8,depth),Vector3.new(0,3+height,depth/2),wall)
 local lamp = part(model,b,"Warm ceiling pendant",Vector3.new(4,0.6,4),Vector3.new(0,16.5,depth/2),C.cream)
 glow(lamp)
 return model,b
end

-- A broad, low cafe with two stepped warm roofs and a usable outdoor terrace.
do
 local m,b = shell("01 Tide Cup Cafe",-225,80,52,19,C.cream,C.wood,C.walnut)
 for _, side in ipairs({-1,1}) do
  part(m,b,"Sloped terracotta roof",Vector3.new(42,1.4,57),Vector3.new(side*20,23.25,25),C.coral,Enum.Material.Slate,CFrame.Angles(0,0,math.rad(-side*5)))
 end
 part(m,b,"Warm roof ridge",Vector3.new(2,1.2,57),Vector3.new(0,25,25),C.walnut)
 sign(m,b,"Cafe name","TIDE CUP  /  COFFEE",Vector3.new(48,3.5,0.5),Vector3.new(0,19,-0.6),C.walnut,C.cream)
 for i=-3,3 do
  part(m,b,"Canvas canopy stripe",Vector3.new(9.5,0.35,5),Vector3.new(i*9.5,15.7,-2),i%2==0 and C.cream or C.coral,nil,CFrame.Angles(math.rad(-9),0,0))
 end
 local counter = part(m,b,"OrderCounter",Vector3.new(18,4,4),Vector3.new(0,5,25),C.walnut)
 part(m,b,"Stone counter top",Vector3.new(19,0.5,5),Vector3.new(0,7.25,25),C.cream)
 prompt(counter,"Order coffee","CafeOrder","Tide Cup Cafe")
 sign(m,b,"Coffee menu","CITRUS TEA  8\nSTRAWBERRY LATTE  12",Vector3.new(20,4,0.35),Vector3.new(0,12.4,50.9),C.navy,C.cream)
 part(m,b,"Espresso machine",Vector3.new(5,3.2,2.7),Vector3.new(-5,9.1,26),C.dark,Enum.Material.Metal)
 part(m,b,"Espresso brass panel",Vector3.new(4.4,1.4,0.25),Vector3.new(-5,9,24.55),C.brass,Enum.Material.Metal)
 for _,x in ipairs({-6,-4}) do cup(m,b,x,7.95,22.9) end
 for _,x in ipairs({3,5,7}) do cup(m,b,x,7.95,25) end
 for _,x in ipairs({-25,25}) do
  tableSet(m,b,x,14,C.mint)
  tableSet(m,b,x,37,C.mint)
 end
 -- Side terrace sits at the same dry floor elevation and is directly walkable.
 part(m,b,"Cafe side terrace",Vector3.new(19,1.25,43),Vector3.new(-50,2.375,22),C.wood,Enum.Material.WoodPlanks)
 tableSet(m,b,-50,15,C.cream)
 tableSet(m,b,-50,34,C.cream)
 for _,z in ipairs({3,43}) do plant(m,b,-56,z,3) end
 plant(m,b,33,44,3)
 task.wait()
end

-- Mint cottage souvenir shop with an asymmetric raised gable and display shelves.
do
 local m,b = shell("02 Sea Letter Boutique",-75,64,48,16,C.mint,C.cream,C.cream)
 for _,side in ipairs({-1,1}) do
  part(m,b,"Cream gable roof",Vector3.new(34,1.2,53),Vector3.new(side*15.8,21.1,23),C.cream,Enum.Material.Slate,CFrame.Angles(0,0,math.rad(-side*9)))
 end
 sign(m,b,"Boutique name","SEA LETTER  /  GIFTS",Vector3.new(43,3.5,0.6),Vector3.new(0,16.4,-0.8),C.mint,C.navy)
 local desk = part(m,b,"BuyCounter",Vector3.new(16,4,4),Vector3.new(0,5,25),C.mint)
 part(m,b,"Cream gift counter top",Vector3.new(17,0.5,5),Vector3.new(0,7.25,25),C.cream)
 prompt(desk,"Choose souvenir","Souvenir","Sea Letter Gifts")
 for _,side in ipairs({-1,1}) do
  local sx = side*25
  part(m,b,"Shelf backing",Vector3.new(10,12,0.7),Vector3.new(sx,9,44),C.white)
  for row=1,3 do
   local y = 3.5+row*3
   part(m,b,"Oak shelf",Vector3.new(10,0.4,3),Vector3.new(sx,y,42.7),C.wood)
   for col=-1,1 do
    part(m,b,"Wrapped souvenir",Vector3.new(2,1.8,1.8),Vector3.new(sx+col*3,y+1.1,42.5),col==0 and C.pink or C.gold)
    part(m,b,"Gift ribbon",Vector3.new(0.3,1.9,1.9),Vector3.new(sx+col*3,y+1.1,42.5),C.cream)
   end
  end
 end
 for _,x in ipairs({-21,21}) do
  part(m,b,"Postcard display table",Vector3.new(11,0.6,5),Vector3.new(x,6.8,12),C.wood)
  part(m,b,"Display plinth",Vector3.new(8,3.5,3),Vector3.new(x,4.75,12),C.mint)
  for i=-2,2 do
   local card = part(m,b,"Seaside postcard",Vector3.new(1.7,2.4,0.18),Vector3.new(x+i*2,8.25,12),i%2==0 and C.blue or C.pink,nil,CFrame.Angles(math.rad(-12),0,0))
   part(m,b,"Postcard sun",Vector3.new(0.7,0.6,0.1),Vector3.new(x+i*2,8.7,11.65),C.gold)
  end
 end
 sign(m,b,"Gift guide","POSTCARDS  /  LITTLE KEEPSAKES",Vector3.new(24,3,0.3),Vector3.new(0,11.5,46.9),C.cream,C.navy)
 for _,x in ipairs({-25,25}) do plant(m,b,x,-3,3) end
 task.wait()
end

-- Coral arcade: cylindrical marquee ends, cobalt bands, and tangible claw games.
do
 local m,b = shell("03 Bubble Catch Arcade",75,76,56,21,C.coral,C.blue,C.blue)
 part(m,b,"Cobalt stepped roof",Vector3.new(79,2,59),Vector3.new(0,25,27),C.blue)
 sign(m,b,"Arcade marquee","BUBBLE CATCH  /  CLAW CLUB",Vector3.new(58,4,0.7),Vector3.new(0,20,-1),C.blue,C.cream)
 for _,side in ipairs({-1,1}) do
  local cap = part(m,b,"Rounded marquee end",Vector3.new(4,4,4),Vector3.new(side*30,20,-0.9),C.gold)
  cap.Shape = Enum.PartType.Ball
  for i=1,3 do ball(m,b,"Marquee bulb",0.8,Vector3.new(side*(7+i*8),23,-1.5),C.cream) end
 end
 for _,x in ipairs({-26,-9,9,26}) do
  local machine = Instance.new("Model") machine.Name = "Claw Cabinet" machine.Parent = m
  local cb = b * CFrame.new(x,0,36)
  part(machine,cb,"Cabinet base",Vector3.new(12,4,11),Vector3.new(0,5,0),C.blue)
  part(machine,cb,"Cabinet crown",Vector3.new(12.7,1.4,11.5),Vector3.new(0,16,0),C.gold)
  for _,sx in ipairs({-5.6,5.6}) do
   for _,sz in ipairs({-5,5}) do part(machine,cb,"Cabinet corner",Vector3.new(0.6,8,0.6),Vector3.new(sx,11,sz),C.cream) end
  end
  glass(machine,cb,"Front prize glass",Vector3.new(11,7,0.2),Vector3.new(0,11,-5.1))
  glass(machine,cb,"Back prize glass",Vector3.new(11,7,0.2),Vector3.new(0,11,5.1))
  for _,sx in ipairs({-5.7,5.7}) do glass(machine,cb,"Side prize glass",Vector3.new(0.2,7,10),Vector3.new(sx,11,0)) end
  local console = part(machine,cb,"ClawConsole",Vector3.new(11,1,3),Vector3.new(0,7,-6.2),C.coral)
  prompt(console,"Play claw","ClawPlay","Bubble Catch")
  part(machine,cb,"Joystick stem",Vector3.new(0.35,1.1,0.35),Vector3.new(-2,8,-6.4),C.dark)
  ball(machine,cb,"Joystick ball",0.9,Vector3.new(-2,8.7,-6.4),C.gold)
  ball(machine,cb,"Play button",0.8,Vector3.new(2,7.65,-6.4),C.cream)
  part(machine,cb,"Prize hatch",Vector3.new(5,1.7,0.2),Vector3.new(0,4.5,-5.6),C.dark)
  part(machine,cb,"Claw gantry",Vector3.new(9,0.35,0.4),Vector3.new(0,14.8,0),C.brass)
  local claw = Instance.new("Model") claw.Name = "Claw" claw.Parent = machine
  part(claw,cb,"Claw cable",Vector3.new(0.12,2.2,0.12),Vector3.new(0,13.5,0),C.dark)
  for _,sx in ipairs({-1,1}) do part(claw,cb,"Claw finger",Vector3.new(0.2,1.3,0.2),Vector3.new(sx*0.5,12.1,0),C.brass,nil,CFrame.Angles(0,0,math.rad(sx*25))) end
  for i=1,3 do
   local px = (i-2)*3
   local pz = i%2==0 and 1 or -1.5
   local color = i==1 and C.pink or (i==2 and C.mint or C.gold)
   ball(machine,cb,"Plush body",2.7,Vector3.new(px,8.3,pz),color)
   ball(machine,cb,"Plush head",2,Vector3.new(px,10,pz),color)
   for _,sx in ipairs({-1,1}) do
    ball(machine,cb,"Plush ear",0.75,Vector3.new(px+sx*0.65,11,pz),color)
    ball(machine,cb,"Plush eye",0.19,Vector3.new(px+sx*0.4,10.2,pz-0.95),C.dark)
   end
  end
 end
 sign(m,b,"Arcade rules","PICK A PAL  /  GOOD LUCK!",Vector3.new(26,3.5,0.4),Vector3.new(0,12.8,54.9),C.blue,C.cream)
 task.wait()
end

-- Slim hotel rises above its neighbors; rooftop remains a real walkable lounge.
do
 local m,b = shell("04 Horizon House Hotel",240,100,60,16,C.navy,C.cream,C.brass)
 -- Upper floors use deep navy masonry and calm inset window panels.
 part(m,b,"Upper hotel volume",Vector3.new(82,45,57),Vector3.new(0,41.5,30),C.navy)
 for floor=1,4 do
  local y = 23+(floor-1)*10
  part(m,b,"Brass floor band",Vector3.new(84,0.45,59),Vector3.new(0,y+4.8,30),C.brass,Enum.Material.Metal)
  for col=-3,3 do
   local wx = col*11
   glass(m,b,"Guest room window",Vector3.new(7.5,6.5,0.3),Vector3.new(wx,y,1.3))
   -- Solid quiet blue panes avoid neon interior faces and prevent upper-floor fall-through.
   part(m,b,"Window inset",Vector3.new(7.3,6.2,0.2),Vector3.new(wx,y,1.55),Color3.fromRGB(102,135,152))
   part(m,b,"Window brass sill",Vector3.new(8,0.25,0.6),Vector3.new(wx,y-3.4,1),C.brass)
  end
 end
 for _,x in ipairs({-43,43}) do part(m,b,"Vertical brass fin",Vector3.new(1.5,47,2),Vector3.new(x,40.5,0),C.brass,Enum.Material.Metal) end
 sign(m,b,"Hotel name","HORIZON HOUSE",Vector3.new(46,4,0.6),Vector3.new(0,17,-0.9),C.navy,C.cream)
 part(m,b,"Hotel entry canopy",Vector3.new(31,0.8,7),Vector3.new(0,14.4,-3),C.brass,Enum.Material.Metal)
 local desk = part(m,b,"ReceptionDesk",Vector3.new(22,4,5),Vector3.new(-16,5,28),C.navy)
 part(m,b,"Reception stone top",Vector3.new(23,0.6,6),Vector3.new(-16,7.3,28),C.cream)
 prompt(desk,"Check in","HotelCheckIn","Horizon House")
 sign(m,b,"Reception label","WELCOME  /  RECEPTION",Vector3.new(23,3.4,0.3),Vector3.new(-19,11,58.9),C.navy,C.cream)
 for _,x in ipairs({-37,-29}) do seat(m,b,x,12,0,C.coral) end
 part(m,b,"Lobby coffee table",Vector3.new(11,0.6,4),Vector3.new(-33,5.3,6),C.wood)
 for i=1,3 do
  part(m,b,"Guest luggage",Vector3.new(2.5,3.5,1.5),Vector3.new(-37+i*3,4.75,48),i%2==0 and C.coral or C.blue)
  part(m,b,"Luggage handle",Vector3.new(1.3,0.3,0.3),Vector3.new(-37+i*3,6.7,48),C.brass)
 end
 -- Elevator is a roomy open alcove with an explicit travel pad.
 for _,x in ipairs({16,32}) do part(m,b,"Elevator brass jamb",Vector3.new(0.7,12,1),Vector3.new(x,9,45),C.brass) end
 part(m,b,"Elevator header",Vector3.new(17,1,1),Vector3.new(24,15,45),C.brass)
 part(m,b,"Elevator back",Vector3.new(16,12,0.7),Vector3.new(24,9,57),C.brass,Enum.Material.Metal)
 local lift = part(m,b,"ElevatorPad",Vector3.new(14,0.12,10),Vector3.new(24,3.07,51),C.brass)
 prompt(lift,"Visit rooftop","HotelRooftop","Scenic Elevator")
 sign(m,b,"Elevator label","ROOFTOP  ↑",Vector3.new(15,3,0.4),Vector3.new(24,11,56.5),C.navy,C.cream)
 -- At Y65 the rooftop is clear, with a safe waist-height perimeter.
 part(m,b,"Rooftop deck",Vector3.new(86,1,59),Vector3.new(0,64.5,30),C.wood,Enum.Material.WoodPlanks)
 for _,x in ipairs({-42,42}) do
  glass(m,b,"Rooftop side railing",Vector3.new(0.4,4,57),Vector3.new(x,67,30))
  part(m,b,"Rooftop handrail",Vector3.new(0.6,0.4,58),Vector3.new(x,69,30),C.brass)
 end
 for _,z in ipairs({1.5,58.5}) do
  glass(m,b,"Rooftop end railing",Vector3.new(84,4,0.4),Vector3.new(0,67,z))
  part(m,b,"Rooftop end handrail",Vector3.new(85,0.4,0.6),Vector3.new(0,69,z),C.brass)
 end
 local rb = b * CFrame.new(0,62,0)
 tableSet(m,rb,-24,16,C.cream)
 tableSet(m,rb,24,16,C.cream)
 tableSet(m,rb,-24,43,C.cream)
 tableSet(m,rb,24,43,C.cream)
 for _,x in ipairs({-37,37}) do plant(m,rb,x,53,3) end
 local down = part(m,b,"RooftopReturnPad",Vector3.new(10,0.14,8),Vector3.new(0,65.08,48),C.brass)
 prompt(down,"Return to lobby","HotelLobby","Scenic Elevator")
 sign(m,b,"Rooftop wayfinding","HORIZON TERRACE  /  LOBBY ↓",Vector3.new(29,3.5,0.4),Vector3.new(0,69,56),C.navy,C.cream)
 task.wait()
end

assert(partCount <= 900, "Shop detail budget exceeded: " .. partCount)
shops:SetAttribute("BasePartCount",partCount)
shops:SetAttribute("FictionalVenues",true)
shops.Parent = district
return {Model = shops, Name = shops:GetFullName(), BaseParts = partCount, Buildings = 4}
