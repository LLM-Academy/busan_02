-- Edit-time scene assembly. All dimensions are proposed game dimensions.
assert(not workspace:FindFirstChild('GwangalliExperience'),'Scene already exists; inspect before rebuilding')
local world=Instance.new('Folder');world.Name='GwangalliExperience';world.Parent=workspace
world:SetAttribute('PromenadeZ',120)
world:SetAttribute('Prototype',true)
local function folder(name,parent)local f=Instance.new('Folder');f.Name=name;f.Parent=parent or world;return f end
local land=folder('CoastalWalk');local city=folder('CafeStreet');local props=folder('StreetFurniture');local spots=folder('TourSpots');local accents=folder('BridgeLighting')
local function part(name,size,cf,color,material,parent)
 local p=Instance.new('Part');p.Name=name;p.Size=size;p.CFrame=cf;p.Color=color;p.Material=material or Enum.Material.SmoothPlastic;p.Anchored=true;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=parent;return p
end
local function sign(p,label,color)
 local g=Instance.new('SurfaceGui');g.Name='Signage';g.Face=Enum.NormalId.Front;g.PixelsPerStud=24;g.LightInfluence=0.15;g.Parent=p
 local t=Instance.new('TextLabel');t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Text=label;t.Font=Enum.Font.GothamMedium;t.TextScaled=true;t.TextColor3=color or Color3.fromRGB(245,237,216);t.Parent=g
 local pad=Instance.new('UIPadding');pad.PaddingLeft=UDim.new(0.06,0);pad.PaddingRight=UDim.new(0.06,0);pad.PaddingTop=UDim.new(0.12,0);pad.PaddingBottom=UDim.new(0.12,0);pad.Parent=t
end
local function shore(x)return 120-110*(x/600)^2 end
local function ribbon(name,x,width,offset,height,top,color,mat,parent)
 local x2=math.min(600,x+40);local a=Vector3.new(x,0,shore(x));local b=Vector3.new(x2,0,shore(x2));local right=(b-a).Unit
 local center=(a+b)/2+Vector3.new(0,top-height/2,offset)
 return part(name,Vector3.new((b-a).Magnitude+1,height,width),CFrame.fromMatrix(center,right,Vector3.yAxis,right:Cross(Vector3.yAxis)),color,mat,parent)
end
for x=-600,560,40 do
 ribbon('Inland',x,185,82,8,2,Color3.fromRGB(120,123,119),Enum.Material.Concrete,land)
 ribbon('Sand',x,103,-63,5,2,Color3.fromRGB(213,192,151),Enum.Material.Sand,land)
 ribbon('Promenade',x,22,0,4,3,Color3.fromRGB(162,159,150),Enum.Material.Pavement,land)
 ribbon('Road',x,31,33,4,3.05,Color3.fromRGB(38,45,54),Enum.Material.Asphalt,land)
 ribbon('ShopSidewalk',x,17,57,4,3,Color3.fromRGB(167,164,153),Enum.Material.Pavement,land)
 if x%80==0 then ribbon('LaneDash',x,0.4,33,0.04,3.09,Color3.fromRGB(229,218,177),Enum.Material.SmoothPlastic,land) end
 task.wait()
end
local rng=Random.new(2711)
local colors={Color3.fromRGB(182,174,162),Color3.fromRGB(116,131,140),Color3.fromRGB(204,194,172),Color3.fromRGB(140,147,153),Color3.fromRGB(112,110,118)}
local names={'WAVE','바다 카페','COAST','BLUE HOUR','달빛','SLOW COFFEE','SEASIDE','NIGHT WALK'}
for i=1,24 do
 local x=-575+(i-1)*50;local z=shore(x)+88;local width=rng:NextNumber(32,45);local height=rng:NextInteger(4,11)*8;local depth=rng:NextNumber(28,44)
 local building=Instance.new('Model');building.Name='CafeBlock_'..i
 part('Facade',Vector3.new(width,height,depth),CFrame.new(x,2+height/2,z),colors[i%#colors+1],Enum.Material.Concrete,building)
 part('RoofCap',Vector3.new(width+1.5,1,depth+1.5),CFrame.new(x,height+2.5,z),Color3.fromRGB(60,68,77),Enum.Material.Metal,building)
 local front=z-depth/2-0.12
 part('ShopGlass',Vector3.new(width-4,6,0.22),CFrame.new(x,6,front-0.1),Color3.fromRGB(94,145,158),Enum.Material.Glass,building).Transparency=0.25
 local shop=part('ShopSign',Vector3.new(width-2,3.5,0.3),CFrame.new(x,11.5,front-0.5),i%2==0 and Color3.fromRGB(35,75,80) or Color3.fromRGB(48,45,58),Enum.Material.SmoothPlastic,building)
 sign(shop,names[i%#names+1])
 for floor=2,math.floor(height/8) do
  for col=-1,1 do
   local warm=rng:NextNumber()>0.28
   part('Window',Vector3.new(width/4-2,4.5,0.18),CFrame.new(x+col*width/3.4,2+floor*8-3,front-0.2),warm and Color3.fromRGB(213,186,137) or Color3.fromRGB(50,74,95),warm and Enum.Material.Neon or Enum.Material.Glass,building)
  end
 end
 building.Parent=city
 task.wait()
end
for i=-6,6 do
 local x=i*88;local z=shore(x)
 part('LampPost',Vector3.new(0.45,17,0.45),CFrame.new(x,11.5,z+7),Color3.fromRGB(47,58,67),Enum.Material.Metal,props)
 local bulb=part('WarmLantern',Vector3.new(2.2,0.65,2.2),CFrame.new(x,20,z+7),Color3.fromRGB(255,214,157),Enum.Material.Neon,props)
 local light=Instance.new('PointLight');light.Color=Color3.fromRGB(255,219,174);light.Range=32;light.Brightness=1.4;light.Shadows=false;light.Parent=bulb
 if i%2==0 then
  local bx=x+12
  part('BenchSeat',Vector3.new(10,0.55,2.8),CFrame.new(bx,5.1,z+7),Color3.fromRGB(123,90,63),Enum.Material.WoodPlanks,props)
  part('BenchBack',Vector3.new(10,2.3,0.45),CFrame.new(bx,6.4,z+8.2),Color3.fromRGB(123,90,63),Enum.Material.WoodPlanks,props)
  for _,dx in {-3.6,3.6}do part('BenchLeg',Vector3.new(0.6,2,2.5),CFrame.new(bx+dx,4,z+7),Color3.fromRGB(48,57,63),Enum.Material.Metal,props)end
 end
end
-- Retain the generated kiosk as an editable source; reuse its visible geometry.
local generated=workspace:FindFirstChild('GwangalliEnvironment')
if generated then
 local source=generated:FindFirstChild('cafe street',true)
 if source then
  local kiosk=source:Clone();kiosk.Name='TouristInformationKiosk';kiosk.Parent=props
  local floor=kiosk:FindFirstChild('KioskFloor',true)
  if floor then local change=floor.CFrame.Rotation:Inverse();kiosk:PivotTo(change*kiosk:GetPivot())end
  kiosk:ScaleTo(kiosk:GetScale()*4)
  local cf,size=kiosk:GetBoundingBox();kiosk:PivotTo(kiosk:GetPivot()+Vector3.new(-72,3+size.Y/2,shore(-72)+65)-cf.Position)
  for _,p in kiosk:GetDescendants()do if p:IsA('BasePart')then p.Anchored=true end end
 end
 local archive=game:GetService('ServerStorage'):FindFirstChild('GwangalliSourceAssets') or folder('GwangalliSourceAssets',game:GetService('ServerStorage'));generated.Parent=archive
end
for i,item in {{-350,'01 · SEASIDE'},{0,'02 · GWANGAN VIEW'},{350,'03 · CAFE WALK'}}do
 local x=item[1];local z=shore(x)
 local pad=part(item[2],Vector3.new(10,0.12,10),CFrame.new(x,3.12,z-3),Color3.fromRGB(105,190,182),Enum.Material.SmoothPlastic,spots)
 local b=Instance.new('BillboardGui');b.Name='LandmarkLabel';b.Size=UDim2.fromOffset(170,52);b.StudsOffsetWorldSpace=Vector3.new(0,8,0);b.MaxDistance=95;b.AlwaysOnTop=false;b.Parent=pad
 local label=Instance.new('TextLabel');label.Size=UDim2.fromScale(1,1);label.Text=item[2]..'\nSTAMP SPOT';label.TextSize=13;label.Font=Enum.Font.GothamMedium;label.TextColor3=Color3.fromRGB(236,238,221);label.BackgroundColor3=Color3.fromRGB(20,43,56);label.BackgroundTransparency=0.2;label.Parent=b
end
local board=part('TourismGuideBoard',Vector3.new(22,10,0.7),CFrame.new(-28,9,shore(-28)+7),Color3.fromRGB(22,48,61),Enum.Material.SmoothPlastic,props)
sign(board,'광안리 관광 안내\nGWANGALLI COASTAL WALK\n\n01 해변  ·  02 다리 전망  ·  03 카페 거리\n\n화면 아래 안내 · 포토 · 투어 버튼',Color3.fromRGB(240,227,197))
for _,dx in {-8,8}do part('BoardLeg',Vector3.new(0.5,6,0.5),CFrame.new(-28+dx,5,shore(-28)+7),Color3.fromRGB(41,54,63),Enum.Material.Metal,props)end
-- A bridge offshore leaves clear separation between beach and skyline.
local bridge=workspace.GwanganBridge_Blockout
local bcf=bridge:GetBoundingBox();bridge:PivotTo(bridge:GetPivot()+Vector3.new(0,70,-350)-bcf.Position)
for _,z in {-364,-336} do
 for i=-11,10 do
  part('DeckGlow',Vector3.new(49,0.3,0.3),CFrame.new(i*50+25,44.6,z),i%3==0 and Color3.fromRGB(187,145,242) or Color3.fromRGB(109,204,240),Enum.Material.Neon,accents)
 end
end
for _,x in {-270,270}do for _,z in {-369,-331}do
 part('TowerGlow',Vector3.new(0.3,112,0.3),CFrame.new(x+4.6,82,z),Color3.fromRGB(170,197,246),Enum.Material.Neon,accents)
end end
local backup=game:GetService('ServerStorage'):FindFirstChild('GwangalliSourceAssets') or folder('GwangalliSourceAssets',game:GetService('ServerStorage'))
local base=workspace:FindFirstChild('Baseplate');if base then base.Parent=backup end
local terrain=workspace.Terrain
terrain:FillBlock(CFrame.new(0,-16,-650),Vector3.new(2200,28,1700),Enum.Material.Water)
terrain.WaterColor=Color3.fromRGB(24,65,82);terrain.WaterReflectance=0.45;terrain.WaterTransparency=0.25;terrain.WaterWaveSize=0.22;terrain.WaterWaveSpeed=8
local spawn=workspace:FindFirstChildWhichIsA('SpawnLocation');spawn.CFrame=CFrame.new(0,3.6,120);spawn.Transparency=1;spawn.Size=Vector3.new(8,1,8);spawn.Duration=0
for _,d in spawn:GetChildren()do if d:IsA('Decal')then d.Transparency=1 end end
local lighting=game:GetService('Lighting');lighting.ClockTime=19.1;lighting.Brightness=2;lighting.Ambient=Color3.fromRGB(68,83,114);lighting.OutdoorAmbient=Color3.fromRGB(91,103,127);lighting.ExposureCompensation=0.1;lighting.GlobalShadows=true
local atmosphere=lighting:FindFirstChildOfClass('Atmosphere') or Instance.new('Atmosphere');atmosphere.Name='GwangalliAtmosphere';atmosphere.Density=0.22;atmosphere.Offset=0.25;atmosphere.Color=Color3.fromRGB(173,190,216);atmosphere.Decay=Color3.fromRGB(75,94,132);atmosphere.Haze=1;atmosphere.Glare=0;atmosphere.Parent=lighting
local bloom=Instance.new('BloomEffect');bloom.Name='GwangalliBloom';bloom.Intensity=0.28;bloom.Size=24;bloom.Threshold=1.15;bloom.Parent=lighting
workspace.CurrentCamera.CFrame=CFrame.lookAt(Vector3.new(0,12,139),Vector3.new(0,75,-350))
game:GetService('ChangeHistoryService'):SetWaypoint('Build Gwangalli coastal prototype')
return {scene=world:GetFullName(),parts=#world:GetDescendants(),spawn=tostring(spawn.Position),bridgeCenter=tostring((bridge:GetBoundingBox()).Position)}
