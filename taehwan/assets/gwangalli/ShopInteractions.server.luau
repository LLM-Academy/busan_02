-- Session-only shop interactions. Install in ServerScriptService.
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ProximityPromptService = game:GetService('ProximityPromptService')
local TweenService = game:GetService('TweenService')
local DrinkInteraction = require(script.Parent:WaitForChild('GwangalliDrinkInteraction'))
local world = workspace:WaitForChild('GwangalliExperience')
local shops = world:WaitForChild('ShopsV2')
local remote = ReplicatedStorage:FindFirstChild('GwangalliShopRemote')
if remote and not remote:IsA('RemoteEvent') then remote:Destroy(); remote = nil end
if not remote then remote = Instance.new('RemoteEvent'); remote.Name = 'GwangalliShopRemote'; remote.Parent = ReplicatedStorage end

local sessions, locks = {}, {}
local random = Random.new()
local validKinds = {CafeOrder=true, Souvenir=true, ClawPlay=true, HotelCheckIn=true, HotelRooftop=true, HotelLobby=true}
local actions = {
 cafe_tea={kind='CafeOrder', price=8, item='tea'},
 cafe_latte={kind='CafeOrder', price=12, item='latte'},
 souvenir_shell={kind='Souvenir', price=15, item='shell'},
 claw_play={kind='ClawPlay', price=5},
 hotel_checkin={kind='HotelCheckIn', price=20},
 hotel_rooftop={kind='HotelRooftop', price=0},
}
local function session(player)
 if not sessions[player] then sessions[player] = {balance=100, checkedIn=false, lastPrompt=0, lastRequest=0} end
 return sessions[player]
end
local function kindOf(prompt)
 if not prompt:IsA('ProximityPrompt') or not prompt:IsDescendantOf(shops) then return nil end
 local parent = prompt.Parent
 if not parent or not parent:IsA('BasePart') then return nil end
 local kind = parent:GetAttribute('InteractionKind') or prompt:GetAttribute('InteractionKind')
 if validKinds[kind] then return kind end
end
local function nearby(player, prompt)
 if not prompt or not prompt.Parent or not prompt.Enabled or not kindOf(prompt) then return false end
 local character = player.Character
 local root = character and character:FindFirstChild('HumanoidRootPart')
 local humanoid = character and character:FindFirstChildOfClass('Humanoid')
 return root and humanoid and humanoid.Health > 0 and (root.Position-prompt.Parent.Position).Magnitude <= 18
end
local function send(player, status, message, kind)
 if player.Parent ~= Players then return end
 local s = session(player)
 remote:FireClient(player, {status=status, message=message, kind=kind, balance=s.balance, checkedIn=s.checkedIn})
end
local function teleport(player, attribute)
 local destination = shops:GetAttribute(attribute)
 local character = player.Character
 local root = character and character:FindFirstChild('HumanoidRootPart')
 local humanoid = character and character:FindFirstChildOfClass('Humanoid')
 if typeof(destination) ~= 'Vector3' or not root or not humanoid then return false end
 humanoid.Sit = false
 root.AssemblyLinearVelocity = Vector3.zero
 root.AssemblyAngularVelocity = Vector3.zero
 character:PivotTo(CFrame.new(destination + Vector3.new(0, 3, 0)))
 return true
end
local function part(parent, name, size, color, relative, handle, shape)
 local p = Instance.new('Part')
 p.Name=name; p.Size=size; p.Color=color; p.CanCollide=false; p.CanTouch=false; p.Massless=true
 p.Material=Enum.Material.SmoothPlastic
 if shape then p.Shape=shape end
 p.CFrame=handle.CFrame * relative; p.Parent=parent
 local weld=Instance.new('WeldConstraint'); weld.Part0=handle; weld.Part1=p; weld.Parent=p
 return p
end
local function giveItem(player, item)
 local backpack = player:FindFirstChildOfClass('Backpack')
 if not backpack then return false end
 local tool=Instance.new('Tool'); tool.CanBeDropped=false; tool.RequiresHandle=true
 tool.Name=({tea='Ocean Citrus Tea',latte='Beach Strawberry Latte',shell='Gwangalli Shell Keychain',bear='Seaside Plush Bear'})[item]
 tool.ToolTip='Gwangalli · session souvenir'
 local handle=Instance.new('Part'); handle.Name='Handle'; handle.CanCollide=false; handle.CanTouch=false; handle.Massless=true
 handle.Material=Enum.Material.SmoothPlastic; handle.Parent=tool
 if item=='tea' or item=='latte' then
  handle.Size=Vector3.new(.2,.65,.2);handle.Transparency=1
  local color=item=='tea' and Color3.fromRGB(244,177,49) or Color3.fromRGB(238,132,165)
  part(tool,'UprightCup',Vector3.new(.9,.65,.65),Color3.fromRGB(255,244,218),CFrame.Angles(0,0,math.pi/2),handle,Enum.PartType.Cylinder)
  local liquid=part(tool,'DrinkLiquid',Vector3.new(.72,.61,.61),color,CFrame.new(0,.04,0)*CFrame.Angles(0,0,math.pi/2),handle,Enum.PartType.Cylinder);liquid.Transparency=.15
  part(tool,'DrinkLid',Vector3.new(.08,.72,.72),color,CFrame.new(0,.48,0)*CFrame.Angles(0,0,math.pi/2),handle,Enum.PartType.Cylinder)
  part(tool,'Straw',Vector3.new(.055,.62,.055),Color3.fromRGB(72,161,147),CFrame.new(-.16,.8,0),handle)
 else
  handle.Size=item=='shell' and Vector3.new(.65,.65,.25) or Vector3.new(.65,.8,.45)
  handle.Shape=Enum.PartType.Ball; handle.Color=item=='shell' and Color3.fromRGB(255,194,166) or Color3.fromRGB(185,135,94)
  if item=='bear' then
   part(tool,'Head',Vector3.new(.65,.6,.5),handle.Color,CFrame.new(0,.55,0),handle,Enum.PartType.Ball)
   for _,x in {-.25,.25} do
    part(tool,'Ear',Vector3.new(.24,.24,.2),handle.Color,CFrame.new(x,.85,0),handle,Enum.PartType.Ball)
    part(tool,'Eye',Vector3.new(.065,.065,.045),Color3.fromRGB(35,49,51),CFrame.new(x*.55,.6,-.25),handle,Enum.PartType.Ball)
   end
   part(tool,'Scarf',Vector3.new(.68,.15,.5),Color3.fromRGB(62,178,170),CFrame.new(0,.3,0),handle)
  else
   part(tool,'KeyRing',Vector3.new(.16,.4,.16),Color3.fromRGB(236,204,122),CFrame.new(0,.5,0),handle,Enum.PartType.Cylinder)
  end
 end
 tool.Grip=CFrame.new(0,-.3,0)
 if item=='tea' or item=='latte' then DrinkInteraction.Configure(tool,player,function(message)send(player,'notice',message)end) end
 tool.Parent=backpack
 local humanoid=player.Character and player.Character:FindFirstChildOfClass('Humanoid')
 if humanoid and humanoid.Health>0 then humanoid:EquipTool(tool) end
 return true
end
local function machineFor(prompt)
 local node=prompt.Parent
 while node and node~=shops do
  if node:FindFirstChild('Claw',true) then return node end
  node=node.Parent
 end
 return prompt.Parent
end
local function animateClaw(machine)
 local claw=machine:FindFirstChild('Claw',true)
 local parts={}
 if claw then
  if claw:IsA('BasePart') and claw.Anchored then table.insert(parts,claw) end
  for _,child in claw:GetDescendants() do
   if child:IsA('BasePart') and child.Anchored then table.insert(parts,child) end
  end
 end
 local origins={}
 for _,p in parts do origins[p]=p.CFrame; TweenService:Create(p,TweenInfo.new(.65),{CFrame=p.CFrame+Vector3.new(0,-1.2,0)}):Play() end
 task.wait(.85)
 for p,origin in origins do if p.Parent then TweenService:Create(p,TweenInfo.new(.65),{CFrame=origin}):Play() end end
 task.wait(.75)
end

ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
 local kind=kindOf(prompt)
 if not kind or not nearby(player,prompt) then return end
 local s=session(player); local now=os.clock()
 if now-s.lastPrompt<.6 or s.busy then return end
 s.lastPrompt=now
 if kind=='HotelLobby' then
  if teleport(player,'HotelLobbyPosition') then send(player,'result','lobby') else send(player,'error','unavailable') end
  return
 end
 if kind=='HotelRooftop' and s.checkedIn then
  if teleport(player,'HotelRooftopPosition') then send(player,'result','rooftop') else send(player,'error','unavailable') end
  return
 end
 s.prompt=prompt; s.opened=now
 send(player,'open',nil,kind)
end)
remote.OnServerEvent:Connect(function(player, action)
 if type(action)~='string' or #action>32 then return end
 local spec=actions[action]; if not spec then return end
 local s=session(player); local now=os.clock()
 if now-s.lastRequest<.5 or s.busy then return end
 s.lastRequest=now
 local prompt=s.prompt; local kind=prompt and kindOf(prompt)
 if not s.opened or now-s.opened>90 or not nearby(player,prompt) then send(player,'error','too_far'); return end
 local hotelKind=kind=='HotelCheckIn' or kind=='HotelRooftop'
 if kind~=spec.kind and not (action=='hotel_checkin' and hotelKind) and not (action=='hotel_rooftop' and hotelKind) then return end
 if action=='hotel_rooftop' then
  if not s.checkedIn then send(player,'error','need_checkin'); return end
  if teleport(player,'HotelRooftopPosition') then send(player,'result','rooftop') else send(player,'error','unavailable') end
  return
 end
 if action=='hotel_checkin' and s.checkedIn then send(player,'result','already_checked_in',kind); return end
 if s.balance<spec.price then send(player,'error','insufficient'); return end
 if action=='claw_play' then
  local machine=machineFor(prompt)
  if locks[machine] then send(player,'error','machine_busy'); return end
  locks[machine]=true; s.busy=true; s.balance-=spec.price
  send(player,'busy','playing',kind)
  task.spawn(function()
   local ok,err=pcall(function()
    animateClaw(machine)
    if player.Parent~=Players then return end
    local won=random:NextNumber()<.5
    if won and not giveItem(player,'bear') then error('Backpack unavailable') end
    send(player,'result',won and 'claw_win' or 'claw_miss',kind)
   end)
   locks[machine]=nil; s.busy=false
   if not ok then
    s.balance+=spec.price
    send(player,'error','refunded',kind)
    warn('Gwangalli claw interaction: '..tostring(err))
   end
  end)
 elseif action=='hotel_checkin' then
  s.balance-=spec.price; s.checkedIn=true
  send(player,'result','checked_in',kind)
 else
  if giveItem(player,spec.item) then
   s.balance-=spec.price
   send(player,'result',spec.item=='shell' and 'souvenir_received' or 'drink_received',kind)
  else send(player,'error','unavailable') end
 end
end)
Players.PlayerRemoving:Connect(function(player) sessions[player]=nil end)
