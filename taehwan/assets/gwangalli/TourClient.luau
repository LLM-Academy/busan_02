-- Local visual effects: bounded, synchronized, and automatically cleaned up.
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')
local Debris = game:GetService('Debris')
local UIS = game:GetService('UserInputService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local player = Players.LocalPlayer
local world = workspace:WaitForChild('GwangalliExperience')
local camera = workspace.CurrentCamera
local stampTotal = world:GetAttribute('RouteStopCount') or 6
local old = player.PlayerGui:FindFirstChild('GwangalliTour')
if old then old:Destroy() end
local fx = Instance.new('Folder')
fx.Name = 'GwangalliLocalEffects'
fx.Parent = workspace
local lang = 'ko'
local locale = string.lower(player.LocaleId)
if locale:sub(1,2)=='en' then lang='en'
elseif locale:sub(1,2)=='ja' then lang='ja'
elseif locale:find('zh') then lang=(locale:find('tw') or locale:find('hant') or locale:find('hk')) and 'zh-tw' or 'zh-cn' end
local languages = {'ko','en','ja','zh-cn','zh-tw'}
local translations = {
 ko={title='광안리, 불꽃이 머무는 밤',sub='해변을 걷고, 밤바다를 만나요',guide='안내',photo='포토',tour='투어',quality='품질',close='닫기',back='돌아가기',live='불꽃쇼 진행 중',next='다음 불꽃쇼',stamp='스탬프',found='새로운 스탬프를 모았어요',complete='모든 명소 방문 완료 · 전망대 포토가 열렸어요',notice='게임용 재현 초안 · 실제 장소 배치와 다를 수 있어요',body='광안리 체험 산책\n\n전망 쉼터 · 버스킹 광장 · SUP 보드 · 다리 전망 · 빛 산책로 · 수변 계단을 둘러보세요.\n\n카페에서는 음료를 주문하고 앉을 수 있어요. 소품샵의 조개 키링, 인형뽑기집, 호텔 루프톱도 방문해 보세요. 카운터의 E 키 또는 화면 버튼을 사용하세요.\n\n해변의 여섯 명소 가까이 걸어가면 스탬프를 모을 수 있어요. 모든 명소를 방문하면 특별 포토 구도가 열립니다.\n\n불꽃쇼\n짧은 쇼와 휴식이 반복됩니다. 위의 시간표를 확인하세요. 품질 버튼으로 효과를 줄이거나 끌 수 있어요.\n\n포토 · 투어\n포토는 다리 구도로 전환합니다. 투어는 해변을 둘러봅니다. 돌아가기 또는 Esc로 언제든 종료할 수 있어요.\n\n이 맵은 게임용 초안입니다. 실제 축제 일정·교통·관람 정보는 부산시 공식 안내를 확인하세요. 스탬프는 이번 접속 동안만 유지됩니다.'},
 en={title='Gwangalli, after the glow',sub='Walk the shore. Stay for the night.',guide='Guide',photo='Photo',tour='Tour',quality='Quality',close='Close',back='Return',live='Fireworks live',next='Next fireworks',stamp='Stamps',found='New stamp collected',complete='All spots visited · Panorama unlocked',notice='Game prototype · Layout differs from the real location',body='YOUR COASTAL WALK\n\nFind the pavilion, busking square, SUP rack, bridge view, light walk and waterfront steps.\n\nEnter the cafe to order and sit, shop for souvenirs, try the claw arcade and check into the hotel rooftop. Use E or the on-screen prompt at each counter.\n\nWalk close to the six landmarks to collect stamps. Visit them all to unlock a special photo view.\n\nFIREWORKS\nA short show repeats with a break. Check the timer above. Use Quality to reduce or disable effects.\n\nPHOTO & TOUR\nPhoto frames the bridge. Tour follows the coast. Press Return or Esc to exit at any time.\n\nThis is a game prototype. Check official Busan guidance for real festival dates, transport and visitor information. Stamps last for this session only.'},
 ja={title='広安里、花火の余韻',sub='海辺を歩き、夜の海へ',guide='案内',photo='撮影',tour='ツアー',quality='画質',close='閉じる',back='戻る',live='花火上映中',next='次の花火',stamp='スタンプ',found='スタンプを獲得しました',complete='全スポット達成・展望撮影を解放',notice='ゲーム用の試作・実際の配置と異なります',body='海辺の散策\n\n6つのスポットに近づくとスタンプを獲得できます。全部集めると特別な撮影ビューが開きます。\n\n花火\n短いショーと休憩を繰り返します。画質ボタンで効果を軽くしたり停止できます。\n\n撮影・ツアー\n戻るボタンかEscで終了できます。\n\n試作マップです。実際の祭り・交通情報は釜山市の公式案内をご確認ください。スタンプは今回の接続中のみ有効です。'},
 ['zh-cn']={title='广安里，烟花余韵',sub='漫步海岸，邂逅夜海',guide='指南',photo='拍照',tour='游览',quality='画质',close='关闭',back='返回',live='烟花表演中',next='下场烟花',stamp='印章',found='获得新印章',complete='已游览全部景点 · 解锁全景拍照',notice='游戏原型 · 布局与实际地点可能不同',body='海边漫步\n\n走近六处景点即可收集印章。集齐后解锁特别拍照视角。\n\n烟花\n短时表演与休息循环进行。画质按钮可减少或关闭特效。\n\n拍照与游览\n点击返回或按Esc即可退出。\n\n本地图为游戏原型。实际节庆、交通及游览信息请查看釜山市官方公告。印章仅在本次连接期间保留。'},
 ['zh-tw']={title='廣安里，煙火餘韻',sub='漫步海岸，邂逅夜海',guide='指南',photo='拍照',tour='導覽',quality='畫質',close='關閉',back='返回',live='煙火表演中',next='下場煙火',stamp='印章',found='獲得新印章',complete='已遊覽全部景點 · 解鎖全景拍照',notice='遊戲原型 · 配置與實際地點可能不同',body='海邊漫步\n\n走近六處景點即可收集印章。集齊後解鎖特別拍照視角。\n\n煙火\n短時表演與休息循環進行。畫質按鈕可減少或關閉特效。\n\n拍照與導覽\n點擊返回或按Esc即可退出。\n\n本地圖為遊戲原型。實際節慶、交通及遊覽資訊請查看釜山市官方公告。印章僅在本次連線期間保留。'}
}
local function tr(key) return translations[lang][key] or translations.en[key] or key end
local audioNames={ko='소리',en='Sound',ja='音', ['zh-cn']='声音',['zh-tw']='聲音'}
local muted=false
local surfTemplate=ReplicatedStorage:WaitForChild('CoastalSurfAudio',10)
local burstTemplate=ReplicatedStorage:WaitForChild('FireworkBurstAudio',10)
local surf
if surfTemplate then
 surf=surfTemplate:Clone();surf.Name='GwangalliSurf';surf.Volume=0.08;surf.Looped=true;surf.Parent=game:GetService('SoundService');surf:Play()
end
local function make(class,props,parent)
 local o=Instance.new(class)
 for k,v in props do o[k]=v end
 o.Parent=parent
 return o
end
local gui=make('ScreenGui',{Name='GwangalliTour',ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},player.PlayerGui)
local function rounded(o,r) make('UICorner',{CornerRadius=UDim.new(0,r or 16)},o) end
local function text(parent,name,size,pos,fontSize,color)
 return make('TextLabel',{Name=name,Size=size,Position=pos,BackgroundTransparency=1,Text='',TextColor3=color or Color3.fromRGB(237,242,244),Font=Enum.Font.SourceSans,TextSize=fontSize,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true},parent)
end
local panel=make('Frame',{Name='Header',Size=UDim2.new(1,-32,0,126),Position=UDim2.fromOffset(16,12),BackgroundColor3=Color3.fromRGB(11,23,36),BackgroundTransparency=0.12},gui)
make('UISizeConstraint',{MaxSize=Vector2.new(440,126)},panel)
rounded(panel)
text(panel,'Eyebrow',UDim2.new(1,-36,0,16),UDim2.fromOffset(18,12),10,Color3.fromRGB(113,211,210)).Text='BUSAN  /  COASTAL NIGHTS'
local title=text(panel,'Title',UDim2.new(1,-36,0,29),UDim2.fromOffset(18,31),20)
local subtitle=text(panel,'Subtitle',UDim2.new(1,-36,0,19),UDim2.fromOffset(18,63),11,Color3.fromRGB(163,181,196))
local countdown=text(panel,'ShowCountdown',UDim2.new(0.68,-20,0,24),UDim2.fromOffset(18,91),12,Color3.fromRGB(247,207,139))
local stamps=text(panel,'Stamps',UDim2.new(0.32,-18,0,24),UDim2.new(0.68,0,0,91),12)
stamps.TextXAlignment=Enum.TextXAlignment.Right
local bar=make('Frame',{Name='Controls',AnchorPoint=Vector2.new(0.5,1),Position=UDim2.new(0.5,0,1,UIS.TouchEnabled and -102 or -34),Size=UDim2.new(1,-32,0,58),BackgroundColor3=Color3.fromRGB(11,23,36),BackgroundTransparency=0.08},gui)
make('UISizeConstraint',{MaxSize=Vector2.new(580,58)},bar)
rounded(bar)
make('UIPadding',{PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,6),PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6)},bar)
make('UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder},bar)
local buttons={}
for i,key in {'guide','photo','tour','quality','sound','language'} do
 local b=make('TextButton',{Name=key,LayoutOrder=i,Size=UDim2.new(1/6,-3.34,1,0),TextSize=16,TextColor3=Color3.fromRGB(239,244,247),Font=Enum.Font.SourceSansSemibold,BackgroundColor3=Color3.fromRGB(30,49,64),AutoButtonColor=true,TextWrapped=true},bar)
 rounded(b,10);buttons[key]=b
end
local notice=text(gui,'Notice',UDim2.new(1,-32,0,20),UDim2.new(0,16,1,-26),9,Color3.fromRGB(210,219,225));notice.TextXAlignment=Enum.TextXAlignment.Center
local toast=text(gui,'Toast',UDim2.new(1,-40,0,48),UDim2.new(0,20,1,-145),14,Color3.fromRGB(255,225,167));toast.TextXAlignment=Enum.TextXAlignment.Center
local function fitViewport()
 local compact=camera.ViewportSize.Y<500
 bar.Position=UDim2.new(0.5,0,1,UIS.TouchEnabled and -102 or -34)
 panel.Size=UDim2.new(1,-32,0,compact and 96 or 126)
 subtitle.Visible=not compact
 countdown.Position=UDim2.fromOffset(18,compact and 65 or 91)
 stamps.Position=UDim2.new(0.68,0,0,compact and 65 or 91)
 toast.Position=UDim2.new(0,20,1,UIS.TouchEnabled and -215 or -145)
end
camera:GetPropertyChangedSignal('ViewportSize'):Connect(fitViewport)
UIS:GetPropertyChangedSignal('TouchEnabled'):Connect(fitViewport)
fitViewport()
local modal=make('Frame',{Name='GuidePanel',AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.new(1,-40,0.64,0),BackgroundColor3=Color3.fromRGB(13,28,43),Visible=false,ZIndex=5},gui)
make('UISizeConstraint',{MaxSize=Vector2.new(550,510)},modal);rounded(modal)
local close=make('TextButton',{Name='CloseGuide',Position=UDim2.new(1,-90,0,12),Size=UDim2.fromOffset(76,36),TextSize=13,Font=Enum.Font.SourceSans,TextColor3=Color3.new(1,1,1),BackgroundColor3=Color3.fromRGB(37,61,77),ZIndex=7},modal);rounded(close,9)
local scroll=make('ScrollingFrame',{Name='GuideScroll',Position=UDim2.fromOffset(20,62),Size=UDim2.new(1,-40,1,-80),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ZIndex=6},modal)
local body=text(scroll,'Body',UDim2.new(1,-12,0,0),UDim2.new(),15);body.AutomaticSize=Enum.AutomaticSize.Y;body.TextYAlignment=Enum.TextYAlignment.Top;body.ZIndex=6
local collected={}
local stampCount=0
local quality=UIS.TouchEnabled and 2 or 1
local qualityNames={'HIGH','LOW','OFF'}
local mode=nil
local tween=nil
local generation=0
local function restoreCamera()
 generation+=1
 if tween then tween:Cancel();tween=nil end
 mode=nil
 camera.CameraType=Enum.CameraType.Custom
 local char=player.Character
 if char then camera.CameraSubject=char:FindFirstChildOfClass('Humanoid') end
end
local function refresh()
 title.Text=tr('title');subtitle.Text=tr('sub');notice.Text=tr('notice');body.Text=tr('body');close.Text=tr('close')
 for _,k in {'guide','photo','tour'} do buttons[k].Text=(mode and k~='guide') and tr('back') or tr(k) end
 buttons.quality.Text=tr('quality')..'\n'..qualityNames[quality]
 buttons.sound.Text=audioNames[lang]..'\n'..(muted and 'OFF' or 'ON')
 buttons.language.Text=lang:upper()
 stamps.Text=tr('stamp')..'  '..stampCount..' / '..stampTotal
end
local function cameraTo(pos,look,seconds)
 camera.CameraType=Enum.CameraType.Scriptable
 tween=TweenService:Create(camera,TweenInfo.new(seconds,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{CFrame=CFrame.lookAt(pos,look)})
 tween:Play()
end
buttons.guide.Activated:Connect(function() modal.Visible=not modal.Visible end)
close.Activated:Connect(function()modal.Visible=false end)
buttons.language.Activated:Connect(function()
 local n=table.find(languages,lang) or 1;lang=languages[n%#languages+1];refresh()
end)
buttons.quality.Activated:Connect(function()quality=quality%3+1;if quality==3 then fx:ClearAllChildren() end;refresh()end)
buttons.sound.Activated:Connect(function()
 muted=not muted
 if surf then surf.Volume=muted and 0 or 0.08 end
 if muted then for _,s in fx:GetDescendants()do if s:IsA('Sound')then s:Stop()end end end
 refresh()
end)
buttons.photo.Activated:Connect(function()
 if mode then restoreCamera();refresh();return end
 mode='photo';modal.Visible=false
 local z=world:GetAttribute('PromenadeZ') or 130
 cameraTo(stampCount==stampTotal and Vector3.new(270,95,z+110) or Vector3.new(0,11,z-10),Vector3.new(0,90,-350),1)
 refresh()
end)
buttons.tour.Activated:Connect(function()
 if mode then restoreCamera();refresh();return end
 mode='tour';modal.Visible=false;generation+=1;local token=generation;refresh()
 task.spawn(function()
  local z=world:GetAttribute('PromenadeZ') or 130
  for _,point in {Vector3.new(-400,70,z+45),Vector3.new(0,45,z-30),Vector3.new(370,85,z+60)} do
   if generation~=token then return end
   cameraTo(point,Vector3.new(0,70,-350),6);task.wait(6)
  end
  if generation==token then restoreCamera();refresh() end
 end)
end)
UIS.InputBegan:Connect(function(input)
 if input.KeyCode==Enum.KeyCode.Escape or input.KeyCode==Enum.KeyCode.ButtonB then modal.Visible=false;restoreCamera();refresh() end
end)
player.CharacterAdded:Connect(function()restoreCamera();refresh()end)
local palette={Color3.fromRGB(255,205,107),Color3.fromRGB(124,218,255),Color3.fromRGB(255,135,165),Color3.fromRGB(194,166,255)}
local rockets={}
local liveBursts=0
local activeSounds=0
local function burst(pos,color,willow,ring)
 if quality==3 or not fx.Parent then return end
 if liveBursts>=(quality==2 and 5 or 12) then return end
 liveBursts+=1
 local p=make('Part',{Name='FireworkBurst',Size=Vector3.one,Transparency=1,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,Position=pos},fx)
 local a=make('Attachment',{},p)
 local e=make('ParticleEmitter',{Texture='rbxasset://textures/particles/sparkles_main.dds',Rate=0,Color=ColorSequence.new(color),Brightness=3,LightEmission=1,LightInfluence=0,Speed=NumberRange.new(willow and 34 or 55,willow and 52 or 88),SpreadAngle=Vector2.new(180,180),Lifetime=NumberRange.new(2.8,willow and 5 or 4.2),Drag=willow and 0.35 or 0.5,Acceleration=Vector3.new(0,willow and -15 or -12,0),Size=NumberSequence.new({NumberSequenceKeypoint.new(0,2.6),NumberSequenceKeypoint.new(0.12,4.8),NumberSequenceKeypoint.new(1,0)}),Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.65,0.15),NumberSequenceKeypoint.new(1,1)})},p)
 e.Shape=ring and Enum.ParticleEmitterShape.Disc or Enum.ParticleEmitterShape.Sphere
 e.ShapeStyle=Enum.ParticleEmitterShapeStyle.Surface
 e.ShapeInOut=Enum.ParticleEmitterShapeInOut.Outward
 if ring then e.EmissionDirection=Enum.NormalId.Front;e.ShapePartial=0;e.SpreadAngle=Vector2.zero;e.Speed=NumberRange.new(68) end
 e:Emit(quality==2 and 40 or 95)
 if quality==1 then
  local smoke=make('ParticleEmitter',{Texture='rbxasset://textures/particles/smoke_main.dds',Rate=0,Color=ColorSequence.new(Color3.fromRGB(126,137,157)),LightEmission=0.1,LightInfluence=0.8,Speed=NumberRange.new(1,5),SpreadAngle=Vector2.new(180,180),Lifetime=NumberRange.new(3,5),Acceleration=Vector3.new(4,1,0),Size=NumberSequence.new(12,42),Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.9),NumberSequenceKeypoint.new(0.2,0.82),NumberSequenceKeypoint.new(1,1)})},a)
  smoke:Emit(7)
 end
 local light=make('PointLight',{Color=color,Brightness=3,Range=55,Shadows=false},p)
 TweenService:Create(light,TweenInfo.new(0.8),{Brightness=0}):Play()
 if quality==1 then
  for i=1,5 do
   local reflection=make('Part',{Name='WaterLightReflection',Size=Vector3.new(2+i*1.3,0.05,18+i*3),Position=Vector3.new(pos.X+math.sin(i)*3,-1.8,-280+i*28),Color=color,Material=Enum.Material.Neon,Transparency=0.7,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false},fx)
   TweenService:Create(reflection,TweenInfo.new(1.2),{Transparency=1}):Play();Debris:AddItem(reflection,1.3)
  end
 end
 if burstTemplate and not muted then
  local delaySeconds=(camera.CFrame.Position-pos).Magnitude*0.28/343
  task.delay(delaySeconds,function()
   if muted or quality==3 or not fx.Parent or activeSounds>=8 then return end
   activeSounds+=1
   local node=make('Part',{Name='DelayedFireworkSound',Size=Vector3.one,Position=pos,Transparency=1,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false},fx)
   local sound=burstTemplate:Clone();sound.Volume=0.35;sound.RollOffMinDistance=80;sound.RollOffMaxDistance=1600;sound.Parent=node;sound:Play()
   Debris:AddItem(node,9);task.delay(9,function()activeSounds=math.max(0,activeSounds-1)end)
  end)
 end
 Debris:AddItem(p,6)
 task.delay(6,function()liveBursts=math.max(0,liveBursts-1)end)
end
local function launch(index,cycle)
 if quality==3 or (quality==2 and index%2==0) or #rockets>=8 then return end
 local rng=Random.new(index+cycle*181)
 local x=rng:NextNumber(-370,370)
 local z=-420+rng:NextNumber(-70,45)
 local start=Vector3.new(x,8,z)
 local target=start+Vector3.new(rng:NextNumber(-20,20),rng:NextNumber(160,230),0)
 local color=palette[index%#palette+1]
 local p=make('Part',{Name='FireworkShell',Shape=Enum.PartType.Ball,Size=Vector3.one*0.65,Material=Enum.Material.Neon,Color=color,Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,Position=start},fx)
 local a=make('Attachment',{Position=Vector3.new(-0.2,0,0)},p)
 local b=make('Attachment',{Position=Vector3.new(0.2,0,0)},p)
 make('Trail',{Attachment0=a,Attachment1=b,Color=ColorSequence.new(color),LightEmission=1,Lifetime=0.45,Transparency=NumberSequence.new(0,1)},p)
 table.insert(rockets,{p=p,from=start,to=target,start=os.clock(),color=color,willow=index%4==0,ring=index%6==0})
end
local previousCue=nil
local heartbeat=0
RunService.Heartbeat:Connect(function(dt)
 for i=#rockets,1,-1 do
  local r=rockets[i]
  local t=(os.clock()-r.start)/1.7
  if not r.p.Parent then table.remove(rockets,i)
  elseif t>=1 then r.p:Destroy();table.remove(rockets,i);burst(r.to,r.color,r.willow,r.ring)
  else r.p.Position=r.from:Lerp(r.to,1-(1-t)^1.6) end
 end
 heartbeat+=dt
 if heartbeat<0.2 then return end
 heartbeat=0
 local epoch=workspace:GetAttribute('GwangalliShowEpoch')
 if not epoch then return end
 local elapsed=workspace:GetServerTimeNow()-epoch
 local cycle=math.floor(math.max(0,elapsed)/150)
 local phase=elapsed>=0 and elapsed%150 or elapsed
 local active=phase>=0 and phase<75
 local remain=elapsed<0 and -elapsed or active and 75-phase or 150-phase
 countdown.Text=(active and tr('live') or tr('next'))..'  '..string.format('%02d:%02d',math.floor(remain/60),math.floor(remain%60))
 local interval=phase>55 and 0.55 or phase>22 and 1.3 or 2.5
 local cue=active and math.floor(phase/interval) or -1
 local key=cycle..':'..cue..':'..interval
 if active and key~=previousCue then previousCue=key;launch(cue,cycle) end
 local root=player.Character and player.Character:FindFirstChild('HumanoidRootPart')
 local spots=world:FindFirstChild('TourSpots')
 if root and spots then
  for _,spot in spots:GetChildren() do
   if spot:IsA('BasePart') and not collected[spot.Name] and (root.Position-spot.Position).Magnitude<18 then
    collected[spot.Name]=true;stampCount+=1
    local label=spot:FindFirstChild('LandmarkLabel');if label then label.Enabled=false end
    refresh();toast.Text=stampCount==stampTotal and tr('complete') or tr('found')..' · '..spot.Name
    local message=toast.Text;task.delay(5,function()if toast.Text==message then toast.Text='' end end)
   end
  end
 end
 gui:SetAttribute('CameraMode',mode or 'walk')
 gui:SetAttribute('StampCount',stampCount)
 gui:SetAttribute('Quality',quality)
 gui:SetAttribute('Language',lang)
 gui:SetAttribute('ActiveRockets',#rockets)
 gui:SetAttribute('LiveBursts',liveBursts)
 gui:SetAttribute('Muted',muted)
end)
refresh()
script.Destroying:Connect(function()restoreCamera();fx:Destroy();gui:Destroy();if surf then surf:Destroy()end end)
print('Gwangalli tour client ready')

