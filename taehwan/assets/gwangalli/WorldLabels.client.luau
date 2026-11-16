-- Per-viewer localization for physical shop signs, menus and prompts.
local Players=game:GetService('Players')
local player=Players.LocalPlayer
local signKeys={['Cafe name']='cafe',['Boutique name']='boutique',['Arcade marquee']='arcade',['Hotel name']='hotel',['Coffee menu']='menu',['Gift guide']='gifts',['Arcade rules']='rules',['Reception label']='reception',['Elevator label']='elevator',['Rooftop wayfinding']='rooftop',['OrderCounter']='order'}
local modelKeys={['01 Tide Cup Cafe']='cafe',['02 Sea Letter Boutique']='boutique',['03 Bubble Catch Arcade']='arcade',['04 Horizon House Hotel']='hotel'}
local text={
 ko={cafe='타이드 컵 카페',boutique='바다 편지 소품샵',arcade='버블 캐치 오락실',hotel='호라이즌 하우스 호텔',menu='시트러스 아이스티  8\n딸기 라테  12',gifts='엽서 · 바다 기념품',rules='인형 뽑기 · 매회 토큰 5개',reception='어서 오세요 · 프런트',elevator='루프톱으로 ↑',rooftop='전망 테라스 · 로비로 ↓',order='주문하는 곳',CafeOrder='음료 주문',Souvenir='기념품 보기',ClawPlay='인형 뽑기',HotelCheckIn='체크인',HotelRooftop='루프톱으로',HotelLobby='로비로',oliveyoung='OLIVE YOUNG\n뷰티·헬스 스토어',samjin='삼진어묵\n어묵 먹거리 체험',fourcuts='인생네컷\n네 장의 추억',millak='민락회센터\n해산물과 바다 전망',BeautySample='뷰티 체험',FishCakeOrder='어묵 고르기',FourCuts='네컷 사진 찍기',SeafoodSample='먹거리 구경'},
 en={cafe='TIDE CUP CAFÉ',boutique='SEA LETTER GIFTS',arcade='BUBBLE CATCH ARCADE',hotel='HORIZON HOUSE HOTEL',menu='CITRUS ICED TEA  8\nSTRAWBERRY LATTE  12',gifts='POSTCARDS · SEASIDE GIFTS',rules='CLAW GAME · 5 TOKENS PER PLAY',reception='WELCOME · RECEPTION',elevator='ROOFTOP ↑',rooftop='VIEW TERRACE · LOBBY ↓',order='ORDER HERE',CafeOrder='Order drinks',Souvenir='Browse gifts',ClawPlay='Play claw',HotelCheckIn='Check in',HotelRooftop='Visit rooftop',HotelLobby='Return to lobby',oliveyoung='OLIVE YOUNG\nBeauty & Health',samjin='SAMJIN FISH CAKE\nTaste of Busan',fourcuts='LIFE FOUR CUTS\nFour-photo booth',millak='MILLAK SEAFOOD CENTER\nSeafood & Ocean Views',BeautySample='Beauty experience',FishCakeOrder='Choose fish cake',FourCuts='Take four photos',SeafoodSample='Explore seafood'},
 ja={cafe='タイドカップ カフェ',boutique='シーレター 雑貨店',arcade='バブルキャッチ ゲームセンター',hotel='ホライゾンハウス ホテル',menu='シトラスアイスティー  8\nいちごラテ  12',gifts='ポストカード · 海辺のお土産',rules='クレーンゲーム · 1回5トークン',reception='ようこそ · フロント',elevator='屋上へ ↑',rooftop='展望テラス · ロビーへ ↓',order='ご注文はこちら',CafeOrder='飲み物を注文',Souvenir='お土産を見る',ClawPlay='クレーンで遊ぶ',HotelCheckIn='チェックイン',HotelRooftop='屋上へ',HotelLobby='ロビーへ',oliveyoung='OLIVE YOUNG\nビューティー＆ヘルス',samjin='サムジンオムク\n釜山のおでん体験',fourcuts='人生4カット\n4枚の思い出写真',millak='民楽刺身センター\n海の幸とオーシャンビュー',BeautySample='ビューティー体験',FishCakeOrder='おでんを選ぶ',FourCuts='4カットを撮る',SeafoodSample='海の幸を見る'},
 ['zh-cn']={cafe='潮杯咖啡馆',boutique='海边来信礼品店',arcade='泡泡抓抓游乐厅',hotel='地平线之家酒店',menu='柑橘冰茶  8\n草莓拿铁  12',gifts='明信片 · 海边纪念品',rules='抓娃娃 · 每次5枚代币',reception='欢迎光临 · 前台',elevator='前往屋顶 ↑',rooftop='观景露台 · 返回大厅 ↓',order='在此点单',CafeOrder='点饮品',Souvenir='选购纪念品',ClawPlay='抓娃娃',HotelCheckIn='办理入住',HotelRooftop='前往屋顶',HotelLobby='返回大厅',oliveyoung='OLIVE YOUNG\n美妆与健康',samjin='三进鱼糕\n釜山风味体验',fourcuts='人生四格\n四张回忆照片',millak='民乐生鱼片中心\n海鲜与海景',BeautySample='美妆体验',FishCakeOrder='挑选鱼糕',FourCuts='拍四格照片',SeafoodSample='逛海鲜市场'},
 ['zh-tw']={cafe='潮杯咖啡館',boutique='海邊來信禮品店',arcade='泡泡夾夾遊樂場',hotel='地平線之家飯店',menu='柑橘冰茶  8\n草莓拿鐵  12',gifts='明信片 · 海邊紀念品',rules='夾娃娃 · 每次5枚代幣',reception='歡迎光臨 · 櫃檯',elevator='前往屋頂 ↑',rooftop='觀景露台 · 返回大廳 ↓',order='在此點餐',CafeOrder='點飲品',Souvenir='選購紀念品',ClawPlay='夾娃娃',HotelCheckIn='辦理入住',HotelRooftop='前往屋頂',HotelLobby='返回大廳',oliveyoung='OLIVE YOUNG\n美妝與健康',samjin='三進魚糕\n釜山風味體驗',fourcuts='人生四格\n四張回憶照片',millak='民樂生魚片中心\n海鮮與海景',BeautySample='美妝體驗',FishCakeOrder='挑選魚糕',FourCuts='拍四格照片',SeafoodSample='逛海鮮市場'}
}
local lang='ko'
local labels,prompts={},{}
local function translate(key)return text[lang][key]or text.en[key]end
local function storeOf(instance)
 local node=instance
 while node and node~=workspace do
  local key=node:GetAttribute('StoreKey')or modelKeys[node.Name]
  if key then return key end
  node=node.Parent
 end
end
local function applyLabel(label,key)
 if not label.Parent then labels[label]=nil;return end
 local value=translate(key);if value then label.Text=value end
end
local function applyPrompt(prompt)
 if not prompt.Parent then prompts[prompt]=nil;return end
 local kind=prompt.Parent:GetAttribute('InteractionKind')or prompt.Parent:GetAttribute('LandmarkKind')
 local value=kind and translate(kind);if value then prompt.ActionText=value end
 local store=storeOf(prompt);local name=store and translate(store)
 if name then prompt.ObjectText=name:match('^[^\n]+')end
end
local function register(instance)
 if instance:IsA('TextLabel')and instance.Parent and instance.Parent:IsA('SurfaceGui')then
  local part=instance.Parent.Parent
  local key=part and (signKeys[part.Name]or(part.Name=='StoreNameSign'and storeOf(part)))
  if key then labels[instance]=key;applyLabel(instance,key)end
 elseif instance:IsA('ProximityPrompt')then
  local parent=instance.Parent
  if parent and(parent:GetAttribute('InteractionKind')or parent:GetAttribute('LandmarkKind'))then prompts[instance]=true;applyPrompt(instance)end
 end
end
for _,o in workspace:GetDescendants()do register(o)end
workspace.DescendantAdded:Connect(register)
local function refresh()
 for label,key in labels do applyLabel(label,key)end
 for prompt in prompts do applyPrompt(prompt)end
end
local function watch(tour)
 if tour.Name~='GwangalliTour'then return end
 local function languageChanged()
  local selected=tour:GetAttribute('Language')
  if text[selected]then lang=selected end
  refresh()
 end
 tour:GetAttributeChangedSignal('Language'):Connect(languageChanged);languageChanged()
end
player.PlayerGui.ChildAdded:Connect(watch)
local tour=player.PlayerGui:FindFirstChild('GwangalliTour');if tour then watch(tour)end
