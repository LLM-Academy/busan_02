-- StarterPlayerScripts.GwangalliLandmarkUI. Temporary local photos only; no uploads or saves.
local Players=game:GetService('Players')
local RS=game:GetService('ReplicatedStorage')
local RunService=game:GetService('RunService')
local CAS=game:GetService('ContextActionService')
local player=Players.LocalPlayer
local pg=player:WaitForChild('PlayerGui')
local remote=RS:WaitForChild('GwangalliLandmarkRemote')
local old=pg:FindFirstChild('GwangalliLandmarkUI'); if old then old:Destroy() end
local function make(class,props,parent)
 local v=Instance.new(class); for k,val in props do v[k]=val end; v.Parent=parent; return v
end
local gui=make('ScreenGui',{Name='GwangalliLandmarkUI',ResetOnSpawn=false,DisplayOrder=80,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,Enabled=false},pg)
local panel=make('Frame',{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.new(1,-32,1,-32),BackgroundColor3=Color3.fromRGB(20,41,50)},gui)
make('UISizeConstraint',{MaxSize=Vector2.new(460,720)},panel)
make('UICorner',{CornerRadius=UDim.new(0,16)},panel)
local scroll=make('ScrollingFrame',{Position=UDim2.fromOffset(16,16),Size=UDim2.new(1,-32,1,-32),AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ScrollBarThickness=4,BackgroundTransparency=1,BorderSizePixel=0},panel)
make('UIListLayout',{Padding=UDim.new(0,10),SortOrder=Enum.SortOrder.LayoutOrder},scroll)
local function ko()
 local tour=pg:FindFirstChild('GwangalliTour'); local lang=tour and tour:GetAttribute('Language') or 'ko'
 return tostring(lang):lower()=='ko' or tostring(lang):lower()=='korean'
end
local function tr(a,b) return ko() and a or b end
local function text(value,height)
 return make('TextLabel',{Size=UDim2.new(1,-6,0,height or 52),BackgroundTransparency=1,Text=value,TextWrapped=true,TextSize=19,Font=Enum.Font.SourceSansSemibold,TextColor3=Color3.fromRGB(245,243,225),LayoutOrder=#scroll:GetChildren()},scroll)
end
local function button(value,fn)
 local b=make('TextButton',{Size=UDim2.new(1,-6,0,52),BackgroundColor3=Color3.fromRGB(247,208,150),TextColor3=Color3.fromRGB(24,44,50),Text=value,TextSize=20,Font=Enum.Font.SourceSansSemibold,TextWrapped=true,LayoutOrder=#scroll:GetChildren(),AutoButtonColor=true},scroll)
 make('UICorner',{CornerRadius=UDim.new(0,10)},b); b.Activated:Connect(fn); return b
end
local function compact(on)
 if on then panel.AnchorPoint=Vector2.new(.5,0); panel.Position=UDim2.new(.5,0,0,16); panel.Size=UDim2.fromOffset(300,180)
 else panel.AnchorPoint=Vector2.new(.5,.5); panel.Position=UDim2.fromScale(.5,.5); panel.Size=UDim2.new(1,-32,1,-32) end
end
local function clear()
 for _,v in scroll:GetChildren() do if v:IsA('GuiObject') then v:Destroy() end end
 scroll.CanvasPosition=Vector2.zero
 compact(false)
end
local note
local active=false
local generation=0
local savedGuis={}
local savedJoints={}
local savedFov
local controls
local gallery
local menuKind
local poseNames={{'안녕!','Hello!'},{'저기 봐!','Look there!'},{'만세!','Hooray!'},{'하하!','Ha ha!'}}
-- 2026-11-16 Claude: R15 AnimationConstraint rigs ignore Motor6D.C0, so each shot also plays a default emote.
local poseEmotes={'wave','point','cheer','laugh'}
-- Seconds into each emote where the arms are highest (measured in Studio 2026-11-16); hold that frame for the shot.
local poseHold={0.6,0.85,nil,nil}
local poseTrack
pcall(function() controls=require(player:WaitForChild('PlayerScripts'):WaitForChild('PlayerModule',8)):GetControls() end)
local function recover()
 local c=player.Character; local h=c and c:FindFirstChildOfClass('Humanoid')
 for joint,value in savedJoints do if joint.Parent then joint.C0=value end end; savedJoints={}
 if poseTrack then poseTrack:Stop(0.2); poseTrack=nil end
 local camera=workspace.CurrentCamera
 if camera then camera.CameraType=Enum.CameraType.Custom; if h then camera.CameraSubject=h end; if savedFov then camera.FieldOfView=savedFov end end
 savedFov=nil
 for g,value in savedGuis do if g.Parent then g.Enabled=value end end; savedGuis={}
 CAS:UnbindAction('GwangalliPhotoMovement')
 if controls then controls:Enable() end
 active=false
end
local function endPhoto()
 generation+=1
 local wasActive=active
 recover()
 if wasActive then remote:FireServer('PhotoDone') end
end
local function close() endPhoto(); gui.Enabled=false end
local function disclaimer()
 text(tr('무료 체험 · 이번 접속 한정\n게임용 재현 · 실제 브랜드와 공식 제휴 없음','FREE experience · This visit only\nGame recreation · No official brand affiliation'),70)
end
local function cloneAvatar()
 local character=player.Character; if not character then return end
 local previous=character.Archivable; character.Archivable=true
 local ok,clone=pcall(function() return character:Clone() end); character.Archivable=previous
 if not ok or not clone then return end
 for _,v in clone:GetDescendants() do
  if v:IsA('BaseScript') or v:IsA('Tool') then v:Destroy()
  elseif v:IsA('BasePart') then v.Anchored=true; v.CanCollide=false end
 end
 local h=clone:FindFirstChildOfClass('Humanoid'); if h then h.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None end
 return clone
end
local function applyPose(index)
 local character=player.Character; if not character then return end
 -- Play the default Animate emote (wave/point/cheer/laugh) directly; PlayEmote only accepts avatar-equipped emote names.
 if poseTrack then poseTrack:Stop(0.1); poseTrack=nil end
 local hum=character:FindFirstChildOfClass('Humanoid'); local animator=hum and hum:FindFirstChildOfClass('Animator')
 local holder=character:FindFirstChild('Animate') and character.Animate:FindFirstChild(poseEmotes[index])
 local anim=holder and holder:FindFirstChildOfClass('Animation')
 if animator and anim then pcall(function() poseTrack=animator:LoadAnimation(anim); poseTrack.Priority=Enum.AnimationPriority.Action4; poseTrack.Looped=false; poseTrack:Play(0.15) end) end
 local hold,track=poseHold[index],poseTrack
 if hold and track then task.delay(hold,function() if poseTrack==track then track:AdjustSpeed(0) end end) end
 for _,v in character:GetDescendants() do
  if v:IsA('Motor6D') and (v.Name=='RightShoulder' or v.Name=='Right Shoulder' or v.Name=='LeftShoulder' or v.Name=='Left Shoulder') then
   if not savedJoints[v] then savedJoints[v]=v.C0 end
   local right=v.Name:find('Right')~=nil
   local angle=({75,110,145,35})[index]
   v.C0=savedJoints[v]*CFrame.Angles(0,0,math.rad((right and 1 or -1)*angle))
  end
 end
end
local function destroyGallery()
 if gallery then for _,frame in gallery.frames do if frame.avatar then frame.avatar:Destroy() end end end
 gallery=nil
end
local showGallery,showMenu
local function viewport(parent,avatar)
 local vp=make('ViewportFrame',{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.fromRGB(168,215,222),Ambient=Color3.fromRGB(210,210,210),LightColor=Color3.fromRGB(255,246,226),LightDirection=Vector3.new(-1,-1,-2)},parent)
 local world=make('WorldModel',{},vp)
 local clone=avatar:Clone(); clone.Parent=world
 clone:PivotTo(CFrame.new(0,0,0))
 -- Preserve frozen limb world positions after PivotTo; no scripts or animation run here.
 make('Part',{Name='BoothFloor',Size=Vector3.new(14,.2,12),Position=Vector3.new(0,-3,0),Color=Color3.fromRGB(233,216,221),Anchored=true},world)
 make('Part',{Name='BoothBackdrop',Size=Vector3.new(14,12,.2),Position=Vector3.new(0,2,3),Color=Color3.fromRGB(151,202,214),Anchored=true},world)
 for i=-2,2 do make('Part',{Size=Vector3.new(.12,8,.1),Position=Vector3.new(i*2,1,2.8),Color=Color3.fromRGB(244,234,203),Anchored=true},world) end
 local camera=make('Camera',{CFrame=CFrame.lookAt(Vector3.new(0,1,-9),Vector3.new(0,.4,0)),FieldOfView=48},vp); vp.CurrentCamera=camera
 return vp
end
showGallery=function()
 clear(); gui.Enabled=true
 text(tr('인생네컷 · 광안리','FOUR CUTS · GWANGALLI'),34)
 if not gallery then text(tr('아직 사진이 없어요.','No photos yet.'),44) else
  text(gallery.actual and tr('이번 접속의 임시 사진 · 기기에 저장되지 않아요','Temporary screenshots · Not saved to your device') or tr('아바타 4컷 미리보기 · 실제 스크린샷 아님','Four avatar previews · Not actual screenshots'),60)
  for i,frame in gallery.frames do
   local row=make('Frame',{Size=UDim2.new(1,-6,0,170),BackgroundColor3=Color3.fromRGB(251,245,228),LayoutOrder=#scroll:GetChildren()},scroll)
   local imageArea=make('Frame',{Position=UDim2.fromOffset(7,7),Size=UDim2.new(1,-14,1,-30),ClipsDescendants=true,BackgroundTransparency=1},row)
   if gallery.actual then make('ImageLabel',{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,Image=frame.image,ScaleType=Enum.ScaleType.Crop},imageArea)
   elseif frame.avatar then viewport(imageArea,frame.avatar) end
   make('TextLabel',{Position=UDim2.new(0,0,1,-24),Size=UDim2.new(1,0,0,22),BackgroundTransparency=1,Text=tostring(i)..' / 4  ·  '..tr(poseNames[i][1],poseNames[i][2]),TextSize=18,TextColor3=Color3.fromRGB(25,50,60),Font=Enum.Font.SourceSansSemibold},row)
  end
 end
 button(tr('다시 찍기 · 무료','Retake · FREE'),function() remote:FireServer('Photo') end)
 button(tr('돌아가기','Return'),close)
end
showMenu=function(kind)
 menuKind=kind; clear(); gui.Enabled=true
 local titles={BeautySample={'올리브영 · 뷰티 체험','OLIVE YOUNG · Beauty samples'},FishCakeOrder={'삼진어묵 · 어묵 체험','SAMJIN · Fishcake tasting'},FourCuts={'인생네컷 · 셀프 포토','FOUR CUTS · Photo booth'},SeafoodSample={'민락회센터 · 바다 체험','MILLAK · Seafood experience'}}
 local title=titles[kind]; if not title then return end
 text(tr(title[1],title[2]),54); disclaimer()
 local function gift(item,a,b) button(tr(a,b)..tr(' · 무료',' · FREE'),function() remote:FireServer('Gift',item) end) end
 if kind=='BeautySample' then gift('sunscreen','선크림 샘플','Sunscreen sample'); gift('mask','마스크팩 샘플','Face mask sample')
 elseif kind=='FishCakeOrder' then gift('fishcake','따끈한 어묵꼬치','Fishcake skewer')
 elseif kind=='SeafoodSample' then gift('fish','작은 물고기 기념품','Small fish souvenir'); gift('meal','해산물 한상','Seafood meal prop')
 else
  text(tr('4가지 포즈로 네 컷을 찍어요. 사진은 이번 접속에서만 확인할 수 있어요.','Take four poses. Your photos stay only for this visit.'),70)
  button(tr('4컷 촬영 · 무료','Take four shots · FREE'),function() remote:FireServer('Photo') end)
  if gallery then button(tr('이번 접속 사진 보기','View this visit’s photos'),showGallery) end
 end
 note=text('',64); button(tr('돌아가기','Return'),close)
end
local function captureScreenshot(token)
 local done=false; local id
 local ok=pcall(function()
  game:GetService('CaptureService'):CaptureScreenshot(function(contentId)
   if generation==token then id=contentId; done=true end
  end)
 end)
 if not ok then return nil end
 local start=os.clock()
 while not done and generation==token and os.clock()-start<1.1 do task.wait(.03) end
 if type(id)=='string' and #id>0 then return id end
end
local function startPhoto(data)
 endPhoto(); generation+=1; local token=generation
 if typeof(data.camera)~='Vector3' or typeof(data.look)~='Vector3' then return end
 active=true
 local camera=workspace.CurrentCamera; if not camera then endPhoto(); return end
 savedFov=camera.FieldOfView
 for _,g in pg:GetChildren() do if g:IsA('ScreenGui') and g~=gui and g.Name:find('Gwangalli') then savedGuis[g]=g.Enabled; g.Enabled=false end end
 if controls then controls:Disable() end
 CAS:BindActionAtPriority('GwangalliPhotoMovement',function() return Enum.ContextActionResult.Sink end,false,Enum.ContextActionPriority.High.Value+20,Enum.PlayerActions.CharacterForward,Enum.PlayerActions.CharacterBackward,Enum.PlayerActions.CharacterLeft,Enum.PlayerActions.CharacterRight,Enum.PlayerActions.CharacterJump)
 camera.CameraType=Enum.CameraType.Scriptable; camera.CFrame=CFrame.lookAt(data.camera,data.look); camera.FieldOfView=48
 clear(); compact(true); gui.Enabled=true; local countdown=text('',80)
 button(tr('촬영 취소','Cancel capture'),close)
 local frames={}; local actual=true
 task.delay(16,function() if active and generation==token then endPhoto(); gui.Enabled=false end end)
 task.spawn(function()
  local ok,err=xpcall(function()
   for i=1,4 do
    if generation~=token then return end
    applyPose(i)
    for n=3,1,-1 do
     if generation~=token then return end
     countdown.Text=tr(poseNames[i][1],poseNames[i][2])..'  '..i..'/4\n'..n; task.wait(.45)
    end
    gui.Enabled=false; RunService.RenderStepped:Wait(); RunService.RenderStepped:Wait()
    local avatar=cloneAvatar()
    local id=captureScreenshot(token)
    if not id then actual=false end
    frames[i]={image=id,avatar=avatar}
    if generation~=token then return end
    gui.Enabled=true
   end
  end,debug.traceback)
  if generation~=token then for _,f in frames do if f.avatar then f.avatar:Destroy() end end; return end
  endPhoto()
  if ok and #frames==4 then
   -- If even one screenshot is unavailable, show four consistent frozen avatar previews.
   if not actual then for _,f in frames do if not f.avatar then ok=false end end end
   if ok then destroyGallery(); gallery={frames=frames,actual=actual}; showGallery(); return end
  end
  for _,f in frames do if f.avatar then f.avatar:Destroy() end end
  showMenu('FourCuts'); note.Text=tr('촬영을 마치지 못했어요. 다시 시도해 주세요.','Capture could not finish. Please try again.')
  if not ok then warn('Gwangalli photo capture recovered',err) end
 end)
end
local messages={near={'카운터 가까이에서 다시 열어 주세요.','Open the counter again from nearby.'},cooldown={'같은 체험은 10초 후에 다시 가능해요.','Try this sample again after 10 seconds.'},gift={'무료 체험 소품을 가방에 넣었어요! 같은 소품은 하나만 보관돼요.','Free sample added to your backpack! One of each prop is kept.'},busy={'다른 손님이 촬영 중이에요. 잠시 후 다시 시도해 주세요.','Someone is using the booth. Please try again shortly.'},unavailable={'촬영 준비 중이에요. 잠시 후 다시 시도해 주세요.','Booth unavailable. Please try again shortly.'}}
remote.OnClientEvent:Connect(function(data)
 if type(data)~='table' then return end
 if data.type=='Menu' and not active then showMenu(data.kind)
 elseif data.type=='Message' then local m=messages[data.key]; if note and note.Parent and m then note.Text=tr(m[1],m[2]) elseif m then clear(); gui.Enabled=true; text(tr(m[1],m[2]),100); button(tr('돌아가기','Return'),close) end
 elseif data.type=='PhotoStart' then startPhoto(data)
 elseif data.type=='PhotoEnd' and active then endPhoto(); gui.Enabled=false end
end)
local function bindCharacter(character)
 local h=character:WaitForChild('Humanoid',10)
 if h then h.Died:Connect(function() endPhoto(); gui.Enabled=false end) end
end
player.CharacterAdded:Connect(function(character) endPhoto(); gui.Enabled=false; bindCharacter(character) end)
if player.Character then task.spawn(bindCharacter,player.Character) end
script.Destroying:Connect(function() endPhoto(); destroyGallery(); gui:Destroy() end)
