-- Edit-time revision. Locations are compressed game proposals, not a survey.
local w=workspace.GwangalliExperience
assert(not w:FindFirstChild('AttractionsV2'),'Revision already installed')
local archive=Instance.new('Folder');archive.Name='GwangalliRevision1';archive.Parent=game.ServerStorage
if w:FindFirstChild('CafeStreet')then w.CafeStreet.Parent=archive end
local retired=Instance.new('Folder');retired.Name='OldBenches';retired.Parent=archive
for _,p in w.StreetFurniture:GetChildren()do if p.Name:find('Bench')then p.Parent=retired end end
local a=Instance.new('Folder');a.Name='AttractionsV2';a.Parent=w
local function model(name)local m=Instance.new('Model');m.Name=name;return m end
local function part(name,size,cf,color,mat,parent,class)
 local p=Instance.new(class or 'Part');p.Name=name;p.Size=size;p.CFrame=cf;p.Color=color;p.Material=mat or Enum.Material.SmoothPlastic;p.Anchored=true;p.TopSurface=Enum.SurfaceType.Smooth;p.BottomSurface=Enum.SurfaceType.Smooth;p.Parent=parent;return p
end
local navy=Color3.fromRGB(26,59,73);local cream=Color3.fromRGB(224,215,190);local wood=Color3.fromRGB(153,110,71);local teal=Color3.fromRGB(77,163,161)
local function shore(x)return 120-110*(x/600)^2 end
local function basis(x,y,z)local r=Vector3.new(1,0,-220*x/360000).Unit;return CFrame.fromMatrix(Vector3.new(x,y,z),r,Vector3.yAxis,r:Cross(Vector3.yAxis))end
local function bar(name,p1,p2,width,color,parent,mat)
 local mid=(p1+p2)/2;return part(name,Vector3.new(width,width,(p2-p1).Magnitude),CFrame.lookAt(mid,p2),color,mat,parent)
end
local function disc(name,center,radius,height,color,parent)
 local p=part(name,Vector3.new(height,radius*2,radius*2),CFrame.new(center)*CFrame.Angles(0,0,math.pi/2),color,Enum.Material.WoodPlanks,parent);p.Shape=Enum.PartType.Cylinder;return p
end
local function sign(parent,name,cf,title,sub,width)
 local p=part(name,Vector3.new(width or 17,4,0.35),cf,navy,Enum.Material.SmoothPlastic,parent)
 for _,face in {Enum.NormalId.Front,Enum.NormalId.Back}do
  local g=Instance.new('SurfaceGui');g.Name='ReadableSign';g.Face=face;g.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;g.PixelsPerStud=35;g.LightInfluence=0.25;g.Parent=p
  local l=Instance.new('TextLabel');l.Size=UDim2.new(1,-18,1,-12);l.Position=UDim2.fromOffset(9,6);l.BackgroundTransparency=1;l.Font=Enum.Font.SourceSansSemibold;l.TextSize=34;l.TextColor3=cream;l.TextWrapped=true;l.Text=title..'\n'..sub;l.Parent=g
 end
 return p
end
local function bench(parent,cf,name)
 local m=model(name or 'AlignedBench')
 part('Seat',Vector3.new(9.5,0.55,2.8),cf*CFrame.new(0,2.25,0),wood,Enum.Material.WoodPlanks,m,'Seat')
 part('Back',Vector3.new(9.5,2.6,0.45),cf*CFrame.new(0,3.5,1.2),wood,Enum.Material.WoodPlanks,m)
 for _,x in {-3.6,3.6}do part('Leg',Vector3.new(0.5,2.1,2.5),cf*CFrame.new(x,1.05,0),navy,Enum.Material.Metal,m)end
 m.Parent=parent;return m
end
local seating=model('PromenadeBenches')
for _,x in {-535,-435,-285,-145,145,315,435,535}do bench(seating,basis(x,3,shore(x)+6))end
seating.Parent=a
local kiosk=w.StreetFurniture:FindFirstChild('TouristInformationKiosk')
if kiosk then local cf,s=kiosk:GetBoundingBox();kiosk:PivotTo(kiosk:GetPivot()+Vector3.new(-530,3+s.Y/2,shore(-530)+65)-cf.Position)end
-- Straight walkable aprons connect the four distinct venues to the street.
local aprons=model('ShopApproaches')
for _,v in {{-225,80},{-75,64},{75,76},{240,100}}do local x,width=v[1],v[2];local start=shore(x)+56;part('EntryPlaza',Vector3.new(width+9,1,195-start),CFrame.new(x,2.5,(195+start)/2),cream,Enum.Material.Pavement,aprons)end
aprons.Parent=a
-- A white-ribbed lookout shelter; bridge-facing view is unobstructed.
local pavilion=model('CoastalPavilion');local px=-485;local pz=shore(px)-45
disc('Boardwalk',Vector3.new(px,2.6,pz),22,1.2,wood,pavilion)
for _,x in {-15,15}do for _,z in {-12,12}do part('Column',Vector3.new(0.7,14,0.7),CFrame.new(px+x,10,pz+z),cream,Enum.Material.Metal,pavilion)end end
for x=-15,15,6 do
 for j=0,7 do local t1=j*math.pi/8;local t2=(j+1)*math.pi/8;local v1=Vector3.new(px+x,14+math.sin(t1)*6,pz+math.cos(t1)*15);local v2=Vector3.new(px+x,14+math.sin(t2)*6,pz+math.cos(t2)*15);bar('RoofRib',v1,v2,0.65,cream,pavilion)end
end
bench(pavilion,CFrame.new(px-9,3.2,pz+9));bench(pavilion,CFrame.new(px+4,3.2,pz+9))
sign(pavilion,'PavilionSign',CFrame.new(px,6,pz+20),'해변 전망 쉼터','COASTAL PAVILION',22)
pavilion.Parent=a;task.wait()
-- Low beach busking stage, speakers, microphone and a decorative piano.
local stage=model('BuskingSquare');local sx=-350;local sz=shore(sx)-52
disc('Stage',Vector3.new(sx,3,sz),21,2,wood,stage)
for i=0,15 do local theta=i*math.pi*2/16;local nextTheta=(i+1)*math.pi*2/16;bar('StageRim',Vector3.new(sx+math.cos(theta)*21,4.1,sz+math.sin(theta)*21),Vector3.new(sx+math.cos(nextTheta)*21,4.1,sz+math.sin(nextTheta)*21),0.22,teal,stage,Enum.Material.Neon)end
for _,x in {-16,16}do
 local speaker=part('Speaker',Vector3.new(4,7,3),CFrame.new(sx+x,7.5,sz+5),navy,Enum.Material.SmoothPlastic,stage)
 for _,y in {6,9}do local cone=part('SpeakerCone',Vector3.new(2.4,2.4,0.18),CFrame.new(sx+x,y,sz+3.4),Color3.fromRGB(47,57,65),Enum.Material.Metal,stage);cone.Shape=Enum.PartType.Ball end
end
bar('MicStand',Vector3.new(sx,4,sz-3),Vector3.new(sx,9,sz-3),0.15,navy,stage)
bar('MicBoom',Vector3.new(sx,9,sz-3),Vector3.new(sx,9.5,sz-4.5),0.3,navy,stage)
local piano=part('PublicPiano',Vector3.new(8,3,3),CFrame.new(sx+7,5.5,sz+5),teal,Enum.Material.SmoothPlastic,stage)
for i=1,13 do part('PianoKey',Vector3.new(0.5,0.15,1.4),CFrame.new(sx+3.5+i*0.5,7.1,sz+3.8),i%3==0 and navy or cream,Enum.Material.SmoothPlastic,stage)end
sign(stage,'StageSign',CFrame.new(sx,7,sz+19),'해변 버스킹 광장','BUSKING SQUARE',23)
for row=1,2 do for _,dx in {-12,2}do bench(stage,CFrame.new(sx+dx,2,sz+27+row*7))end end
stage.Parent=a;task.wait()
-- SUP rack: an activity landmark, no invented real rental operator.
local sup=model('SUPAndBeachLife');local bx=-130;local bz=shore(bx)-78
for _,x in {-9,9}do part('RackPost',Vector3.new(0.7,10,0.7),CFrame.new(bx+x,7,bz),wood,Enum.Material.Wood,sup)end
for _,y in {4,10}do part('RackCrossbar',Vector3.new(22,0.55,0.6),CFrame.new(bx,y,bz),wood,Enum.Material.Wood,sup)end
for i=1,5 do
 local board=part('SUPBoard',Vector3.new(2.4,12,0.7),CFrame.new(bx-9+i*3,8,bz-0.4)*CFrame.Angles(0,0,0.06),({teal,Color3.fromRGB(239,161,104),cream,Color3.fromRGB(124,145,204),Color3.fromRGB(212,137,143)})[i],Enum.Material.SmoothPlastic,sup);local mesh=Instance.new('SpecialMesh');mesh.MeshType=Enum.MeshType.Sphere;mesh.Parent=board
 part('BoardStripe',Vector3.new(0.35,8,0.1),CFrame.new(bx-9+i*3,8,bz-0.8),cream,Enum.Material.SmoothPlastic,sup)
end
sign(sup,'SUPSign',CFrame.new(bx,5,bz+4),'광안리 바다 액티비티','SUP · BEACH LIFE',25)
sup.Parent=a;task.wait()
-- Original wave arches inspired by the area's light-art culture.
local lights=model('WaveLightWalk')
for n=0,6 do
 local x=145+n*30;local z=shore(x);local cf=basis(x,3,z);local tint=n%2==0 and teal or Color3.fromRGB(208,159,192)
 for j=0,11 do
  local t1=j*math.pi/12;local t2=(j+1)*math.pi/12
  local p1=cf:PointToWorldSpace(Vector3.new(0,3+math.sin(t1)*11,math.cos(t1)*11))
  local p2=cf:PointToWorldSpace(Vector3.new(0,3+math.sin(t2)*11,math.cos(t2)*11))
  bar('WaveArch',p1,p2,0.3,tint,lights,Enum.Material.Neon)
 end
 for _,d in {-11,11}do part('ArchFoot',Vector3.new(0.65,3,0.65),cf*CFrame.new(0,1.5,d),navy,Enum.Material.Metal,lights)end
end
sign(lights,'LightWalkSign',CFrame.new(345,6,shore(345)+13),'빛의 산책로','WAVE LIGHT WALK',20)
lights.Parent=a;task.wait()
-- Seaside viewing steps, fictional compressed interpretation of waterfront rest areas.
local deck=model('WaterfrontViewingSteps');local dx=510;local dz=shore(dx)-36
for i=1,3 do part('ViewingStep',Vector3.new(100,1.5+(i-1),11),CFrame.new(dx,2+(1.5+i-1)/2,dz+(i-2)*11),wood,Enum.Material.WoodPlanks,deck)end
for _,x in {-36,-12,12,36}do bench(deck,CFrame.new(dx+x,5.5,dz+11),'WaterfrontBench')end
for _,side in {-51,51}do for z=-16,16,8 do part('RailPost',Vector3.new(0.4,3.5,0.4),CFrame.new(dx+side,5,dz+z),cream,Enum.Material.Metal,deck)end;part('Handrail',Vector3.new(0.4,0.4,34),CFrame.new(dx+side,6.7,dz),cream,Enum.Material.Metal,deck)end
sign(deck,'WaterfrontSign',CFrame.new(dx,7,dz+23),'바다 전망 계단 쉼터','WATERFRONT TERRACE',28)
deck.Parent=a;task.wait()
-- Small parasols and usable beach loungers give the sand a human scale.
local rest=model('BeachParasolLounge')
for _,v in {{-245,-38},{-30,-35},{75,-43},{405,-40}}do
 local x,offset=v[1],v[2];local z=shore(x)+offset
 part('ParasolPole',Vector3.new(0.25,10,0.25),CFrame.new(x,7,z),cream,Enum.Material.Metal,rest)
 local canopy=part('ParasolCanopy',Vector3.new(15,2,15),CFrame.new(x,12,z),teal,Enum.Material.Fabric,rest);canopy.Shape=Enum.PartType.Ball
 for _,d in {-4,4}do
  part('LoungeSeat',Vector3.new(3.5,0.6,5.5),CFrame.new(x+d,3,z+3),cream,Enum.Material.WoodPlanks,rest,'Seat')
  part('LoungeBack',Vector3.new(3.5,3.5,0.5),CFrame.new(x+d,4.5,z+5.5)*CFrame.Angles(math.rad(-12),0,0),cream,Enum.Material.WoodPlanks,rest)
 end
end
rest.Parent=a
-- Six route stops, still client-only session stamps.
if w:FindFirstChild('TourSpots')then w.TourSpots.Parent=archive end
local spots=Instance.new('Folder');spots.Name='TourSpots';spots.Parent=w
w:SetAttribute('RouteStopCount',6)
for _,v in {{-485,pz,'01 · PAVILION'},{sx,sz+26,'02 · BUSKING'},{bx,bz+8,'03 · SUP BEACH'},{0,shore(0)-8,'04 · BRIDGE VIEW'},{265,shore(265)-2,'05 · LIGHT WALK'},{dx,dz+4,'06 · WATERFRONT'}}do
 local pad=part(v[3],Vector3.new(8,0.1,8),CFrame.new(v[1],3.25,v[2]),teal,Enum.Material.SmoothPlastic,spots);pad.Transparency=1;pad.CanCollide=false
 local b=Instance.new('BillboardGui');b.Name='LandmarkLabel';b.Size=UDim2.fromOffset(170,44);b.StudsOffsetWorldSpace=Vector3.new(0,7,0);b.MaxDistance=60;b.Parent=pad
 local l=Instance.new('TextLabel');l.Size=UDim2.fromScale(1,1);l.BackgroundColor3=navy;l.BackgroundTransparency=0.15;l.TextColor3=cream;l.Font=Enum.Font.SourceSansSemibold;l.TextSize=16;l.Text=v[3]..'\nSTAMP SPOT';l.Parent=b
end
-- Fix aspect ratios on every existing sign, including the old guide board.
for _,g in w:GetDescendants()do
 if g:IsA('SurfaceGui')then
  g.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;g.PixelsPerStud=35
  for _,l in g:GetDescendants()do if l:IsA('TextLabel')then l.Font=Enum.Font.SourceSansSemibold;l.TextScaled=false;l.TextSize=g.Parent.Name=='TourismGuideBoard' and 28 or math.min(l.TextSize>20 and l.TextSize or 34,42);l.TextWrapped=true end end
 end
end
local board=w.StreetFurniture:FindFirstChild('TourismGuideBoard')
if board then for _,l in board:GetDescendants()do if l:IsA('TextLabel')then l.Text='광안리 산책 안내\nGWANGALLI VISITOR WALK\n\n전망 쉼터 · 버스킹 · SUP · 빛 산책로 · 수변 계단\n카페 · 소품샵 · 인형뽑기 · 호텔\n\n상점 카운터에서 E 또는 화면 버튼으로 이용하세요' end end end
-- Reduce bloom on warm windows while keeping the coastal night legible.
local bloom=game.Lighting:FindFirstChild('GwangalliBloom');if bloom then bloom.Intensity=0.12;bloom.Threshold=1.8 end
game:GetService('ChangeHistoryService'):SetWaypoint('Revise public attractions and bench alignment')
return {attractions=#a:GetChildren(),routeStops=#spots:GetChildren(),archived=archive:GetFullName()}
