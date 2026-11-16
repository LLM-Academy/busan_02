-- Public wayfinding drawn from the provided Maps place and official tourism sources.
local w=workspace.GwangalliExperience
assert(not w.AttractionsV2:FindFirstChild('RegionalWayfinding'),'Wayfinding already installed')
local f=Instance.new('Folder');f.Name='RegionalWayfinding';f.Parent=w.AttractionsV2
local function shore(x)return 120-110*(x/600)^2 end
for _,v in {{-530,'남천 방면 관광 안내','남천해변공원 · 해양레저\nNAMCHEON · BEACH & SUP'},{530,'민락 방면 관광 안내','광안해변공원 · 민락회타운 · 수변공원\nMILLAK · PARK · SEAFOOD · WATERFRONT'}}do
 local p=Instance.new('Part');p.Name='RegionalTourismBoard';p.Size=Vector3.new(27,7,0.4);p.Position=Vector3.new(v[1],9,shore(v[1])+12);p.Color=Color3.fromRGB(29,63,73);p.Anchored=true;p.Parent=f
 for _,face in {Enum.NormalId.Front,Enum.NormalId.Back}do
  local g=Instance.new('SurfaceGui');g.Face=face;g.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;g.PixelsPerStud=35;g.LightInfluence=0.15;g.Parent=p
  local l=Instance.new('TextLabel');l.Size=UDim2.new(1,-30,1,-24);l.Position=UDim2.fromOffset(15,12);l.BackgroundTransparency=1;l.Font=Enum.Font.SourceSansSemibold;l.TextSize=35;l.TextWrapped=true;l.TextColor3=Color3.fromRGB(245,231,199);l.Text=v[2]..'\n\n'..v[3]..'\n\n게임 속 동선은 실제 거리와 다르게 압축했습니다';l.Parent=g
 end
 for _,dx in {-10,10}do local leg=Instance.new('Part');leg.Name='BoardPost';leg.Size=Vector3.new(0.5,6,0.5);leg.Position=Vector3.new(v[1]+dx,5.5,shore(v[1])+12);leg.Color=p.Color;leg.Anchored=true;leg.Parent=f end
end
local board=w.StreetFurniture:FindFirstChild('TourismGuideBoard')
if board then for _,l in board:GetDescendants()do if l:IsA('TextLabel')then l.Text='광안리 체험 산책\n카페 · 소품샵 · 인형뽑기 · 호텔 루프톱\n\n남천 방면: 해변공원 · SUP\n민락 방면: 광안해변공원 · 회타운 · 수변공원\n\n상점은 게임용 가상 매장입니다\n실제 명소 간 거리와 위치는 압축했습니다';l.TextSize=29 end end end
game:GetService('ChangeHistoryService'):SetWaypoint('Add map-referenced regional wayfinding')
return {regionalBoards=2,mapReference='Gwangalli Beach Google Maps',exactSurvey=false}
