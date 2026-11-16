-- Run in Edit after a runner is stored as ServerStorage.GwangalliNPCSource.
-- 2026-11-16 Claude: source = Players:CreateHumanoidModelFromDescription(default HumanoidDescription, R15), no asset upload.
-- This file only owns Workspace.CityLife. Runtime movement lives in CityLife.server.luau.
local source = game:GetService("ServerStorage"):FindFirstChild("GwangalliNPCSource")
assert(source and source:IsA("Model") and source:FindFirstChildOfClass("Humanoid"), "Store generated R15 runner in ServerStorage.GwangalliNPCSource first")
local old = workspace:FindFirstChild("CityLife")
if old then old:Destroy() end
local city = Instance.new("Folder")
city.Name = "CityLife"
city:SetAttribute("Version", 1)
city.Parent = workspace
local function promenade(x)
	return 120 - 110 * (x/600)^2
end
local palette = {
	Color3.fromRGB(255,120,95), Color3.fromRGB(98,190,203), Color3.fromRGB(236,195,89),
	Color3.fromRGB(179,161,209), Color3.fromRGB(114,166,128), Color3.fromRGB(229,222,205),
}
local function part(name, size, color, cf, parent)
	local p=Instance.new("Part")
	p.Name=name; p.Size=size; p.Color=color; p.Material=Enum.Material.SmoothPlastic
	p.CanCollide=false; p.CanTouch=false; p.CanQuery=false; p.Massless=true; p.CFrame=cf; p.Parent=parent
	return p
end
local function weld(a,b)
	local w=Instance.new("WeldConstraint"); w.Part0=a; w.Part1=b; w.Parent=b
end
local function dog(owner, index)
	local m=Instance.new("Model"); m.Name="CompanionDog"
	local color = ({Color3.fromRGB(192,141,91),Color3.fromRGB(229,217,193),Color3.fromRGB(99,84,74),Color3.fromRGB(213,177,119)})[index]
	local body=part("Body",Vector3.new(.85,.85,1.6),color,CFrame.new(),m); body.Anchored=true
	m.PrimaryPart=body
	local head=part("Head",Vector3.new(.8,.8,.8),color,CFrame.new(0,.35,-.95),m)
	local snout=part("Muzzle",Vector3.new(.5,.35,.4),color:Lerp(Color3.new(1,1,1),.25),CFrame.new(0,.15,-1.45),m)
	part("Nose",Vector3.new(.21,.16,.12),Color3.fromRGB(37,32,31),CFrame.new(0,.2,-1.68),m)
	for _,side in {-1,1} do
		part("Ear",Vector3.new(.22,.65,.4),color:Lerp(Color3.new(),.2),CFrame.new(side*.43,.5,-.95)*CFrame.Angles(0,0,side*.2),m)
		part("Eye",Vector3.new(.08,.1,.07),Color3.fromRGB(25,23,23),CFrame.new(side*.26,.48,-1.37),m)
		for _,z in {-.5,.5} do
			local leg=part("Leg",Vector3.new(.23,.65,.25),color,CFrame.new(side*.3,-.6,z),m)
			leg:SetAttribute("Rest",leg.CFrame); leg:SetAttribute("Phase",side*(z<0 and 1 or -1))
		end
	end
	part("Tail",Vector3.new(.2,.2,.85),color,CFrame.new(0,.32,1)*CFrame.Angles(-.55,0,0),m)
	local collar=part("Collar",Vector3.new(.84,.14,.84),palette[index],CFrame.new(0,.05,-.95),m)
	for _,v in m:GetChildren() do if v:IsA("BasePart") then v.Anchored=true; v:SetAttribute("DogOffset",v.CFrame) end end
	local a=Instance.new("Attachment"); a.Position=Vector3.new(0,.12,0); a.Parent=collar
	local hand=owner:FindFirstChild("RightHand",true) or owner:FindFirstChild("Right Arm",true)
	if hand then
		local b=Instance.new("Attachment"); b.Name="LeashGrip"; b.Parent=hand
		local beam=Instance.new("Beam"); beam.Name="Leash"; beam.Attachment0=a; beam.Attachment1=b
		beam.Width0=.045; beam.Width1=.045; beam.FaceCamera=true; beam.Color=ColorSequence.new(Color3.fromRGB(92,70,50))
		beam.CurveSize0=-.35; beam.CurveSize1=.3; beam.Segments=8; beam.Parent=collar
	end
	m.Parent=owner
	return m
end
local roles={"Runner","DogWalker","Photographer","Runner","Stroller","DogWalker","Runner","Photographer","DogWalker","Runner","Stroller","Photographer","Runner","DogWalker"}
local dogIndex=0
for i,role in roles do
	local npc=source:Clone(); npc.Name=role..string.format("%02d",i)
	for _,v in npc:GetDescendants() do
		if v:IsA("LuaSourceContainer") then v:Destroy()
		elseif v:IsA("BasePart") then v.Anchored=false; v.CanTouch=false; v.CanCollide=false; v.Massless=true end
	end
	-- 2026-11-16 Claude: default R15 rig (no upload) is plain grey, so paint varied tops/bottoms/skin per person.
	local bc=npc:FindFirstChildOfClass("BodyColors"); if bc then bc:Destroy() end
	local skins={Color3.fromRGB(255,224,189),Color3.fromRGB(234,192,158),Color3.fromRGB(198,149,112),Color3.fromRGB(141,98,71)}
	local tops={Color3.fromRGB(242,242,236),Color3.fromRGB(38,57,92),Color3.fromRGB(214,92,84),Color3.fromRGB(93,140,113),Color3.fromRGB(240,196,92),Color3.fromRGB(122,108,170),Color3.fromRGB(55,55,60)}
	local bottoms={Color3.fromRGB(40,48,66),Color3.fromRGB(74,74,80),Color3.fromRGB(196,180,150),Color3.fromRGB(28,30,34),Color3.fromRGB(88,112,150)}
	local skin,top,bottom=skins[(i-1)%#skins+1],tops[(i*3-1)%#tops+1],bottoms[(i*2-1)%#bottoms+1]
	for _,v in npc:GetDescendants() do if v:IsA("BasePart") and v.Name~="HumanoidRootPart" then
		if v.Name=="Head" or v.Name:find("Hand") then v.Color=skin
		elseif v.Name:find("Torso") or v.Name:find("Arm") then v.Color=top
		elseif v.Name:find("Leg") or v.Name:find("Foot") then v.Color=bottom end
	end end
	local hum=npc:FindFirstChildOfClass("Humanoid")
	hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None; hum.HealthDisplayType=Enum.HumanoidHealthDisplayType.AlwaysOff
	hum.BreakJointsOnDeath=false; hum.AutoJumpEnabled=false; hum.JumpPower=0; hum.WalkSpeed=role=="Runner" and 11.5 or 5.2
	local root=npc:FindFirstChild("HumanoidRootPart")
	assert(root,"Generated avatar needs HumanoidRootPart")
	root.Massless=false; root.CanCollide=true
	npc.PrimaryPart=root
	-- Garments are baked into the generated character; add individual lightweight accents.
	local head=npc:FindFirstChild("Head",true)
	if head then
		local cap=part("ColoredCap",Vector3.new(1.03,.18,1.03),palette[(i-1)%#palette+1],head.CFrame*CFrame.new(0,.52,0),npc)
		weld(head,cap)
		local brim=part("CapBrim",Vector3.new(.85,.07,.55),cap.Color,head.CFrame*CFrame.new(0,.45,-.55),npc); weld(head,brim)
	end
	local torso=npc:FindFirstChild("UpperTorso",true)
	if torso then
		local accent=part("OutfitAccent",Vector3.new(1.52,.32,.08),palette[(i-1)%#palette+1],torso.CFrame*CFrame.new(0,-.3,-.48),npc)
		weld(torso,accent)
	end
	local x=-510+(i-1)*78
	local lane=(i%2==0 and 3.8 or -3.8)
	npc:SetAttribute("Role",role); npc:SetAttribute("Lane",lane); npc:SetAttribute("StartX",x)
	npc:SetAttribute("Direction",i%2==0 and 1 or -1); npc:SetAttribute("PersonIndex",i)
	local floorHeight=hum.HipHeight+root.Size.Y/2+3.12
	npc:SetAttribute("RootFloorHeight",floorHeight)
	npc:PivotTo(CFrame.new(x,floorHeight,promenade(x)+lane))
	if role=="DogWalker" then
		dogIndex+=1; local companion=dog(npc,dogIndex)
		companion:PivotTo(root.CFrame*CFrame.new(2.1,-floorHeight+4.2,-1.2))
	elseif role=="Photographer" then
		local hand=npc:FindFirstChild("RightHand",true)
		if hand then
			local phone=part("CameraPhone",Vector3.new(.4,.73,.065),Color3.fromRGB(30,34,40),hand.CFrame*CFrame.new(0,-.1,-.18),npc); weld(hand,phone)
			local light=Instance.new("PointLight"); light.Name="ShutterGlow"; light.Brightness=0; light.Range=5; light.Color=Color3.fromRGB(255,244,224); light.Parent=phone
		end
	end
	npc.Parent=city
	task.wait(.05)
end
return "Created "..#roles.." promenade residents: 5 runners, 4 dog walkers, 3 photographers, 2 strollers"
