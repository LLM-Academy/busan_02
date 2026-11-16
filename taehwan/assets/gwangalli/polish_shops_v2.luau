local shops=workspace.GwangalliExperience.ShopsV2
assert(not shops:FindFirstChild('ShopLightingV2'),'Lighting already installed')
local fixtures=Instance.new('Folder');fixtures.Name='ShopLightingV2';fixtures.Parent=shops
local function light(x,y,z,parent)
 local p=Instance.new('Part');p.Name='WarmDownlight';p.Size=Vector3.new(1.6,0.3,1.2);p.CFrame=CFrame.new(x,y,z);p.Color=Color3.fromRGB(255,224,176);p.Material=Enum.Material.Neon;p.Anchored=true;p.CanCollide=false;p.Parent=parent
 local l=Instance.new('PointLight');l.Brightness=0.85;l.Range=27;l.Color=p.Color;l.Shadows=false;l.Parent=p
end
for _,v in {{-225,23,13},{-75,19,13},{75,24,14},{240,29,14}}do for _,side in {-1,1}do light(v[1]+side*v[2],v[3],192,fixtures)end end
for _,x in {-250,-200}do for _,z in {209,232}do light(x,16,z,fixtures)end end
light(-100,15,230,fixtures);light(-50,15,230,fixtures)
light(50,18,233,fixtures);light(100,18,233,fixtures)
light(214,15,222,fixtures);light(265,15,222,fixtures)
local titles={['Cafe name']='타이드 컵 카페  /  TIDE CUP',['Boutique name']='바다 편지 소품샵  /  SEA LETTER',['Arcade marquee']='버블 캐치 인형뽑기  /  BUBBLE CATCH',['Hotel name']='호라이즌 하우스 호텔'}
for _,p in shops:GetDescendants()do
 if p:IsA('BasePart')and titles[p.Name]then
  local g=p:FindFirstChildOfClass('SurfaceGui');local l=g and g:FindFirstChildWhichIsA('TextLabel');if l then l.Text=titles[p.Name];l.TextSize=58 end
 end
end
local counter=shops['01 Tide Cup Cafe']:FindFirstChild('OrderCounter')
if counter then
 local s=Instance.new('SurfaceGui');s.Name='CounterServiceLabel';s.Face=Enum.NormalId.Front;s.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;s.PixelsPerStud=35;s.LightInfluence=0.15;s.Parent=counter
 local t=Instance.new('TextLabel');t.Size=UDim2.fromScale(1,1);t.BackgroundTransparency=1;t.Font=Enum.Font.SourceSansSemibold;t.TextSize=48;t.TextColor3=Color3.fromRGB(250,235,205);t.Text='주문하는 곳  ·  ORDER';t.Parent=s
end
for _,m in shops:GetChildren()do if m:IsA('Model')then
 local door=m:GetAttribute('FrontDoorPosition')
 if typeof(door)=='Vector3' then
  local welcome=Instance.new('Part');welcome.Name='WelcomeMat';welcome.Size=Vector3.new(12,0.05,6);welcome.Position=Vector3.new(door.X,3.04,198);welcome.Color=Color3.fromRGB(75,117,115);welcome.Material=Enum.Material.Fabric;welcome.Anchored=true;welcome.Parent=m
 end
end end
game:GetService('ChangeHistoryService'):SetWaypoint('Polish shop lighting and Korean signs')
return {fixtures=#fixtures:GetChildren()}
