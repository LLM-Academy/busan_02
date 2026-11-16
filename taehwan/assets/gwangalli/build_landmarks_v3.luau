-- EDIT-TIME ONLY. Four enterable, fictional recreations; no brand assets or runtime scripts.
-- Fronts face the sea (-Z), floor tops are world Y=3. Existing venues are untouched.
-- 2026-11-16 Claude: Codex 좌표(x -950/950/1450)는 바다·허공이라 기존 맵 가게 거리 양 끝(z=195)으로 옮김.
assert(not workspace:FindFirstChild("GwangalliLandmarks"), "GwangalliLandmarks already exists")
local outer = Instance.new("Model")
outer.Name = "GwangalliLandmarks"
outer:SetAttribute("FictionalRecreation", true)
outer:SetAttribute("PhotoStandPosition", Vector3.new(-390, 6, 230))
outer:SetAttribute("PhotoCameraPosition", Vector3.new(-390, 8, 218))
outer:SetAttribute("PhotoLookAtPosition", Vector3.new(-390, 7, 230))
local C = {
 white=Color3.fromRGB(244,244,235), cream=Color3.fromRGB(242,222,185),
 green=Color3.fromRGB(107,161,53), dark=Color3.fromRGB(35,40,43),
 wood=Color3.fromRGB(153,101,61), brick=Color3.fromRGB(150,76,55),
 pink=Color3.fromRGB(232,182,199), mint=Color3.fromRGB(165,214,198),
 blue=Color3.fromRGB(53,117,171), navy=Color3.fromRGB(34,66,99),
 glass=Color3.fromRGB(170,215,222), silver=Color3.fromRGB(169,181,185),
 gold=Color3.fromRGB(225,178,85), water=Color3.fromRGB(61,158,183),
}
local count=0
local function part(m, cf, name, size, pos, color, material, rotation, class)
 local p=Instance.new(class or "Part")
 p.Name=name; p.Size=size; p.CFrame=cf*CFrame.new(pos)*(rotation or CFrame.identity)
 p.Anchored=true; p.Color=color or C.white; p.Material=material or Enum.Material.SmoothPlastic
 p.TopSurface=Enum.SurfaceType.Smooth; p.BottomSurface=Enum.SurfaceType.Smooth
 p.Parent=m; count+=1
 return p
end
local function sign(m,cf,name,text,size,pos,bg,ink,face)
 local p=part(m,cf,name,size,pos,bg)
 local gui=Instance.new("SurfaceGui"); gui.Face=face or Enum.NormalId.Front
 gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud; gui.PixelsPerStud=math.min(35,95/size.Y) -- TextScaled caps at 100px
 gui.LightInfluence=0.35; gui.Parent=p
 local t=Instance.new("TextLabel"); t.Name="StoreTitle"; t.Size=UDim2.fromScale(1,1)
 t.BackgroundTransparency=1; t.TextColor3=ink or C.white
 t.Font=Enum.Font.SourceSansSemibold; t.TextScaled=true
 t.TextWrapped=true; t.Text=text; t.Parent=gui
 local pad=Instance.new("UIPadding"); pad.PaddingTop=UDim.new(0.12,0); pad.PaddingBottom=UDim.new(0.12,0); pad.PaddingLeft=UDim.new(0.04,0); pad.PaddingRight=UDim.new(0.04,0); pad.Parent=t
 return p
end
local function glass(m,cf,name,size,pos)
 local p=part(m,cf,name,size,pos,C.glass,Enum.Material.Glass)
 p.Transparency=0.7; p.CanCollide=false; p.CastShadow=false
 return p
end
local function prompt(p,kind,action,object)
 p:SetAttribute("LandmarkKind",kind)
 local q=Instance.new("ProximityPrompt"); q.Name=kind
 q.ActionText=action; q.ObjectText=object; q.HoldDuration=0.2
 q.MaxActivationDistance=12; q.RequiresLineOfSight=false; q.Parent=p
end
local function model(name,x,z,w,d,h)
 local m=Instance.new("Model"); m.Name=name; m:SetAttribute("FictionalRecreation",true)
 m:SetAttribute("FrontPosition",Vector3.new(x,3,z))
 local cf=CFrame.new(x,3,z)
 part(m,cf,"Floor",Vector3.new(w,1,d),Vector3.new(0,-0.5,d/2),C.cream,Enum.Material.Concrete)
 part(m,cf,"RearWall",Vector3.new(w,h,1),Vector3.new(0,h/2,d),C.white)
 part(m,cf,"WestWall",Vector3.new(1,h,d),Vector3.new(-w/2,h/2,d/2),C.white)
 part(m,cf,"EastWall",Vector3.new(1,h,d),Vector3.new(w/2,h/2,d/2),C.white)
 part(m,cf,"Roof",Vector3.new(w+2,1,d+2),Vector3.new(0,h,d/2),C.dark,Enum.Material.Slate)
 local lamp=part(m,cf,"CeilingLamp",Vector3.new(12,0.3,4),Vector3.new(0,h-1,d/2),C.white)
 local light=Instance.new("PointLight"); light.Color=C.white; light.Brightness=1.1; light.Range=55; light.Shadows=false; light.Parent=lamp
 return m,cf
end
local function shopfront(m,cf,w,h,color,door)
 local span=(w-door)/2
 for _,side in ipairs({-1,1}) do
  local x=side*(door/2+span/2)
  part(m,cf,"FrontSill",Vector3.new(span,1,1),Vector3.new(x,0.5,0),color)
  glass(m,cf,"ShopWindow",Vector3.new(span-1,14,0.4),Vector3.new(x,8,0))
  part(m,cf,"DoorJamb",Vector3.new(0.7,16,1),Vector3.new(side*(door/2+0.35),8,0),color)
 end
 part(m,cf,"FrontFascia",Vector3.new(w,h-16,1),Vector3.new(0,16+(h-16)/2,0),color)
end
local function seat(m,cf,name,x,y,z,color,angle)
 return part(m,cf,name,Vector3.new(4,1,4),Vector3.new(x,y,z),color,nil,CFrame.Angles(0,angle or 0,0),"Seat")
end

-- A bright green pharmacy-style beauty store with genuinely open central doors.
do
 local m,cf=model("OliveYoung",-520,195,100,60,30)
 shopfront(m,cf,100,30,C.green,18)
 m:SetAttribute("StoreKey","oliveyoung")
 sign(m,cf,"StoreNameSign","OLIVEYOUNG  /  올리브영",Vector3.new(87,7,0.6),Vector3.new(0,22,-0.8),C.white,C.green):SetAttribute("StoreKey","oliveyoung")
 part(m,cf,"GreenCanopy",Vector3.new(102,1,7),Vector3.new(0,16,-2.5),C.green)
 for _,x in ipairs({-37,-15,15,37}) do
  local z=(math.abs(x)==37) and 40 or 33
  part(m,cf,"DisplayPlinth",Vector3.new(13,2,18),Vector3.new(x,1,z),C.white)
  for level=1,3 do
   part(m,cf,"ProductShelf",Vector3.new(13,0.5,17),Vector3.new(x,2+level*2.6,z),C.white)
   for j=1,5 do
    for _,offset in ipairs({-5,5}) do
     local col=({C.mint,C.pink,C.green,C.cream,C.white})[j]
     part(m,cf,"BeautyBottle",Vector3.new(1.2,1.8,1.4),Vector3.new(x-5+j*1.65,3.15+level*2.6,z+offset),col)
    end
   end
  end
 end
 sign(m,cf,"SkincareCategory","SKIN CARE",Vector3.new(23,4.5,0.4),Vector3.new(-30,14,58.9),C.white,C.green)
 sign(m,cf,"MakeupCategory","MAKE UP",Vector3.new(23,4.5,0.4),Vector3.new(30,14,58.9),C.white,C.green)
 local counter=part(m,cf,"BeautySampleCheckout",Vector3.new(20,4,7),Vector3.new(32,2,12),C.green)
 prompt(counter,"BeautySample","뷰티 샘플 받기","올리브영")
 part(m,cf,"Register",Vector3.new(3,2.5,2),Vector3.new(35,5.2,12),C.dark,nil,CFrame.Angles(-0.2,0,0))
 for j=1,4 do part(m,cf,"Tester",Vector3.new(1,1,1),Vector3.new(24+j*2,4.5,10),C.pink) end
 sign(m,cf,"CheckoutLabel","CHECKOUT · 샘플",Vector3.new(18,4.5,0.3),Vector3.new(32,8,10),C.white,C.dark)
 m.Parent=outer; task.wait()
end

-- Brick, timber rafters, striped awning, and open-kitchen fish cake shop.
do
 local m,cf=model("SamjinFishCake",360,195,90,60,28)
 for _,n in ipairs({"RearWall","WestWall","EastWall"}) do m[n].Material=Enum.Material.Brick; m[n].Color=C.brick end
 shopfront(m,cf,90,28,C.wood,18)
 m:SetAttribute("StoreKey","samjin")
 sign(m,cf,"StoreNameSign","삼진어묵 / SAMJIN FISH CAKE",Vector3.new(82,7,0.8),Vector3.new(0,22,-0.9),C.cream,C.brick):SetAttribute("StoreKey","samjin")
 for i=0,8 do part(m,cf,"StripedAwning",Vector3.new(10,0.7,9),Vector3.new(-40+i*10,16,-4),i%2==0 and C.cream or C.brick,nil,CFrame.Angles(0.12,0,0)) end
 for _,z in ipairs({12,30,48}) do part(m,cf,"TimberRafter",Vector3.new(88,1.2,1.5),Vector3.new(0,26,z),C.wood,Enum.Material.Wood) end
 local counter=part(m,cf,"FishCakeOrderCounter",Vector3.new(60,4,9),Vector3.new(0,2,38),C.wood,Enum.Material.WoodPlanks)
 prompt(counter,"FishCakeOrder","따끈한 어묵 주문","삼진어묵")
 part(m,cf,"StoneCountertop",Vector3.new(62,0.5,10),Vector3.new(0,4.25,38),C.cream,Enum.Material.Marble)
 for i=1,3 do
  local x=-28+i*14
  part(m,cf,"Steamer",Vector3.new(10,1.4,7),Vector3.new(x,5.2,38),C.silver,Enum.Material.Metal)
  part(m,cf,"Broth",Vector3.new(8.6,0.2,5.6),Vector3.new(x,6,38),C.gold)
  for j=1,5 do
   part(m,cf,"WoodSkewer",Vector3.new(0.2,4,0.2),Vector3.new(x-4+j*1.3,7.7,38),C.wood,nil,CFrame.Angles(0,0,0.14))
   part(m,cf,"FishCake",Vector3.new(0.8,1.5,0.8),Vector3.new(x-4+j*1.3,6.7,38),C.cream)
  end
 end
 part(m,cf,"Griddle",Vector3.new(10,0.5,8),Vector3.new(27,4.8,38),C.dark,Enum.Material.Metal)
 for i=1,4 do part(m,cf,"GrilledFishCake",Vector3.new(1.5,0.5,4),Vector3.new(22+i*1.8,5.3,38),C.gold) end
 sign(m,cf,"Menu","어묵 · 꼬치 · 따뜻한 국물",Vector3.new(58,5,0.4),Vector3.new(0,15,59),C.cream,C.brick)
 for _,x in ipairs({-30,30}) do
  part(m,cf,"DiningTable",Vector3.new(14,0.7,8),Vector3.new(x,4,17),C.wood,Enum.Material.Wood)
  part(m,cf,"TableLeg",Vector3.new(1,4,1),Vector3.new(x,2,17),C.dark)
  seat(m,cf,"DiningSeat",x-4,2.3,23,C.cream); seat(m,cf,"DiningSeat",x+4,2.3,23,C.cream)
 end
 m.Parent=outer; task.wait()
end

-- Monochrome photo house, pastel dressing nook, and a camera-facing open booth.
do
 local m,cf=model("LifeFourCuts",-390,195,55,50,24)
 m:SetAttribute("PhotoStandPosition",Vector3.new(-390,6,230))
 m:SetAttribute("PhotoCameraPosition",Vector3.new(-390,8,218))
 m:SetAttribute("PhotoLookAtPosition",Vector3.new(-390,7,230))
 shopfront(m,cf,55,24,C.dark,16)
 m:SetAttribute("StoreKey","fourcuts")
 sign(m,cf,"StoreNameSign","인생네컷 / PHOTO BOOTH",Vector3.new(51,5.5,0.7),Vector3.new(0,20,-0.9),C.dark,C.white):SetAttribute("StoreKey","fourcuts")
 part(m,cf,"PhotoBackdrop",Vector3.new(24,15,0.8),Vector3.new(0,7.5,41),C.pink)
 part(m,cf,"PhotoStage",Vector3.new(24,0.15,12),Vector3.new(0,0.075,35),C.mint)
 part(m,cf,"BoothBench",Vector3.new(16,2,3),Vector3.new(0,1,38),C.white)
 part(m,cf,"BoothBenchBack",Vector3.new(16,5,0.6),Vector3.new(0,3,39.5),C.dark)
 for _,x in ipairs({-14,14}) do
  part(m,cf,"BoothPillar",Vector3.new(1,16,1),Vector3.new(x,8,35),C.dark)
  part(m,cf,"PastelCurtain",Vector3.new(0.5,13,10),Vector3.new(x,6.5,36),C.mint)
 end
 part(m,cf,"BoothHeader",Vector3.new(29,1,12),Vector3.new(0,16,35),C.dark)
 -- Camera is above/behind the visitor approach; this kiosk stays outside the lens path.
 local kiosk=part(m,cf,"FourCutsKiosk",Vector3.new(5,8,3),Vector3.new(-19,4,20),C.dark)
 prompt(kiosk,"FourCuts","네컷 사진 찍기","인생네컷")
 sign(m,cf,"KioskScreen","촬영 시작",Vector3.new(4.8,4.5,0.3),Vector3.new(-19,6,18.3),C.white,C.dark)
 local mirror=part(m,cf,"DressingMirror",Vector3.new(0.4,10,9),Vector3.new(26.7,8,15),C.silver,Enum.Material.Metal)
 mirror.Reflectance=0.45
 part(m,cf,"DressingShelf",Vector3.new(5,0.6,12),Vector3.new(23,3.5,15),C.pink)
 for i=1,4 do part(m,cf,"PhotoProp",Vector3.new(2,1.2,1),Vector3.new(23,4.4,9+i*2.3),i%2==0 and C.dark or C.mint) end
 for i=1,4 do
  part(m,cf,"PhotoStrip",Vector3.new(0.25,11,3),Vector3.new(-26.7,8,5+i*8),C.white)
  for j=1,4 do part(m,cf,"StripPortrait",Vector3.new(0.15,1.7,2.2),Vector3.new(-26.5,3.1+j*2,5+i*8),j%2==0 and C.mint or C.pink) end
 end
 m.Parent=outer; task.wait()
end

-- Tall blue market hall. Upper floor world Y=25; one-stud-rise east staircase.
do
 local m,cf=model("MillakFishCenter",520,195,150,90,55)
 m.RearWall.Color=C.blue; m.WestWall.Color=C.blue; m.EastWall.Color=C.blue
 m.Roof.Color=C.navy
 -- Three 18-stud-wide entries, no invisible door blockers.
 for _,x in ipairs({-66,-22,22,66}) do
  part(m,cf,"FrontPier",Vector3.new(18,22,2),Vector3.new(x,11,0),C.blue,Enum.Material.Concrete)
 end
 part(m,cf,"MarketLintel",Vector3.new(150,5,2),Vector3.new(0,24.5,0),C.navy)
 for _,x in ipairs({-44,0,44}) do
  sign(m,cf,"EntranceLabel","어서오세요",Vector3.new(22,4.5,0.4),Vector3.new(x,18,-1.2),C.white,C.blue)
  part(m,cf,"EntryCanopy",Vector3.new(27,0.8,7),Vector3.new(x,15,-3),C.blue)
 end
 -- Upper main slab deliberately excludes the stairwell on its east side.
 part(m,cf,"RestaurantFloor",Vector3.new(110,1,90),Vector3.new(-20,21.5,45),C.wood,Enum.Material.WoodPlanks)
 part(m,cf,"StairLanding",Vector3.new(40,1,16),Vector3.new(55,21.5,82),C.wood,Enum.Material.WoodPlanks)
 for i=1,22 do
  part(m,cf,"WalkableStair",Vector3.new(16,i,2),Vector3.new(55,i/2,37+i*2-1),C.silver,Enum.Material.Concrete)
 end
 -- Stair top at local z=81 opens directly onto rear landing (world Y=25).
 for _,x in ipairs({46,64}) do
  part(m,cf,"StairHandrail",Vector3.new(0.4,0.4,49.2),Vector3.new(x,14.5,59),C.navy,Enum.Material.Metal,CFrame.Angles(-math.atan(0.5),0,0))
 end
 for _,x in ipairs({-55,-20,15}) do
  part(m,cf,"UpperSupport",Vector3.new(2,21,2),Vector3.new(x,10.5,65),C.navy)
 end
 for _,x in ipairs({-57,-19,19}) do
  for _,z in ipairs({27,60}) do
   part(m,cf,"FishStallBase",Vector3.new(26,3,16),Vector3.new(x,1.5,z),C.white)
   part(m,cf,"TankWater",Vector3.new(23,2.8,13),Vector3.new(x,4.3,z),C.water).Transparency=0.35
   glass(m,cf,"TankFront",Vector3.new(25,4,0.3),Vector3.new(x,4.5,z-7))
   glass(m,cf,"TankRear",Vector3.new(25,4,0.3),Vector3.new(x,4.5,z+7))
   for _,s in ipairs({-1,1}) do glass(m,cf,"TankSide",Vector3.new(0.3,4,14),Vector3.new(x+s*12.5,4.5,z)) end
   for f=1,3 do
    local fish=part(m,cf,"ToyFish",Vector3.new(3.5,1.3,1.3),Vector3.new(x-10+f*5,4.5,z+(f%2)*4-2),f%2==0 and C.silver or C.gold)
    fish.Shape=Enum.PartType.Ball
    part(m,cf,"ToyFishTail",Vector3.new(0.5,1.9,2.1),Vector3.new(x-11.7+f*5,4.5,z+(f%2)*4-2),C.blue,nil,CFrame.Angles(0.5,0,0))
   end
   sign(m,cf,"StallLabel","활어 · 싱싱한 바다",Vector3.new(25,4.5,0.4),Vector3.new(x,10,z+8),C.white,C.blue)
  end
 end
 local sample=part(m,cf,"SeafoodSampleCounter",Vector3.new(15,4,7),Vector3.new(-55,2,10),C.blue)
 prompt(sample,"SeafoodSample","바다 한입 맛보기","민락회센터")
 -- Sea-view front glass begins well above the main entrances.
 for _,x in ipairs({-57,-20,17,55}) do
  glass(m,cf,"RestaurantSeaWindow",Vector3.new(34,16,0.5),Vector3.new(x,33,0))
  part(m,cf,"WindowMullion",Vector3.new(1,19,1),Vector3.new(x+18,32.5,0),C.white)
 end
 part(m,cf,"UpperFascia",Vector3.new(150,13,1.5),Vector3.new(0,48.5,0),C.navy)
 m:SetAttribute("StoreKey","millak")
 sign(m,cf,"StoreNameSign","민락회센터 / MILLAK SEAFOOD CENTER",Vector3.new(140,8,0.6),Vector3.new(0,49,-1.1),C.navy,C.white):SetAttribute("StoreKey","millak")
 sign(m,cf,"RestaurantSign","2F 바다전망 식당  ·  SEA VIEW",Vector3.new(76,4.5,0.5),Vector3.new(-20,39,-0.9),C.white,C.blue)
 for _,x in ipairs({-55,-22,11}) do
  for _,z in ipairs({16,49}) do
   part(m,cf,"RestaurantTable",Vector3.new(15,0.8,9),Vector3.new(x,26,z),C.cream,Enum.Material.Wood)
   part(m,cf,"RestaurantTableLeg",Vector3.new(2,4,2),Vector3.new(x,24,z),C.navy)
   for _,dx in ipairs({-4,4}) do
    seat(m,cf,"SeaViewSeat",x+dx,24,z+8,C.blue)
    seat(m,cf,"RestaurantSeat",x+dx,24,z-8,C.blue,math.pi)
   end
   part(m,cf,"ServingPlatter",Vector3.new(5,0.25,3),Vector3.new(x,26.6,z),C.white)
  end
 end
 -- Guard the open stairwell without placing a rail across its upper exit.
 part(m,cf,"UpperStairGuard",Vector3.new(0.5,3,72),Vector3.new(35,23.5,37),C.navy)
 sign(m,cf,"StairDirection","2층 식당 →",Vector3.new(20,4.5,0.4),Vector3.new(53,12,88.8),C.white,C.blue)
 m.Parent=outer; task.wait()
end
assert(count<=1000,"Landmark part budget exceeded: "..count)
outer:SetAttribute("BasePartCount",count)
outer.Parent=workspace
print("GwangalliLandmarks assembled:",count,"anchored parts; 4 enterable buildings")
