-- ServerScriptService.GwangalliLandmarkActivities. Session-only, free experiences.
local Players = game:GetService('Players')
local RS = game:GetService('ReplicatedStorage')
local PPS = game:GetService('ProximityPromptService')
local landmarks = workspace:WaitForChild('GwangalliLandmarks')
local remote = RS:FindFirstChild('GwangalliLandmarkRemote')
if remote and not remote:IsA('RemoteEvent') then error('GwangalliLandmarkRemote must be a RemoteEvent') end
if not remote then remote=Instance.new('RemoteEvent'); remote.Name='GwangalliLandmarkRemote'; remote.Parent=RS end
local states = {}
local occupant
local allowed = {BeautySample=true,FishCakeOrder=true,FourCuts=true,SeafoodSample=true}
local items = {sunscreen='BeautySample',mask='BeautySample',fishcake='FishCakeOrder',fish='SeafoodSample',meal='SeafoodSample'}
local names={sunscreen='선크림 체험 / Sunscreen',mask='마스크팩 체험 / Face mask',fishcake='삼진 어묵꼬치 / Fishcake skewer',fish='민락 물고기 기념품 / Fish souvenir',meal='민락 해산물 한상 / Seafood meal'}
local function state(p)
 if not states[p] then states[p]={cooldowns={},last=0} end
 return states[p]
end
local function send(p,data) if p.Parent==Players then remote:FireClient(p,data) end end
local function character(p)
 local c=p.Character; local h=c and c:FindFirstChildOfClass('Humanoid'); local r=c and c:FindFirstChild('HumanoidRootPart')
 if c and h and h.Health>0 and r then return c,h,r end
end
local function kind(prompt)
 if not prompt or not prompt:IsA('ProximityPrompt') or not prompt:IsDescendantOf(landmarks) then return end
 local part=prompt.Parent
 if not part or not part:IsA('BasePart') then return end
 local k=part:GetAttribute('LandmarkKind') or prompt:GetAttribute('LandmarkKind')
 if allowed[k] then return k end
end
local function near(p,prompt)
 local _,_,root=character(p)
 return root and kind(prompt) and prompt.Enabled and (root.Position-prompt.Parent.Position).Magnitude<=14
end
local function visual(tool,handle,name,size,offset,color,shape)
 local part=Instance.new('Part'); part.Name=name; part.Size=size; part.Color=color; part.Material=Enum.Material.SmoothPlastic
 part.CanCollide=false; part.CanTouch=false; part.CanQuery=false; part.Massless=true
 if shape then part.Shape=shape end
 part.CFrame=handle.CFrame*offset; part.Parent=tool
 local weld=Instance.new('WeldConstraint'); weld.Part0=handle; weld.Part1=part; weld.Parent=part
 return part
end
local function label(part,text)
 local face=Instance.new('SurfaceGui'); face.Face=Enum.NormalId.Front; face.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud; face.PixelsPerStud=100; face.Parent=part
 local t=Instance.new('TextLabel'); t.Size=UDim2.fromScale(1,1); t.BackgroundTransparency=1; t.Text=text; t.TextScaled=true; t.TextColor3=Color3.fromRGB(25,65,55); t.Font=Enum.Font.SourceSansBold; t.Parent=face
end
local function gift(p,item)
 local bag=p:FindFirstChildOfClass('Backpack'); if not bag then return false end
 -- Keep only one of each sample; cooldown still applies even if it is discarded.
 for _,container in {bag,p.Character} do
  if container then for _,v in container:GetChildren() do if v:IsA('Tool') and v:GetAttribute('GwangalliLandmarkItem')==item then return true end end end
 end
 local t=Instance.new('Tool'); t.Name=names[item]; t.ToolTip='무료 체험 · 게임용 재현 / Free game prop'; t.CanBeDropped=false
 t:SetAttribute('GwangalliLandmarkItem',item)
 -- Handle and all visible pieces use Y as up, including the skewer.
 t.Grip=CFrame.new(0,-.3,0)
 local h=Instance.new('Part'); h.Name='Handle'; h.Size=Vector3.new(.16,.65,.16); h.Transparency=1; h.CanCollide=false; h.CanTouch=false; h.Massless=true; h.Parent=t
 local cream=Color3.fromRGB(255,220,164); local green=Color3.fromRGB(145,190,128)
 if item=='sunscreen' then
  local body=visual(t,h,'Tube',Vector3.new(.65,1.1,.3),CFrame.new(0,.55,0),Color3.fromRGB(249,248,224)); label(body,'SUN\nSPF 50\nFREE')
  visual(t,h,'Cap',Vector3.new(.68,.22,.32),CFrame.new(0,-.1,0),green)
 elseif item=='mask' then
  local packet=visual(t,h,'MaskPacket',Vector3.new(.9,1.15,.12),CFrame.new(0,.45,0),Color3.fromRGB(205,229,192)); label(packet,'FACE\nMASK\nFREE')
 elseif item=='fishcake' then
  visual(t,h,'VerticalWoodenSkewer',Vector3.new(.07,2.5,.07),CFrame.new(0,.75,0),Color3.fromRGB(176,117,61))
  for i=1,4 do visual(t,h,'FoldedFishcake'..i,Vector3.new(.65,.27,.4),CFrame.new(0,.2+i*.35,0)*CFrame.Angles(0,0,math.rad(i%2==0 and 14 or -14)),cream) end
 elseif item=='fish' then
  visual(t,h,'FishBody',Vector3.new(1.1,.58,.32),CFrame.new(0,.5,0),Color3.fromRGB(89,184,204),Enum.PartType.Ball)
  visual(t,h,'Tail',Vector3.new(.35,.65,.16),CFrame.new(.64,.5,0)*CFrame.Angles(0,0,math.rad(45)),green)
  visual(t,h,'Eye',Vector3.new(.1,.1,.05),CFrame.new(-.33,.58,-.16),Color3.new(.05,.05,.05),Enum.PartType.Ball)
 else
  visual(t,h,'Tray',Vector3.new(1.5,.12,1),CFrame.new(0,.25,0),Color3.fromRGB(55,89,107))
  for i=1,5 do visual(t,h,'Seafood'..i,Vector3.new(.19,.13,.62),CFrame.new(-.6+i*.2,.38,0),i%2==0 and cream or Color3.fromRGB(242,158,137)) end
 end
 t.Parent=bag
 return true
end
local function release(p,restore)
 local s=states[p]; local photo=s and s.photo; if not photo then return end
 s.photo=nil; if occupant==p then occupant=nil end
 if photo.died then photo.died:Disconnect() end
 local c,h,r=character(p)
 if c and c==photo.character and restore then
  h.Sit=false; r.AssemblyLinearVelocity=Vector3.zero; r.AssemblyAngularVelocity=Vector3.zero; c:PivotTo(photo.returnCFrame)
 end
 send(p,{type='PhotoEnd'})
end
PPS.PromptTriggered:Connect(function(prompt,p)
 local k=kind(prompt); if not k or not near(p,prompt) then return end
 local s=state(p); if s.photo then return end
 s.prompt=prompt; s.kind=k; s.opened=os.clock()
 send(p,{type='Menu',kind=k})
end)
remote.OnServerEvent:Connect(function(p,action,item)
 if type(action)~='string' then return end
 local s=state(p)
 if action=='PhotoDone' then release(p,true); return end
 if os.clock()-s.last<.25 then return end; s.last=os.clock()
 if not s.prompt or not s.opened or os.clock()-s.opened>90 or not near(p,s.prompt) then send(p,{type='Message',key='near'}); return end
 if action=='Gift' and type(item)=='string' and items[item]==s.kind then
  local now=os.clock(); if now-(s.cooldowns[item] or -100)<10 then send(p,{type='Message',key='cooldown'}); return end
  if gift(p,item) then s.cooldowns[item]=now; send(p,{type='Message',key='gift'}) end
 elseif action=='Photo' and s.kind=='FourCuts' then
  if s.photo then return end
  if occupant then send(p,{type='Message',key='busy'}); return end
  local stand=landmarks:GetAttribute('PhotoStandPosition'); local camera=landmarks:GetAttribute('PhotoCameraPosition'); local look=landmarks:GetAttribute('PhotoLookAtPosition')
  local c,h,r=character(p)
  if not c or typeof(stand)~='Vector3' or typeof(camera)~='Vector3' or typeof(look)~='Vector3' then send(p,{type='Message',key='unavailable'}); return end
  occupant=p; local photo={character=c,returnCFrame=c:GetPivot()}; s.photo=photo
  photo.died=h.Died:Connect(function() release(p,false) end)
  h:UnequipTools(); h.Sit=false; r.AssemblyLinearVelocity=Vector3.zero; r.AssemblyAngularVelocity=Vector3.zero
  c:PivotTo(CFrame.lookAt(stand,Vector3.new(camera.X,stand.Y,camera.Z)))
  send(p,{type='PhotoStart',camera=camera,look=look})
  task.delay(19,function() if states[p] and states[p].photo==photo then release(p,true) end end)
 end
end)
Players.PlayerRemoving:Connect(function(p) release(p,false); states[p]=nil end)
