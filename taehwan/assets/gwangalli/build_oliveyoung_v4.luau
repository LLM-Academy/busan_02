-- EDIT-TIME ONLY. 2026-11-16 Claude, round 1 (shell) of the Olive Young Millac-the-Market style rebuild.
-- Reference (proportion/mood only, no photo textures): research/2026-11-16-올리브영-모델링-참고이미지.md
-- 1) Swap places: SamjinFishCake -> west end (x -520), OliveYoung -> next to MillakFishCenter (x 360).
-- 2) Old OliveYoung box is archived to ServerStorage.GwangalliLandmarksArchive (not destroyed).
-- 3) New shell: warehouse volume, red brick west wall, glass front, black steel trusses,
--    rear mezzanine with brick parapet, black rail, 올영호 banners, east stair. Keeps BeautySample counter.
local L = workspace:FindFirstChild("GwangalliLandmarks")
assert(L, "GwangalliLandmarks missing")
local SS = game:GetService("ServerStorage")

-- swap ---------------------------------------------------------------
local samjin = L:FindFirstChild("SamjinFishCake")
if samjin and (samjin:GetAttribute("FrontPosition") or Vector3.zero).X > 0 then
	samjin:PivotTo(samjin:GetPivot() + Vector3.new(-880, 0, 0))
	samjin:SetAttribute("FrontPosition", Vector3.new(-520, 3, 195))
end
local old = L:FindFirstChild("OliveYoung")
if old and old:GetAttribute("BuildVersion") then old:Destroy(); old = nil end -- rerun: replace our own v4 build
if old then
	local archive = SS:FindFirstChild("GwangalliLandmarksArchive") or Instance.new("Folder")
	archive.Name = "GwangalliLandmarksArchive"; archive.Parent = SS
	local prev = archive:FindFirstChild("OliveYoung_v3"); if prev then prev:Destroy() end
	old.Name = "OliveYoung_v3"; old.Parent = archive
end

-- helpers --------------------------------------------------------------
local C = {
	brick = Color3.fromRGB(176, 84, 62), steel = Color3.fromRGB(28, 30, 33),
	concrete = Color3.fromRGB(196, 198, 196), charcoal = Color3.fromRGB(46, 49, 53),
	white = Color3.fromRGB(244, 244, 238), glass = Color3.fromRGB(175, 214, 222),
	green = Color3.fromRGB(46, 158, 79), lamp = Color3.fromRGB(255, 248, 232),
}
local X, Z = 360, 195
local cf = CFrame.new(X, 3, Z) -- floor top at world Y=3, front plane z=0, interior +z
local m = Instance.new("Model"); m.Name = "OliveYoung"
m:SetAttribute("FictionalRecreation", true); m:SetAttribute("StoreKey", "oliveyoung")
m:SetAttribute("FrontPosition", Vector3.new(X, 3, Z)); m:SetAttribute("BuildVersion", "v4-round1")
local count = 0
local function part(name, size, pos, color, material, rot, class)
	local p = Instance.new(class or "Part")
	p.Name = name; p.Size = size; p.CFrame = cf * CFrame.new(pos) * (rot or CFrame.identity)
	p.Anchored = true; p.Color = color or C.white; p.Material = material or Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
	p.Parent = m; count += 1
	return p
end
local function label(p, text, ink, rich)
	local gui = Instance.new("SurfaceGui"); gui.Face = Enum.NormalId.Front
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud; gui.PixelsPerStud = math.min(35, 95 / p.Size.Y)
	gui.LightInfluence = 0.35; gui.Parent = p
	local t = Instance.new("TextLabel"); t.Name = "StoreTitle"; t.Size = UDim2.fromScale(1, 1)
	t.BackgroundTransparency = 1; t.TextColor3 = ink or C.white; t.Font = Enum.Font.GothamBlack
	t.TextScaled = true; t.TextWrapped = true; t.RichText = rich or false; t.Text = text; t.Parent = gui
	local pad = Instance.new("UIPadding"); pad.PaddingTop = UDim.new(0.12, 0); pad.PaddingBottom = UDim.new(0.12, 0)
	pad.PaddingLeft = UDim.new(0.04, 0); pad.PaddingRight = UDim.new(0.04, 0); pad.Parent = t
	return t
end
local function glass(name, size, pos)
	local p = part(name, size, pos, C.glass, Enum.Material.Glass)
	p.Transparency = 0.65; p.CanCollide = true; p.CastShadow = false
	return p
end
local function lamp(pos, range)
	local p = part("CeilingLamp", Vector3.new(6, 0.3, 1.2), pos, C.lamp, Enum.Material.Neon)
	p.CanCollide = false
	local l = Instance.new("PointLight"); l.Color = C.lamp; l.Brightness = 0.9; l.Range = range or 45; l.Shadows = false; l.Parent = p
end

local W, D, H = 100, 60, 36 -- width, depth, height (two storeys)

-- envelope ---------------------------------------------------------------
part("Floor", Vector3.new(W, 1, D), Vector3.new(0, -0.5, D / 2), C.concrete, Enum.Material.Concrete)
part("WestBrickWall", Vector3.new(1, H, D), Vector3.new(-W / 2 - 0.5, H / 2, D / 2), C.brick, Enum.Material.Brick)
part("EastWall", Vector3.new(1, H, D), Vector3.new(W / 2 + 0.5, H / 2, D / 2), C.charcoal, Enum.Material.Concrete)
part("RearWall", Vector3.new(W + 2, H, 1), Vector3.new(0, H / 2, D + 0.5), C.charcoal, Enum.Material.Concrete)
part("Roof", Vector3.new(W + 4, 1, D + 4), Vector3.new(0, H + 0.5, D / 2), C.steel, Enum.Material.Slate)

-- glass storefront, open 18-stud door in the middle ------------------------
for _, x in ipairs({ -50, -30, -9, 9, 30, 50 }) do
	part("FrontMullion", Vector3.new(1, 24, 1), Vector3.new(x, 12, 0), C.steel, Enum.Material.Metal)
end
for _, s in ipairs({ { -40, 19 }, { -19.5, 20 }, { 19.5, 20 }, { 40, 19 } }) do
	glass("ShopWindow", Vector3.new(s[2], 24, 0.4), Vector3.new(s[1], 12, 0))
end
glass("DoorTransom", Vector3.new(18, 12, 0.4), Vector3.new(0, 18, 0))
part("FrontFascia", Vector3.new(W + 2, H - 24, 1), Vector3.new(0, 24 + (H - 24) / 2, 0), C.charcoal, Enum.Material.Concrete)
local sign = part("StoreNameSign", Vector3.new(70, 7, 0.6), Vector3.new(0, 30, -0.8), C.charcoal)
sign:SetAttribute("StoreKey", "oliveyoung")
label(sign, "OLIVE YOUNG  /  올리브영", C.white)

-- black steel trusses (shallow gable) and purlins ---------------------------
local slope = math.atan(5 / (W / 2))
local chordLen = math.sqrt((W / 2) ^ 2 + 25)
for _, z in ipairs({ 8, 20, 32, 44, 56 }) do
	part("TrussBottomChord", Vector3.new(W, 0.8, 0.8), Vector3.new(0, 30, z), C.steel, Enum.Material.Metal)
	part("TrussTopChord", Vector3.new(chordLen, 0.8, 0.8), Vector3.new(-W / 4, 32.5, z), C.steel, Enum.Material.Metal, CFrame.Angles(0, 0, slope))
	part("TrussTopChord", Vector3.new(chordLen, 0.8, 0.8), Vector3.new(W / 4, 32.5, z), C.steel, Enum.Material.Metal, CFrame.Angles(0, 0, -slope))
	for _, x in ipairs({ -30, -15, 0, 15, 30 }) do
		local h = 5 - math.abs(x) / 10
		part("TrussWeb", Vector3.new(0.5, h, 0.5), Vector3.new(x, 30 + h / 2, z), C.steel, Enum.Material.Metal)
	end
end
for _, x in ipairs({ -40, -20, 0, 20, 40 }) do
	part("Purlin", Vector3.new(0.6, 0.6, D), Vector3.new(x, 35.3 - math.abs(x) / 10, D / 2), C.steel, Enum.Material.Metal)
end
for _, x in ipairs({ -32, 0, 32 }) do for _, z in ipairs({ 8, 20, 32 }) do lamp(Vector3.new(x, 29.2, z), 55) end end

-- rear mezzanine (floor top local Y=16, world Y=19) ------------------------
local MZ, MY = 38, 16 -- front edge z, floor top
part("MezzanineFloor", Vector3.new(W, 1, D - MZ), Vector3.new(0, MY - 0.5, MZ + (D - MZ) / 2), C.concrete, Enum.Material.Concrete)
part("MezzanineBrickParapet", Vector3.new(W, 3, 1), Vector3.new(0, MY - 1.5, MZ - 0.5), C.brick, Enum.Material.Brick)
for _, x in ipairs({ -35, -10, 15 }) do
	part("SteelColumn", Vector3.new(1.2, MY - 3, 1.2), Vector3.new(x, (MY - 3) / 2, MZ - 0.5), C.steel, Enum.Material.Metal)
end
-- railing leaves the stair landing (x 39..49) open
local railFrom, railTo = -W / 2, 39
part("RailTop", Vector3.new(railTo - railFrom, 0.35, 0.35), Vector3.new((railFrom + railTo) / 2, MY + 3.4, MZ - 0.6), C.steel, Enum.Material.Metal)
part("RailBottom", Vector3.new(railTo - railFrom, 0.25, 0.25), Vector3.new((railFrom + railTo) / 2, MY + 0.3, MZ - 0.6), C.steel, Enum.Material.Metal)
for x = railFrom + 1.5, railTo - 0.5, 3 do
	part("RailBaluster", Vector3.new(0.18, 3.2, 0.18), Vector3.new(x, MY + 1.8, MZ - 0.6), C.steel, Enum.Material.Metal)
end
local rail = part("RailGuard", Vector3.new(railTo - railFrom, 3.6, 0.2), Vector3.new((railFrom + railTo) / 2, MY + 1.8, MZ - 0.6), C.steel)
rail.Transparency = 1 -- invisible collision so players cannot fall through balusters
for _, x in ipairs({ -28, 8 }) do
	local b = part("OlyoungBanner", Vector3.new(14, 3.2, 0.25), Vector3.new(x, MY + 1.6, MZ - 0.85), C.white)
	b.CanCollide = false
	label(b, '<font color="#2E9E4F">올</font><font color="#D7322E">영</font><font color="#2E9E4F">호</font>', C.green, true)
end
for _, x in ipairs({ -32, 0, 28 }) do lamp(Vector3.new(x, MY - 3.4, MZ + 10), 35) end
for _, x in ipairs({ -25, 15 }) do lamp(Vector3.new(x, 29.2, MZ + 12), 40) end

-- stair on the east side: 16 risers of 1 stud, landing on the mezzanine edge
for i = 1, MY do
	part("WalkableStair", Vector3.new(10, i, 1.125), Vector3.new(44, i / 2, 20 + (i - 0.5) * 1.125), C.charcoal, Enum.Material.Concrete)
end
part("StairHandrail", Vector3.new(0.35, 0.35, math.sqrt(18 ^ 2 + 16 ^ 2)), Vector3.new(38.8, MY / 2 + 3.2, 29), C.steel, Enum.Material.Metal, CFrame.Angles(-math.atan(16 / 18), 0, 0))

-- keep the existing free-sample interaction (LandmarkActivities expects LandmarkKind=BeautySample)
local counter = part("BeautySampleCheckout", Vector3.new(20, 4, 7), Vector3.new(26, 2, 12), C.green)
counter:SetAttribute("LandmarkKind", "BeautySample")
local q = Instance.new("ProximityPrompt"); q.Name = "BeautySample"; q.ActionText = "뷰티 샘플 받기"; q.ObjectText = "올리브영"
q.HoldDuration = 0.2; q.MaxActivationDistance = 12; q.RequiresLineOfSight = false; q.Parent = counter
part("Register", Vector3.new(3, 2.5, 2), Vector3.new(30, 5.2, 12), C.steel, nil, CFrame.Angles(-0.2, 0, 0))

assert(count <= 600, "Olive Young part budget exceeded: " .. count)
m:SetAttribute("BasePartCount", count)
m.Parent = L
return "OliveYoung v4 round1: " .. count .. " parts; Samjin at " .. tostring(samjin and samjin:GetAttribute("FrontPosition"))
