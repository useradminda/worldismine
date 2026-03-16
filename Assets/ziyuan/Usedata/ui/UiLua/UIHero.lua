UIHero={}
UIHero=BasePanel:new()
local this = UIHero
UIHero.UIHeroGob = nil
UIHero.PressTimeDel = 0.1
UIHero.HeroUpGradePanel=nil
UIHero.HeroInfoPanel=nil
UIHero.HeroTrainPanel=nil

UIHero.HeroInfoControls={}
UIHero.HeroTrainControls={}
UIHero.HeroUpGradeControls={}

UIHero.ClickTempHeroIndex=0 --当前点击的那个英雄

UIHero.GuaShuaiHeroIndex=0--当前挂帅的那个武将

UIHero.HeroList= {}
UIHero.HeroGodList = {}
UIHero.HeroTempGodList = {} --用于第二次显示

UIHero.HeroMatList = {}			--转生材料
UIHero.HeroMatGodList = {}		

UIHero.HeroMatClickIndex = 0  --武将转生所需材质的点击Index
UIHero.ChooseHeroMat = nil --武将转生选择的转生材料
UIHero.ChooseHeroMatList = {} --武将转生选择的武将材料列表


UIHero.HeroBagList = {}
UIHero.HeroBagGodList = {}
UIHero.HeroTeamGridGod = {}		--选择的add材料list
UIHero.HeroUpGradeMatNum = 0	--进阶需要的材料数目
UIHero.CurTrainCount = 0		--当前训练的个数
UIHero.TrainLimitCount = 0		--训练个数的上限

UIHero.TempHeroEquipUUIDs = {}--当前点击的武将的装备原始UUID
UIHero.HeroEquipGod = --装备， 根据装备类型来定义
{
	[1] = nil, --装备
	[2] = nil, --头
	[3] = nil, --胸
	[4] = nil, --护腕
	[5] = nil, --鞋子
	[6] = nil, --披风
	[7] = nil, --护符
	[8] = nil, --戒指
} 

UIHero.HeroTrainGodList = {}

UIHero.TempHeroModel = nil		--显示的武将模型

UIHero.GoAtkMaxCount = 5			--出站人数最多5位
UIHero.GoAtkCount = 0				--出站的人数计数

UIHero.IsTrainPanel = false			--是否是武将训练面板
UIHero.IsAutoAddExp = false			--是否自动突飞
UIHero.IsAutoSpeed = false			--是否使用加速符

UIHero.AutoControls = {}
UIHero.SucessGradeControls = {}

function UIHero:OpenUI(_PanelName , _LuaName)
	if UIHero.UIHeroGob==nil then
		UIHero.UIHeroGob=MainGameUI.FindPanel("UIHero")
		UIHero.HeroUpGradePanel=UIHero.UIHeroGob.transform:FindChild("HeroUpGrade")
		UIHero.HeroTrainPanel=UIHero.UIHeroGob.transform:FindChild("HeroTrain")
		UIHero.HeroInfoPanel=UIHero.UIHeroGob.transform:FindChild("HeroInfo")
	
		this:GetHeroInfoControls()
	end
	UIHero.GoAtkMaxCount = LimitDataSys.GetPveLimitCount()
	UIHero.TrainLimitCount = LimitDataSys.GetTrainLimitCount()
	this:ShowHeroInfoPanel()
end

function UIHero:GetHeroUpGradeControls()	--得到武将品质升阶的控件
	local left=UIHero.HeroUpGradePanel.transform:FindChild("Hero/HeroPanel/HeroLeft")
	UIHero.HeroUpGradeControls.HeroName=left.transform:FindChild("HeroName/Word"):GetComponent("UILabel")
	UIHero.HeroUpGradeControls.HeroImg=left.transform:FindChild("HeroPic/IMG"):GetComponent("UISprite")
	UIHero.HeroUpGradeControls.HeroFG=left.transform:FindChild("HeroPic/FG"):GetComponent("UISprite")
	UIHero.HeroUpGradeControls.HeroType=left.transform:FindChild("HeroType/FG (1)"):GetComponent("UISprite")
	UIHero.HeroUpGradeControls.HeroGradetxt=left.transform:FindChild("HeroPropNum/Word"):GetComponent("UILabel")
	UIHero.HeroUpGradeControls.HeroAtktxt=left.transform:FindChild("HeroPropNum/Word (1)"):GetComponent("UILabel")
	UIHero.HeroUpGradeControls.HeroHptxt=left.transform:FindChild("HeroPropNum/Word (2)"):GetComponent("UILabel")
	UIHero.HeroUpGradeControls.HeroTag=left.transform:FindChild("HeroTag"):GetComponent("UISprite")
	
	local right=UIHero.HeroUpGradePanel.transform:FindChild("Hero/HeroPanel/HeroRight")
	UIHero.HeroUpGradeControls.HeroUpName=right.transform:FindChild("HeroName/Word"):GetComponent("UILabel")
	UIHero.HeroUpGradeControls.HeroUpImg=right.transform:FindChild("HeroPic/IMG"):GetComponent("UISprite")
	UIHero.HeroUpGradeControls.HeroUpFG=right.transform:FindChild("HeroPic/FG"):GetComponent("UISprite")
	UIHero.HeroUpGradeControls.HeroUpType=right.transform:FindChild("HeroType/FG (1)"):GetComponent("UISprite")
	UIHero.HeroUpGradeControls.HeroUpGradetxt=right.transform:FindChild("HeroPropNum/Word"):GetComponent("UILabel")
	UIHero.HeroUpGradeControls.HeroUpAtktxt=right.transform:FindChild("HeroPropNum/Word (1)"):GetComponent("UILabel")
	UIHero.HeroUpGradeControls.HeroUpHptxt=right.transform:FindChild("HeroPropNum/Word (2)"):GetComponent("UILabel")
	UIHero.HeroUpGradeControls.HeroUpTag=right.transform:FindChild("HeroTag"):GetComponent("UISprite")
	
	local skillLeft=UIHero.HeroUpGradePanel.transform:FindChild("Hero/SkillPanel/SkillLeft")
	UIHero.HeroUpGradeControls.HeroSkillName=skillLeft.transform:FindChild("SkillName/Word"):GetComponent("UILabel")
	UIHero.HeroUpGradeControls.HeroSkillImg=skillLeft.transform:FindChild("SkillPic/IMG"):GetComponent("UISprite")
	UIHero.HeroUpGradeControls.HeroSkillTypeImg=skillLeft.transform:FindChild("SkillPic/FG"):GetComponent("UISprite")
	
	local skillRight=UIHero.HeroUpGradePanel.transform:FindChild("Hero/SkillPanel/SkillRight")
	UIHero.HeroUpGradeControls.HeroUpSkillName=skillRight.transform:FindChild("SkillName/Word"):GetComponent("UILabel")
	UIHero.HeroUpGradeControls.HeroUpSkillImg=skillRight.transform:FindChild("SkillPic/IMG"):GetComponent("UISprite")
	UIHero.HeroUpGradeControls.HeroUpSkillTypeImg=skillRight.transform:FindChild("SkillPic/FG"):GetComponent("UISprite")
	
	UIHero.HeroUpGradeControls.HeroChooseMatsPanel = UIHero.HeroUpGradePanel.transform:FindChild("ChooseMats")
	UIHero.HeroUpGradeControls.HeroMatsUIPanel = UIHero.HeroUpGradeControls.HeroChooseMatsPanel.transform:FindChild("HeroesPanel"):GetComponent("UIPanel")
	UIHero.HeroUpGradeControls.HeroMatGird = UIHero.HeroUpGradeControls.HeroChooseMatsPanel.transform:FindChild("HeroesPanel/HeroMatsGrid"):GetComponent("UIGrid")
	local godList = UIHero.HeroUpGradePanel.transform:FindChild("HeroMaterials/TeamGrid")
	for i=1,6,1  do
		UIHero.HeroTeamGridGod[i] = godList.transform:FindChild(tostring(i))
	end
	UIHero.HeroUpGradeControls.HeroInfoName = UIHero.HeroUpGradePanel.transform:FindChild("HeroMaterials/Tip/Info1/HeroName"):GetComponent("UILabel")
	UIHero.HeroUpGradeControls.HeroInfo = UIHero.HeroUpGradePanel.transform:FindChild("HeroMaterials/Tip/Info1"):GetComponent("UILabel")
	UIHero.HeroUpGradeControls.HeroUpGradeCost = UIHero.HeroUpGradePanel.transform:FindChild("HeroMaterials/Turn/Cost"):GetComponent("UILabel")
	
end

function UIHero:GetSuccessGradeControls()		--得到成功转生的控件
	local leftInfo = UIHero.HeroInfoControls.SuccessGradePanel.transform:FindChild("HeroLeft")
	UIHero.SucessGradeControls.beforeImg = leftInfo.transform:FindChild("HeroPic/IMG"):GetComponent("UISprite")
	UIHero.SucessGradeControls.beforeQuality = leftInfo.transform:FindChild("HeroType/FG (1)"):GetComponent("UISprite")
	UIHero.SucessGradeControls.beforeFG = leftInfo.transform:FindChild("HeroPic/FG"):GetComponent("UISprite")
	local rightInfo = UIHero.HeroInfoControls.SuccessGradePanel.transform:FindChild("HeroRight")
	UIHero.SucessGradeControls.nextImg = rightInfo.transform:FindChild("HeroPic/IMG"):GetComponent("UISprite")
	UIHero.SucessGradeControls.nextQuality = rightInfo.transform:FindChild("HeroType/FG (1)"):GetComponent("UISprite")
	UIHero.SucessGradeControls.nextFG = rightInfo.transform:FindChild("HeroPic/FG"):GetComponent("UISprite")

	UIHero.SucessGradeControls.BeforeSkillImg = UIHero.HeroInfoControls.SuccessGradePanel.transform:FindChild("SkillLeft/IMG"):GetComponent("UISprite")
	UIHero.SucessGradeControls.NextSkillImg = UIHero.HeroInfoControls.SuccessGradePanel.transform:FindChild("SkillRight/IMG"):GetComponent("UISprite")
	UIHero.SucessGradeControls.BeforeSkillQuality = UIHero.HeroInfoControls.SuccessGradePanel.transform:FindChild("SkillLeft/FG"):GetComponent("UISprite")
	UIHero.SucessGradeControls.NextSkillQuality = UIHero.HeroInfoControls.SuccessGradePanel.transform:FindChild("SkillRight/FG"):GetComponent("UISprite")
	
	local leftAttr = leftInfo.transform:FindChild("Attr")
	UIHero.SucessGradeControls.beforeAtk = leftAttr.transform:FindChild("atk"):GetComponent("UILabel") 
	UIHero.SucessGradeControls.beforeHp = leftAttr.transform:FindChild("hp"):GetComponent("UILabel")
	UIHero.SucessGradeControls.beforeAtkSpeed = leftAttr.transform:FindChild("atkSpeed"):GetComponent("UILabel")
	UIHero.SucessGradeControls.beforeAtkDistance = leftAttr.transform:FindChild("atkDistance"):GetComponent("UILabel")
	
	local rightAttr = rightInfo.transform:FindChild("Attr")
	UIHero.SucessGradeControls.nextAtk = rightAttr.transform:FindChild("atk"):GetComponent("UILabel") 
	UIHero.SucessGradeControls.nextHp = rightAttr.transform:FindChild("hp"):GetComponent("UILabel")
	UIHero.SucessGradeControls.nextAtkSpeed = rightAttr.transform:FindChild("atkSpeed"):GetComponent("UILabel")
	UIHero.SucessGradeControls.nextAtkDistance = rightAttr.transform:FindChild("atkDistance"):GetComponent("UILabel")
end

function UIHero:GetHeroInfoControls()--获得英雄信息面板的控件
	
	UIHero.HeroInfoControls.SuccessGradePanel = UIHero.UIHeroGob.transform:FindChild("SuccessUpGrade")
	local panel=UIHero.HeroInfoPanel.transform:FindChild("HeroInfoPanel")
	UIHero.HeroInfoControls.HeroInfos = panel.transform:FindChild("HeroPanel")
	local HeroInfo=panel.transform:FindChild("HeroPanel"):FindChild("SoldierInfo")
	UIHero.HeroInfoControls.UIWrap = UIHero.HeroInfoPanel.transform:FindChild("Heroes"):GetComponent("UIWrap")
	UIHero.HeroInfoControls.Eff = UIHero.HeroInfoPanel.transform:FindChild("FX_wujiang01")--
	UIHero.HeroInfoControls.EffEquip = UIHero.HeroInfoPanel.transform:FindChild("FX_zhuangbei_chuan01")
	UIHero.HeroInfoControls.MengJinEff = UIHero.HeroInfoPanel.transform:FindChild("FX_mengjin01")
	UIHero.HeroInfoControls.HeroModel = HeroInfo.transform:FindChild("Solidermodel")
	UIHero.HeroInfoControls.HeroScrollViewPanel = UIHero.HeroInfoPanel.transform:FindChild("Heroes/HeroesPanel")
	UIHero.HeroInfoControls.HeroGrid=UIHero.HeroInfoPanel.transform:FindChild("Heroes"):FindChild("HeroesPanel"):FindChild("HeroGrid"):GetComponent("UIGrid")
	UIHero.HeroInfoControls.HeroNameText=HeroInfo.transform:FindChild("SoliderName"):FindChild("Word"):GetComponent("UILabel")
--	UIHero.HeroInfoControls.HeroLvText=HeroInfo.transform:FindChild("SoliderLvl"):FindChild("Word"):GetComponent("UILabel")
	UIHero.HeroInfoControls.HeroSlider=HeroInfo.transform:FindChild("SoliderExp"):GetComponent("UISlider")
	UIHero.HeroInfoControls.HeroSliderNumText=HeroInfo.transform:Find("SoliderExp"):FindChild("ExpNum"):GetComponent("UILabel")
	UIHero.HeroInfoControls.HeroQuilty=HeroInfo.transform:FindChild("TitleImg"):GetComponent("UISprite")
	UIHero.HeroInfoControls.HeroSkillIcon = HeroInfo.transform:FindChild("SkillIcon"):GetComponent("UISprite")
	UIHero.HeroInfoControls.HeroSkillQuility = HeroInfo.transform:FindChild("SkillQuility"):GetComponent("UISprite")
	UIHero.HeroInfoControls.HeroAtk = HeroInfo.transform:FindChild("Atk/Label"):GetComponent("UILabel")
	UIHero.HeroInfoControls.HeroHp = HeroInfo.transform:FindChild("Hp/Label"):GetComponent("UILabel")
	UIHero.HeroInfoControls.HeroAtkSpeed = HeroInfo.transform:FindChild("AtkSpeed/Label"):GetComponent("UILabel")
	UIHero.HeroInfoControls.HeroAtkDistance = HeroInfo.transform:FindChild("AtkDistance/Label"):GetComponent("UILabel")

	UIHero.HeroInfoControls.HeroZhuanShengBtn=panel.transform:FindChild("Btns/ZhuanShengBtn")
	UIHero.HeroInfoControls.HeroTrianBtn=panel.transform:FindChild("Btns/TrianBtn")
	UIHero.HeroInfoControls.HeroJiePinBtn=panel.transform:FindChild("Btns/JiePinBtn")
	UIHero.HeroInfoControls.HeroGuaShuaiBtn=panel.transform:FindChild("Btns/GuaShuaiBtn")
	UIHero.HeroInfoControls.HeroWaitObj=panel.transform:FindChild("Btns/WaitBtn/HouZhan").gameObject
	UIHero.HeroInfoControls.HeroZhanObj=panel.transform:FindChild("Btns/WaitBtn/ChuZhan").gameObject
	
	UIHero.HeroInfoControls.ItemGrid = UIHero.HeroInfoPanel.transform:FindChild("ItemsPanel/Items/ItemsGrid"):GetComponent("UIGrid")
	UIHero.HeroInfoControls.ItemsPanel = UIHero.HeroInfoPanel.transform:FindChild("ItemsPanel")
	UIHero.HeroInfoControls.EquipPanel = UIHero.HeroInfoPanel.transform:FindChild("EquipPanel")
--	UIHero.HeroInfoControls.Title = UIHero.HeroInfoPanel.transform:FindChild("Title/Title"):GetComponent("UILabel")
	UIHero.HeroInfoControls.CloseBtn = UIHero.HeroInfoPanel.transform:FindChild("CloseHeroInfo")
	
	UIHero.HeroInfoControls.Btns = panel.transform:FindChild("Btns")
	UIHero.HeroInfoControls.OwnHeroCount = UIHero.HeroInfoPanel.transform:FindChild("Heroes/count"):GetComponent("UILabel")
	this:GetEquipGod()

end

function UIHero:GetEquipGod()
	local equipList = UIHero.HeroInfoPanel.transform:FindChild("EquipPanel/EquipList")
	for i=1,8,1  do
		UIHero.HeroEquipGod[i] = equipList.transform:FindChild(tostring(i))
	end
end

function UIHero:GetHeroTrainControls()--获得武将训练的相关控件
	local panel = UIHero.HeroTrainPanel.transform:FindChild("TrainPanel")
	UIHero.HeroTrainControls.TrainCount = panel.transform:FindChild("TrainCount"):GetComponent("UILabel")
	UIHero.HeroTrainControls.NormalTrainIng = panel.transform:FindChild("NormalTrainBtn/TrainIng")
	UIHero.HeroTrainControls.BetterTrainIng = panel.transform:FindChild("BetterTrainBtn/TrainIng")
	UIHero.HeroTrainControls.BestTrainIng = panel.transform:FindChild("BestTrainBtn/TrainIng")
	UIHero.HeroTrainControls.NormalTrainBg = panel.transform:FindChild("NormalTrainBtn/BG"):GetComponent("UISprite")
	UIHero.HeroTrainControls.BetterTrainBg = panel.transform:FindChild("BetterTrainBtn/BG"):GetComponent("UISprite")
	UIHero.HeroTrainControls.BestTrainBg = panel.transform:FindChild("BestTrainBtn/BG"):GetComponent("UISprite")

	UIHero.HeroTrainControls.NormalTrainIngTxt = UIHero.HeroTrainControls.NormalTrainIng:FindChild("time"):GetComponent("UILabel")
	UIHero.HeroTrainControls.BetterTrainIngTxt = UIHero.HeroTrainControls.BetterTrainIng:FindChild("time"):GetComponent("UILabel")
	UIHero.HeroTrainControls.BestTrainIngTxt = UIHero.HeroTrainControls.BestTrainIng:FindChild("time"):GetComponent("UILabel")
	
	UIHero.HeroTrainControls.NormalNoTrain = panel.transform:FindChild("NormalTrainBtn/TrainInfo")
	UIHero.HeroTrainControls.BetterNoTrain = panel.transform:FindChild("BetterTrainBtn/TrainInfo")
	UIHero.HeroTrainControls.BestNoTrain = panel.transform:FindChild("BestTrainBtn/TrainInfo")
	UIHero.HeroTrainControls.NormalTimeImg = UIHero.HeroTrainControls.NormalNoTrain.transform:FindChild("time/Sprite"):GetComponent("UISprite")
	UIHero.HeroTrainControls.BetterTimeImg = UIHero.HeroTrainControls.BetterNoTrain.transform:FindChild("time/Sprite"):GetComponent("UISprite")
	UIHero.HeroTrainControls.BestTimeImg = UIHero.HeroTrainControls.BestNoTrain.transform:FindChild("open/time/Sprite"):GetComponent("UISprite")
	UIHero.HeroTrainControls.NormalCostImg = UIHero.HeroTrainControls.NormalNoTrain.transform:FindChild("cost/Sprite"):GetComponent("UISprite")
	UIHero.HeroTrainControls.BetterCostImg = UIHero.HeroTrainControls.BetterNoTrain.transform:FindChild("cost/Sprite"):GetComponent("UISprite")
	UIHero.HeroTrainControls.BestCostImg = UIHero.HeroTrainControls.BestNoTrain.transform:FindChild("open/cost/Sprite"):GetComponent("UISprite")
	UIHero.HeroTrainControls.OpenBestTrain = UIHero.HeroTrainControls.BestNoTrain.transform:FindChild("open")
	UIHero.HeroTrainControls.NoOpenBestTrain = UIHero.HeroTrainControls.BestNoTrain.transform:FindChild("noOpen")
	UIHero.HeroTrainControls.BestTrainItemImg = UIHero.HeroTrainControls.OpenBestTrain.transform:FindChild("cost/Sprite"):GetComponent("UISprite")
	UIHero.HeroTrainControls.NormalCostCount = UIHero.HeroTrainControls.NormalNoTrain.transform:FindChild("cost"):GetComponent("UILabel")
	UIHero.HeroTrainControls.BetterCostCount = UIHero.HeroTrainControls.BetterNoTrain.transform:FindChild("cost"):GetComponent("UILabel")
	UIHero.HeroTrainControls.BestCostCount = UIHero.HeroTrainControls.OpenBestTrain.transform:FindChild("cost"):GetComponent("UILabel")

	UIHero.HeroTrainControls.ColdBtn = panel.transform:FindChild("ColdBtn")
	UIHero.HeroTrainControls.ColdTime = UIHero.HeroTrainControls.ColdBtn.transform:FindChild("ColdTime/Word"):GetComponent("UILabel")
	UIHero.HeroTrainControls.SpeedItem = panel.transform:FindChild("surplusMat/Word"):GetComponent("UILabel")
	UIHero.HeroTrainControls.AddExpItem = UIHero.HeroTrainControls.ColdBtn.transform:FindChild("LeftSpeedMaterial/Word"):GetComponent("UILabel")
		
	UIHero.HeroTrainControls.HelpPanel = UIHero.HeroTrainPanel.transform:FindChild("HelpPanel")
	UIHero.HeroTrainControls.HelpPanelInfo = UIHero.HeroTrainControls.HelpPanel.transform:FindChild("Scroll View/Label"):GetComponent("UILabel")
	UIHero.HeroTrainControls.AutoPanel = UIHero.HeroTrainPanel.transform:FindChild("AutoPanel")
end

function UIHero:ShowHeroInfoPanel()--显示武将信息面板
	UIHero.HeroInfoControls.OwnHeroCount.text = tostring(#HeroPackageSys.Heros)
	local list = TeamSys.GetPveHeros()
	UIHero.GoAtkCount = #list
	UIHero.IsTrainPanel = false	
	GameMain.CloseObj(UIHero.HeroTrainPanel)
	GameMain.CloseObj(UIHero.HeroUpGradePanel)
	GameMain.OpenObj(UIHero.HeroInfoControls.Btns.gameObject)
	GameMain.OpenObj(UIHero.HeroInfoControls.HeroInfos)
	GameMain.OpenObj(UIHero.HeroInfoPanel)
	GameMain.OpenObj(UIHero.HeroInfoControls.CloseBtn)
	GameMain.OpenObj(UIHero.HeroInfoControls.ItemsPanel)
	GameMain.OpenObj(UIHero.HeroInfoControls.EquipPanel)
	GameMain.CloseObj(UIHero.HeroInfoControls.Eff)
	GameMain.CloseObj(UIHero.HeroInfoControls.EffEquip)
	GameMain.CloseObj(UIHero.HeroInfoControls.MengJinEff)
--	UIHero.HeroInfoControls.Title.text = "武 将"
	UIHero.CurTrainCount = HeroPackageSys.GetCurTrainCount()
	this:ShowHeroItemList(UIHero.HeroInfoControls.HeroGrid.transform)
	this:ShowHeroBagInfo()
end

function UIHero:SetInitGuaShuai()
	if ClinetInfomation.GuaShuaiUUID == "" then
		local data=UIHero.HeroList[1]
		
			data:UpPvpHero()
			UIHero.GuaShuaiHeroIndex=1
			
			this:CloseObj(UIHero.HeroInfoControls.HeroGuaShuaiBtn.gameObject)
			this:OpenObj(UIHero.HeroGodList[1].transform:FindChild("Shuai"))
	end
end

function UIHero:ShowHeroItemList(_grid)
	local panel = UIHero.HeroInfoControls.HeroGrid.transform.parent.transform:GetComponent("UIPanel")
	panel.transform.localPosition =Vector3(0 , 0 , 0)
	panel.clipOffset = Vector2(0 , 0)
	UIHero.HeroList = {}
	local heros=HeroPackageSys.GetHero()
	for i=1,#heros,1 do
		UIHero.HeroList[i] = heros[i]
	end
	if #UIHero.HeroList == 0 then
		GameMain.CloseObj(UIHero.HeroInfoControls.HeroInfos)
		GameMain.CloseObj(UIHero.HeroInfoControls.Btns)
	end
	UIHero.HeroInfoControls.UIWrap:ResetTrans(#heros)
	if #UIHero.HeroGodList == 0 then
		for i=1, 10,1  do
			local data = 
			{
				Index = i,
			}
			MainGameUI.CreateLittleItem(tostring(i) , "HeroItem" , _grid , data , this.CreateHeroListCallBack , "UIHero") 
		end
	else
		for i=1,10,1 do
			local data=
			{
				Index=i,
			}
			if UIHero.HeroGodList[i] == nil then
				MainGameUI.CreateLittleItem(tostring(i) , "HeroItem" , _grid , data , this.CreateHeroListCallBack , "UIHero") 
			else
				this:CreateHeroListCallBack(UIHero.HeroGodList[i],data)
			end
			
		end
	end
end

function UIHero:CreateHeroListCallBack(_Gob , _Info)--创建物品列表并做信息显示
--	_Gob.gameObject:SetActive(true)
	if _Info.Index==10   then
		UIHero.HeroInfoControls.HeroGrid.enabled = true
		UIHero.HeroInfoControls.HeroGrid:Reposition()
		UIHero.HeroInfoPanel.transform:FindChild("Heroes"):GetComponent("UIWrap"):SetData(#HeroPackageSys.GetHero() , "UIHero")
		this:ShowHeroItemPanel(1)
--		this:SetInitGuaShuai()
	end

	local id = _Info.Index
	
	UIHero.HeroGodList[id]=_Gob
	
	local data = UIHero.HeroList[id]
	this:ShowHeroItem(data,UIHero.HeroGodList[id])
end

function UIHero:UpdateItem(_LuaName , _Item) 
	local parentName = _Item.transform.parent.name;
	local id = tonumber(_Item.name)
	if parentName == "HeroMatsGrid" then
		local data = UIHero.HeroMatList[id]
		
		this:ShowHeroMatItem(data , _Item)
	end
	
	if parentName == "HeroGrid" then
		local data = UIHero.HeroList[id]
	
		if UIHero.HeroGodList[id] ==nil then
			UIHero.HeroGodList[id] = _Item
		end
		if id == UIHero.ClickTempHeroIndex then
			this:OpenObj( _Item.transform:FindChild("Choose").gameObject) 
		else
			this:CloseObj( _Item.transform:FindChild("Choose").gameObject)
		end
	
		this:ShowHeroItem(data,_Item)
	
	end

	if parentName == "ItemsGrid" then
		_Item.transform.localScale = Vector3(0.8 , 0.8 ,1)
		
		local data = UIHero.HeroBagList[id]

		this:ShowBagItem(data,_Item)
		UIHero.HeroBagGodList[id]=_Item
	end
	
end

function UIHero:ShowHeroItem(data , _Gob)     --显示列表中单个武将的相关信息
	
	local lv=_Gob.transform:FindChild("Lvl"):GetComponent("UILabel")
	local name=_Gob.transform:FindChild("name")
	local img=_Gob.transform:FindChild("IMG"):GetComponent("UISprite")
	local Quality=_Gob.transform:FindChild("FG"):GetComponent("UISprite")
	if data == nil then
		GameMain.CloseObj(_Gob)
		return
	end
	
	GameMain.OpenObj(_Gob)

	local zhan=_Gob.transform:FindChild("Zhan")
	local Shuai=_Gob.transform:FindChild("Shuai")
	local Train=_Gob.transform:FindChild("train")
	local bg = _Gob.transform:FindChild("bg"):GetComponent("UISprite")
	local isTrain = data:IsTrain()
	if isTrain == true then
		GameMain.OpenObj(Train)
	else
		GameMain.CloseObj(Train)
	end
	
		lv.text="LV" .. tostring(data:GetLvl())
		if name ~= nil then
			name.transform:GetComponent("UILabel").text= UIstring.WordColor[data.quality] .. tostring(data.nickname) .. "[-]"
		end
		this:CloseObj(zhan.gameObject)
		for key,value in pairs(TeamSys.GetPveHeros()) do
			if value.UUID == data.UUID then
				this:OpenObj(zhan.gameObject)		--后续优化
			end
		end
		if data.UUID ==ClinetInfomation.GuaShuaiUUID then
			UIHero.GuaShuaiHeroIndex=tonumber(_Gob.name)
			this:OpenObj(Shuai.gameObject)
		else
			this:CloseObj(Shuai.gameObject)
		end
	AtlasMsg.SetAtlas(img , data.AtlasName ,data.SpriteName)
	Quality.spriteName = UIstring.ItemFg[data.quality]
	bg.spriteName = UIstring.ItemFg[data.quality]
end


--region *.武将装备相关
function UIHero:ShowHeroBagInfo()
	local list =  EquipSys.GetEquipList()
	
	if #list ~=0 then
		for i=1,#list,1 do
			UIHero.HeroBagList[i] = list[i]
		end
		
		this:ShowHeroBagList()
	end
	
end
function UIHero:ShowHeroBagList()
		local panel = UIHero.HeroInfoControls.ItemsPanel.transform:FindChild("Items"):GetComponent("UIPanel")
		panel.transform.localPosition = Vector3(0 ,0 , 0)
		panel.clipOffset = Vector2(0 , 0)
		UIHero.HeroInfoPanel.transform:FindChild("ItemsPanel"):GetComponent("UIWrap"):ResetTrans(#UIHero.HeroBagList)
		for i=1,20,1 do
			local data=
			{
				Index=i,
			}
			if UIHero.HeroBagGodList[i] ~=nil then
				this:CreateBagListCallBack(UIHero.HeroBagGodList[i],data)
			else
				MainGameUI.CreateLittleItem(tostring(i) , "itemIcon" , UIHero.HeroInfoControls.ItemGrid , data , this.CreateBagListCallBack , "UIHero") 
			end
		end
end

function UIHero:CreateBagListCallBack(_Gob , _Info)
	
	if _Info.Index==20   then
		UIHero.HeroInfoControls.ItemGrid.enabled = true
		UIHero.HeroInfoControls.ItemGrid:Reposition()
		UIHero.HeroInfoPanel.transform:FindChild("ItemsPanel"):GetComponent("UIWrap"):SetData(#UIHero.HeroBagList , "UIHero")
		
	end

	local id = _Info.Index
	local data = UIHero.HeroBagList[id]
	_Gob.transform.localScale = Vector3(0.8 , 0.8 ,1)
	UIHero.HeroBagGodList[id]=_Gob
	this:ShowBagItem(data,UIHero.HeroBagGodList[id])
	
end

function UIHero:ShowBagItem( data , _Gob)
	
	if data==nil then
		GameMain.CloseObj(_Gob)
		return
	end
	GameMain.OpenObj(_Gob)

	local lv = _Gob.transform:FindChild("Lv"):GetComponent("UILabel")
	local count = _Gob.transform:FindChild("count"):GetComponent("UILabel")
	local Img = _Gob.transform:FindChild("Img"):GetComponent("UISprite")
	local Quility = _Gob.transform:FindChild("BG"):GetComponent("UISprite")
	local bg = _Gob.transform:FindChild("FG"):GetComponent("UISprite")
	
	if data.Lvl ==nil then
		GameMain.CloseObj(lv)
	else
		GameMain.OpenObj(lv)
		lv.text = "LV." .. tostring(data.Lvl)
	end
	
	if data.Count == nil then
		GameMain.CloseObj(count)
	else
		GameMain.OpenObj(count)
		count.text = tostring(data.Count)
	end
	bg.spriteName = UIstring.ItemFg[data.Quality]
	Quility.spriteName = UIstring.ItemFg[data.Quality]
	AtlasMsg.SetAtlas(Img , data.AtlasName ,data.SpriteName)
end



function UIHero:ShowDressEquipListInfo(_Index)					--穿上装备的相关显示
	
	if UIHero.HeroBagList[_Index] ~=nil then
		local data = UIHero.HeroBagList[_Index]  
		local equipItem = UIHero.HeroEquipGod[data.EquipType]
		local Img = equipItem.transform:FindChild("IMG"):GetComponent("UISprite")
		local fg = Img.transform:FindChild("FG"):GetComponent("UISprite")
		local heroData =UIHero.HeroList[UIHero.ClickTempHeroIndex]
		if heroData == nil then
			return
		end
		local beforeEquipAttr = heroData:GetEquipBattleValue()
		if Img.gameObject.activeInHierarchy == false then
			GameMain.OpenObj(Img.gameObject)
			this:RemoveBagList(_Index)
		else
			local uuid = heroData.Equips[data.EquipType]
			
			local equip = EquipSys.FindEquipByUUID(uuid)
			UIHero.HeroBagList[_Index] = equip
			this:ShowBagItem(UIHero.HeroBagList[_Index] , UIHero.HeroBagGodList[_Index])
		end		
		
		heroData:DressUpEquip(data.UUID , data.EquipType, 0)
		local lvl = equipItem.transform:FindChild("Lvl"):GetComponent("UILabel")
		local quility = equipItem.transform:FindChild("FG"):GetComponent("UISprite")
		GameMain.CloseObj(equipItem.transform:FindChild("name"))
		GameMain.OpenObj(lvl)
		AtlasMsg.SetAtlas(Img, data.AtlasName ,data.SpriteName)
		fg.spriteName = UIstring.ItemFg[tonumber(data.Quality)]
		local bgFg = Img.transform:FindChild("FG"):GetComponent("UISprite")
		bgFg.spriteName = UIstring.ItemFg[tonumber(data.Quality)]
		lvl.text = "Lv." .. tostring(data.Lvl)
		quility.spriteName = UIstring.ItemFg[tonumber(data.Quality)]
		local afterBattleAttr = heroData:GetEquipBattleValue()
		this:PopBattleChangeValue(beforeEquipAttr , afterBattleAttr)
		this:ShowBattleAttrInfo(heroData)
		this:ShowHeroEquipEff(equipItem)

		MusicManagerSys.DressEquip()
	end

end 

function UIHero:ShowHeroEquipEff(_God)
	UIHero.HeroInfoControls.EffEquip.transform.position = _God.transform.position
	GameMain.CloseObj(UIHero.HeroInfoControls.EffEquip)
	GameMain.OpenObj(UIHero.HeroInfoControls.EffEquip)
end

function UIHero:GetIndex(_UUID)
	for key,value in pairs(UIHero.HeroBagList) do
		if value.UUID == _UUID then
			return key
		end
	end
end

function UIHero:ShowUpEquipListInfo(_Index)					--卸下装备之后
	
	local heroData = UIHero.HeroList[UIHero.ClickTempHeroIndex]
	if heroData == nil then
		return
	end
	local _god = UIHero.HeroEquipGod[_Index]
	_god.transform:FindChild("FG"):GetComponent("UISprite").spriteName = UIstring.ItemFg[0]
    GameMain.CloseObj(_god.transform:FindChild("Lvl"))
	GameMain.CloseObj(_god.transform:FindChild("IMG"))
	GameMain.OpenObj(_god.transform:FindChild("name"))
	local beforeEquipAddAttr = heroData:GetEquipBattleValue()

	local uuid = heroData.Equips[_Index]
	if uuid == nil then
		return
	end
	heroData:DressUpEquip(uuid, _Index , 1)
	local equip = EquipSys.FindEquipByUUID(uuid)
	table.insert(UIHero.HeroBagList , #UIHero.HeroBagList+1 , equip)
	EquipSys.DelHeroEquip(equip.UUID)
	this:ShowHeroBagList()

	local afterEquipAddAttr = heroData:GetEquipBattleValue()

	this:PopBattleChangeValue(beforeEquipAddAttr , afterEquipAddAttr)
	this:ShowBattleAttrInfo(heroData)
	MusicManagerSys.DressUpEquip()
end

function UIHero:PopBattleChangeValue(_BeforeBattle , _AfterBattle)
	local popStr = ""
	local changeHp = _AfterBattle.Hp - _BeforeBattle.Hp
	local changeAtk = _AfterBattle.Atk - _BeforeBattle.Atk
	local changeAtkSpeed = _AfterBattle.AtkSpeed - _BeforeBattle.AtkSpeed
	if changeAtk~=0 then
		if changeAtk>0 then
			popStr = popStr .. UIstring.Green .. " 攻击+" ..changeAtk .."[-]"
		end
		if changeAtk<0 then
			popStr = popStr .. UIstring.Red .. " 攻击" .. changeAtk .."[-]"
		end
	end
	if changeHp~=0 then
		if changeHp>0 then
			popStr = popStr .. UIstring.Green .. " 血量+" ..changeHp  .."[-]"
		end
		if changeHp<0 then
			popStr = popStr .. UIstring.Red .. " 血量" .. changeHp .."[-]"
		end
	end
	if changeAtkSpeed~=0 then
		if changeAtkSpeed>0 then
			popStr = popStr .. UIstring.Green .. "攻速+" ..changeAtkSpeed  .."[-]"
		end
		if changeAtkSpeed<0 then
			popStr = popStr .. UIstring.Red .. "攻速" .. changeAtkSpeed .."[-]"
		end
	end

	DataUIInstance.PopTip(popStr)
end


function UIHero:RemoveBagList(_Index)
	table.remove(UIHero.HeroBagList , _Index)
	this:ShowHeroBagList()
end

--endregion
function UIHero:ClearHeroEquipList()
	for i=1,8,1 do
		this:ShowHeroEquipItemInfo(i,nil)
	end
	
end

function UIHero:ShowHeroEquipItemInfo(_Index , _UUID)
	local img = UIHero.HeroEquipGod[_Index].transform:FindChild("IMG"):GetComponent("UISprite")
	local imgQuility = UIHero.HeroEquipGod[_Index].transform:FindChild("FG"):GetComponent("UISprite")
	local name = UIHero.HeroEquipGod[_Index].transform:FindChild("name")
	local lv = UIHero.HeroEquipGod[_Index].transform:FindChild("Lvl"):GetComponent("UILabel")
	local data = EquipSys.GetHeroEquipByUUID(_UUID)
	
	if data ==nil then
		imgQuility.spriteName = UIstring.ItemFg[1]
	    GameMain.CloseObj(img)
		GameMain.OpenObj(name)
		GameMain.CloseObj(lv)
	else
		imgQuility.spriteName = UIstring.ItemFg[data.Quality]
		local bgFg = img.transform:FindChild("FG"):GetComponent("UISprite")
		bgFg.spriteName = UIstring.ItemFg[data.Quality]
		GameMain.OpenObj(img)
		GameMain.CloseObj(name)
		GameMain.OpenObj(lv)
		lv.text = "Lv." .. tostring( data.Lvl)
		AtlasMsg.SetAtlas(img, data.AtlasName ,data.SpriteName)
	end
	
end

function UIHero:SendWebAboutEquip(ItemKey)
	--请求服务器进行穿卸装备	
	local herodata = UIHero.HeroList[UIHero.ClickTempHeroIndex]
	if herodata ~= nil then
		local isSend = this:CompareIsEqual(herodata)

		if isSend == true then
			UIHero.HeroList[UIHero.ClickTempHeroIndex]:UpandDownEquip()
		end
	this:ShowHeroItemPanel (ItemKey)  
	end
end

function UIHero:CloseSendWebEquip()
	local herodata = UIHero.HeroList[UIHero.ClickTempHeroIndex]
	local isSend = this:CompareIsEqual(herodata)
	
	if isSend == true then
		UIHero.HeroList[UIHero.ClickTempHeroIndex]:UpandDownEquip()
	end	
end
function UIHero:CompareIsEqual(herodata)
	if herodata == nil then
		return false
	end
	local heroUUIDs = herodata:GetEquipUUIDs()
	local LenUUIDs = this:GetLen(heroUUIDs)
	local TempLenUUIDs = this:GetLen(UIHero.TempHeroEquipUUIDs)
	if LenUUIDs ~= TempLenUUIDs then
		return true
	end
	for key,value in pairs(heroUUIDs) do
		if UIHero.TempHeroEquipUUIDs[key] ~= value then
			return true
		end
	end
	return false
end

function UIHero:GetLen(list)
	local len =0
	for key,value in pairs(list) do
		len = len +1
	end
	return len
end

UIHero.HeroMusic = nil

function UIHero:ShowHeroItemPanel(_Index)--根据Index显示相应的武将信息
	if UIHero.HeroList[_Index]~=nil then
		
		if UIHero.ClickTempHeroIndex~=0 then
			this:CloseObj( UIHero.HeroGodList[UIHero.ClickTempHeroIndex].transform:FindChild("Choose"))
		end
		UIHero.ClickTempHeroIndex=_Index
		this:OpenObj( UIHero.HeroGodList[UIHero.ClickTempHeroIndex].transform:FindChild("Choose"))
		
		local heroData=UIHero.HeroList[_Index]
		if UIHero.HeroMusic ~= nil then
			MusicManagerSys.StopSomeMusic(UIHero.HeroMusic)
		end
		UIHero.HeroMusic =	MusicManagerSys.PlayHeroSound(heroData.Sound) -- 播放声音
		local skillData = RoleSkillConfig.GetRoleSkillById(heroData.SkillId)
		AtlasMsg.SetAtlas(UIHero.HeroInfoControls.HeroSkillIcon , skillData.AtlasName , skillData.SpriteName)
		UIHero.HeroInfoControls.HeroSkillQuility.spriteName = UIstring.ItemFg[heroData.quality]
		local curLvlExp = heroData:GetLvlAndExp()
		local nextExp = RoleDataSys.GetRoleUpExp(curLvlExp[1])
		if nextExp~=nil then
			if nextExp == 0 then
				UIHero.HeroInfoControls.HeroSlider.value = 1
			else
				UIHero.HeroInfoControls.HeroSlider.value = tonumber(curLvlExp[2])/nextExp
			end
		end 
		local needExp = nextExp 
		UIHero.HeroInfoControls.HeroSliderNumText.text = (curLvlExp[2]) .."/" .. needExp
	
		UIHero.HeroInfoControls.HeroNameText.text= UIstring.WordColor[heroData.quality] .. "LV" .. tostring(curLvlExp[1])..tostring(heroData.nickname) .. "[-]"
		this:ShowBattleAttrInfo(heroData)
		
		UIHero.HeroInfoControls.HeroAtkDistance.text = tostring(heroData.AttackRange)
		UIHero.HeroInfoControls.HeroQuilty.spriteName = UIstring.QuilityImg[tonumber(heroData.quality)]
		UIHero.HeroInfoControls.HeroModel.localEulerAngles = Vector3(0,150,0)
		if UIHero.TempHeroModel ~=nil then
			if heroData.ModelName~= UIHero.TempHeroModel.name then
			  GameObject.Destroy(UIHero.TempHeroModel)
			  UIHero.TempHeroModel = nil
			end
		end
		
		Create3DModel.CreateThModel(heroData.ModelName , nil , 5 , UIHero.HeroInfoControls.HeroModel , UIHero.CreateModelCallBack , true , nil)  
		this:CloseObj(UIHero.HeroInfoControls.HeroWaitObj)
		this:OpenObj(UIHero.HeroInfoControls.HeroZhanObj)
		local list = TeamSys.GetPveHeros()
		for key,value in pairs( list) do
			if heroData.UUID == value.UUID then
				this:OpenObj(UIHero.HeroInfoControls.HeroWaitObj)
				this:CloseObj(UIHero.HeroInfoControls.HeroZhanObj)
			end
		end

		if heroData.quality>=4 then		--成名以上武将不可以解雇
			this:CloseObj(UIHero.HeroInfoControls.HeroJiePinBtn.gameObject)
		else
			this:OpenObj(UIHero.HeroInfoControls.HeroJiePinBtn.gameObject)
		end
		if heroData.quality>=4 and heroData.quality<heroData.Aptitude then
--			local isHasUpHero = this:IsHasUpHero(heroData.AdvanceId)
--			if isHasUpHero == true then
--				this:CloseObj(UIHero.HeroInfoControls.HeroZhuanShengBtn.gameObject)
--			else
				this:OpenObj(UIHero.HeroInfoControls.HeroZhuanShengBtn.gameObject)
--			end
		else
			this:CloseObj(UIHero.HeroInfoControls.HeroZhuanShengBtn.gameObject)
		end
		if heroData.IsJieGu == false then
			this:OpenObj(UIHero.HeroInfoControls.HeroGuaShuaiBtn.gameObject)
			this:OpenObj(UIHero.HeroInfoControls.HeroWaitObj.transform.parent)
			
			this:OpenObj(UIHero.HeroInfoControls.HeroTrianBtn)
		else
			this:CloseObj(UIHero.HeroInfoControls.HeroGuaShuaiBtn.gameObject)
			
			this:CloseObj(UIHero.HeroInfoControls.HeroWaitObj.transform.parent)
			
			this:CloseObj(UIHero.HeroInfoControls.HeroTrianBtn)
		end
			
		if UIHero.GuaShuaiHeroIndex~=0 and UIHero.GuaShuaiHeroIndex==_Index then
			this:CloseObj(UIHero.HeroInfoControls.HeroGuaShuaiBtn.gameObject)
		end
		UIHero.TempHeroEquipUUIDs = {}
		local equipUUIDs = heroData:GetEquipUUIDs()
		if equipUUIDs ~=nil then
			UIHero.TempHeroEquipUUIDs = equipUUIDs
		else
			UIHero.TempHeroEquipUUIDs = {}
		end

		if equipUUIDs== nil then
			this:ClearHeroEquipList()
		else
			for i=1,8,1  do
				this:ShowHeroEquipItemInfo( i ,heroData.Equips[i])
			end
		end
		
		if UIHero.IsTrainPanel == true then
			this:ShowTrainInfo(heroData)
		end
	else
		this:CloseObj(UIHero.HeroInfoControls.HeroWaitObj.transform.parent)
	end
end

function UIHero:IsHasUpHero(_Id)
	for key,value in pairs(UIHero.HeroList) do
		if value.Dbid == _Id then
			return true
		end
	end
	return false
end

function UIHero:ShowBattleAttrInfo(_Data)			--显示战斗力的相关信息

	local equipAddAttr = _Data:GetEquipBattleValue()
	if equipAddAttr.Atk == 0 then
		UIHero.HeroInfoControls.HeroAtk.text = tostring(_Data:GetAtk()) .. _Data:GetAtkGrowStr()
	else
		UIHero.HeroInfoControls.HeroAtk.text = tostring(_Data:GetAtk()) .. _Data:GetAtkGrowStr() ..UIstring.Green.. "+" .. equipAddAttr.Atk.."[-]"
	end
	if equipAddAttr.Hp == 0 then
		UIHero.HeroInfoControls.HeroHp.text = tostring(_Data:GetLife()) .. _Data:GetLifeGrowStr()
	else
		UIHero.HeroInfoControls.HeroHp.text = tostring(_Data:GetLife()) .. _Data:GetLifeGrowStr() .. UIstring.Green.."+" .. equipAddAttr.Hp .. "[-]"
	end
	if equipAddAttr.AtkSpeed == 0 then
		UIHero.HeroInfoControls.HeroAtkSpeed.text = tostring(_Data:GetAtkSpeed()) .. _Data:GetAtkSpeedGrowStr()
	else
		UIHero.HeroInfoControls.HeroAtkSpeed.text = tostring(_Data:GetAtkSpeed()) .. _Data:GetAtkSpeedGrowStr()..UIstring.Green ..  "+" .. equipAddAttr.AtkSpeed.. "[-]"
	end
end

function UIHero.CreateModelCallBack(NeedModel , _Data)
	UIHero.TempHeroModel = NeedModel
	 Create3DModel.CreateHorse(UIHero.TempHeroModel , UIHero.Create3DHorseCallBack)  
end

function UIHero.Create3DHorseCallBack(_Model , _Data)
   _Model.transform.parent = UIHero.TempHeroModel.transform
   _Model.transform.localPosition = Vector3(0 , -2 , 0)
--	GameMain.AddComponent(UIHero.TempHeroModel , "HeroDrag")

----	UIHero.TempHeroModel.AddComponent("HeroDrag")
--	GameMain.AddComponent(UIHero.TempHeroModel , "BoxCollider")
--	UIHero.TempHeroModel.transform:GetComponent("BoxCollider").size = Vector3(5,5,5)
end

function UIHero:ShowHeroUpGradePanel()--显示武将转生界面
	local data=UIHero.HeroList[UIHero.ClickTempHeroIndex]
	
	if data.quality<4 then
		GameMain.OpenObj(UIHero.HeroInfoPanel.gameObject)
		DataUIInstance.PopTip(UIstring.HeroCanNotUpGrade)
		return
	end
	if data.quality>=data.Aptitude then
		GameMain.OpenObj(UIHero.HeroInfoPanel.gameObject)
		DataUIInstance.PopTip("品质已经达到最高")
		return
	end
	if data.AdvanceId ==0 then
		GameMain.OpenObj(UIHero.HeroInfoPanel.gameObject)
		DataUIInstance.PopTip(UIstring.HeroHasUpGrade)
		return
	end
	GameMain.CloseObj(UIHero.HeroInfoPanel)
	GameMain.OpenObj(UIHero.HeroUpGradePanel)

	if UIHero.HeroUpGradeControls.HeroName==nil then
		this:GetHeroUpGradeControls()
	end
	
	if UIHero.ClickTempHeroIndex~=0 then
		this:HeroGradeSetInfo()
		GameMain.CloseObj(UIHero.HeroUpGradeControls.HeroChooseMatsPanel)
	end
end

function UIHero:HeroGradeSetInfo()
	
	local data=UIHero.HeroList[UIHero.ClickTempHeroIndex]
	local nextData = RoleDataSys.GetRoleById(data.AdvanceId)
	this:ClearHeroMatList(data.UpGradeNum)
	
	UIHero.HeroUpGradeMatNum = data.UpGradeNum
	 UIHero.HeroMatList = {}
	local heros = HeroPackageSys.GetGradeEqualHero(data)
	for i=1,#heros,1 do
		UIHero.HeroMatList[i] = heros[i]
	end
	this:ShowHeroUpGradeInfo(data , nextData)
end

function UIHero:ShowHeroUpGradeInfo(data , nextData)
	UIHero.HeroUpGradeControls.HeroTag.spriteName = UIstring.QuilityImg[data.quality]
	UIHero.HeroUpGradeControls.HeroUpTag.spriteName = UIstring.QuilityImg[nextData.Quality]
	UIHero.HeroUpGradeControls.HeroUpGradeCost.text = UIstring.HeroUpNeedCount .. data.UpGradeCost .. UIstring.HeroMoney

	UIHero.HeroUpGradeControls.HeroName.text=UIstring.WordColor[data.quality]..data.nickname.."[-]"
	UIHero.HeroUpGradeControls.HeroAtktxt.text =tostring(data:GetAtk()) .. data:GetAtkGrowStr()
	UIHero.HeroUpGradeControls.HeroHptxt.text = tostring(data:GetLife()) .. data:GetLifeGrowStr()
	UIHero.HeroUpGradeControls.HeroGradetxt.text = tostring(data.AttackType)
	AtlasMsg.SetAtlas( UIHero.HeroUpGradeControls.HeroImg, data.AtlasName , data.SpriteName)
	UIHero.HeroUpGradeControls.HeroType.spriteName =UIstring.ItemFg[data.quality]
	UIHero.HeroUpGradeControls.HeroFG.spriteName =UIstring.ItemFg[data.quality]
	
	local nextHp = RoleDataSys.GetRoleLife(nextData , data.lvl)
	local nextAtk = RoleDataSys.GetRoleAtk(nextData , data.lvl)
	UIHero.HeroUpGradeControls.HeroUpName.text= UIstring.WordColor[nextData.Quality]..nextData.Name.."[-]"	
	UIHero.HeroUpGradeControls.HeroUpGradetxt.text = tostring(nextData.AttackType)
	UIHero.HeroUpGradeControls.HeroUpAtktxt.text = tostring(nextAtk) .. "(" .. nextData.AttackList[4] .. ")"
	UIHero.HeroUpGradeControls.HeroUpHptxt.text = tostring(nextHp) .. "(" .. nextData.LifeList[4] .. ")"
	AtlasMsg.SetAtlas( UIHero.HeroUpGradeControls.HeroUpImg, nextData.AtlasName , nextData.SpriteName)
	UIHero.HeroUpGradeControls.HeroUpType.spriteName =UIstring.ItemFg[nextData.Quality]
	UIHero.HeroUpGradeControls.HeroUpFG.spriteName = UIstring.ItemFg[nextData.Quality]

	UIHero.HeroUpGradeControls.HeroInfoName.text = UIstring.WordColor[nextData.Quality]..nextData.Name.."[-]"
	UIHero.HeroUpGradeControls.HeroInfo.text = UIstring.HeroConsume .. UIstring.WordColor[nextData.Quality] .. tostring(data.UpGradeNum).. "[-]".. UIstring.HeroSimiliarQuality
	
	local skill =  RoleSkillConfig.GetRoleSkillById(data.SkillId)
	local nextSkill = RoleSkillConfig.GetRoleSkillById(nextData.Spell_Id)
	UIHero.HeroUpGradeControls.HeroSkillName.text = UIstring.WordColor[data.quality] .. skill.Name .. "[-]"
	AtlasMsg.SetAtlas(UIHero.HeroUpGradeControls.HeroSkillImg,skill.AtlasName ,skill.SpriteName)
	
	UIHero.HeroUpGradeControls.HeroSkillTypeImg.spriteName = UIstring.ItemFg[data.quality]
	UIHero.HeroUpGradeControls.HeroUpSkillName.text = UIstring.WordColor[nextData.Quality] ..nextSkill.Name .. "[-]"
	UIHero.HeroUpGradeControls.HeroUpSkillTypeImg.spriteName = UIstring.ItemFg[nextData.Quality]
	AtlasMsg.SetAtlas(UIHero.HeroUpGradeControls.HeroUpSkillImg,nextSkill.AtlasName ,nextSkill.SpriteName)

end

function UIHero:ShowChooseMatsInfo()
	GameMain.OpenObj(UIHero.HeroUpGradeControls.HeroChooseMatsPanel)
	UIHero.HeroUpGradeControls.HeroChooseMatsPanel.transform :GetComponent("UIWrap"):ResetTrans(#UIHero.HeroMatList)
	UIHero.HeroUpGradeControls.HeroMatsUIPanel.transform.localPosition = Vector3(0 , 0 , 0)
	UIHero.HeroUpGradeControls.HeroMatsUIPanel.clipOffset = Vector2(0 , 0)
	
		for i=1,24,1 do
			local data=
			{
				Index=i,
			}
			if UIHero.HeroMatGodList[i] == nil then
				MainGameUI.CreateLittleItem(tostring(i) , "HeroItem" , UIHero.HeroUpGradeControls.HeroMatGird , data , this.CreateHeroMatListCallBack , "UIHero") 
			else
				this:CreateHeroMatListCallBack(UIHero.HeroMatGodList[i],data)
			end
		end
end

function UIHero:CreateHeroMatListCallBack(_Gob , _Info)--创建物品列表并做信息显示

	if _Info.Index==24   then
		UIHero.HeroUpGradeControls.HeroMatGird.enabled = true
		UIHero.HeroUpGradeControls.HeroMatGird:Reposition()
		UIHero.HeroUpGradeControls.HeroChooseMatsPanel.transform:GetComponent("UIWrap"):SetData(#UIHero.HeroMatList , "UIHero")
	end

	local id = _Info.Index
	
	UIHero.HeroMatGodList[id]=_Gob
	
	local data = UIHero.HeroMatList[id]
	
	this:ShowHeroMatItem(data,_Gob)

end

function UIHero:ShowHeroMatItem(_Data , _God)
	
	local name = _God.transform:FindChild("name")
	GameMain.CloseObj(name)
	
	this:ShowHeroItem(_Data , _God)
end

function UIHero:ClearHeroMatList(num)
		UIHero.ChooseHeroMatList = {}
		UIHero.HeroUpGradeMatNum = 0
		GameMain.CloseObj(UIHero.HeroUpGradeControls.HeroChooseMatsPanel)
		
		for i=1,6,1  do
			if i<=tonumber(num) then
				GameMain.OpenObj(UIHero.HeroTeamGridGod[i])
				UIHero.HeroTeamGridGod[i].transform:FindChild("IMG"):GetComponent("UISprite").spriteName = nil
				GameMain.OpenObj(UIHero.HeroTeamGridGod[i].transform:FindChild("add"))
				UIHero.HeroTeamGridGod[i].transform:FindChild("FG"):GetComponent("UISprite").spriteName = UIstring.ItemFg[0]
				UIHero.HeroTeamGridGod[i].transform:FindChild("MatName"):GetComponent("UILabel").text = ""
				UIHero.HeroTeamGridGod[i].transform:FindChild("LV"):GetComponent("UILabel").text = ""
			else
				GameMain.CloseObj(UIHero.HeroTeamGridGod[i])
			end
		end
end
	
function UIHero:ShowClickMatItemInfo(_Index)			--点击了转生材料之后显示相应信息
	local data = UIHero.HeroMatList[_Index]

	local ItemGod = UIHero.HeroTeamGridGod[UIHero.HeroMatClickIndex]
	ItemGod.transform:FindChild("FG"):GetComponent("UISprite").spriteName = UIstring.ItemFg[data.quality]
	ItemGod.transform:FindChild("MatName"):GetComponent("UILabel").text = UIstring.WordColor[data.quality] .. tostring(data.nickname) .. "[-]"
	ItemGod.transform:FindChild("LV"):GetComponent("UILabel").text = "LV." .. tostring(data.lvl)
	GameMain.CloseObj(ItemGod.transform:FindChild("add"))
	local matSprite = ItemGod.transform:FindChild("IMG"):GetComponent("UISprite")
	AtlasMsg.SetAtlas(matSprite , data.AtlasName , data.SpriteName)

	GameMain.CloseObj(UIHero.HeroUpGradeControls.HeroChooseMatsPanel)
	
	table.insert(UIHero.ChooseHeroMatList , #UIHero.ChooseHeroMatList+1 , data)
	table.remove(UIHero.HeroMatList , _Index)
	
end

function UIHero:ShowHeroTrainPanel()--显示武将训练界面
	if UIHero.HeroTrainControls.HeroGrid==nil then
		this:GetHeroTrainControls()
	end
	UIHero.IsTrainPanel = true	
	GameMain.OpenObj(UIHero.HeroInfoPanel)
	GameMain.OpenObj(UIHero.HeroTrainPanel)
	GameMain.CloseObj(UIHero.HeroUpGradePanel)
	GameMain.CloseObj(UIHero.HeroInfoControls.ItemsPanel)
	GameMain.CloseObj(UIHero.HeroInfoControls.EquipPanel)
	GameMain.CloseObj(UIHero.HeroInfoControls.CloseBtn)
--	UIHero.HeroInfoControls.Title.text = "训 练"
	GameMain.CloseObj(UIHero.HeroInfoControls.Btns.gameObject)

	this:ShowTrainColdInfo()
	this:ShowTrainInfo(UIHero.HeroList[UIHero.ClickTempHeroIndex])
	this:ShowTrainOpenInfo()
	this:ShowTrainCountInfo()
end

function UIHero:ShowTrainCountInfo()
	UIHero.HeroTrainControls.TrainCount.text = "训练队列:"..UIHero.CurTrainCount.."/" .. UIHero.TrainLimitCount
end

function UIHero:ShowTrainItemInfo(_Lvl)
	local normal = RoleDataSys.GetRoleTrain8(_Lvl)
	UIHero.HeroTrainControls.NormalCostCount.text = tostring(normal)
	local better = RoleDataSys.GetRoleTrain12(_Lvl)  
	UIHero.HeroTrainControls.BetterCostCount.text = tostring(better)
	local best = RoleDataSys.GetRoleTrain24(_Lvl)
	UIHero.HeroTrainControls.BestCostCount.text = tostring(best)
end

function UIHero:ShowTrainOpenInfo()
	if VipSys.VipLevel>=1 then
		GameMain.CloseObj(UIHero.HeroTrainControls.NoOpenBestTrain)
		GameMain.OpenObj(UIHero.HeroTrainControls.OpenBestTrain)
		local data = ItemDataConfig.GetItemDBConfig(UIstring.VipTrainId)
		AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BestTrainItemImg , data.AtlasName , data.SpriteName)
	else
		GameMain.OpenObj(UIHero.HeroTrainControls.NoOpenBestTrain)
		GameMain.CloseObj(UIHero.HeroTrainControls.OpenBestTrain)
	end
end

function UIHero:ShowTrainHelpInfo()
	GameMain.OpenObj( UIHero.HeroTrainControls.HelpPanel)
	local helpInfo = TipsConfig.GetDataById(201)
		
	UIHero.HeroTrainControls.HelpPanelInfo.text = helpInfo.Description
	
end

function UIHero:CloseTrainHelpInfo()
	GameMain.CloseObj( UIHero.HeroTrainControls.HelpPanel)
end

function UIHero:ShowClearColdBack()
	this:ShowTrainColdInfo()
	if UIHero.IsAutoAddExp == true then
		local str = "使用1个加速符,增加100经验"
		this:ShowAutoInfo(str)
		TimeControl.LoginTime(1,"AutoAddHeroExpTime")
		GameMain.AddUpdateLua(this.UpdateAutoAddExp)
	end
end

function UIHero:ShowTrainColdInfo()
	local itemCount = ItemPackageSys.GetItemCountById(UIstring.AddExpItem)
	UIHero.HeroTrainControls.AddExpItem.text = "剩余突飞令：" .. itemCount
	
	local speedCount = ItemPackageSys.GetItemCountById(UIstring.CollectSpeedId)
	UIHero.HeroTrainControls.SpeedItem.text = "剩余加速符：" .. speedCount

	this:ShowAddExpCDInfo()
end

function UIHero:OpenAutoPanel()
	GameMain.OpenObj(UIHero.HeroTrainControls.AutoPanel)
	if UIHero.AutoControls.Info == nil then
		this:GetAutoControls()
	end
	UIHero.IsAutoAddExp = false
	UIHero.IsAutoSpeed = false
	this:ShowAutoUseSpeedInfo()
	UIHero.AutoControls.Info.text = ""
end

function UIHero:GetAutoControls()
	UIHero.AutoControls.Info = UIHero.HeroTrainControls.AutoPanel.transform:FindChild("text/Info"):GetComponent("UILabel")
	UIHero.AutoControls.SpeedBtn = UIHero.HeroTrainControls.AutoPanel.transform:FindChild("chooseUseSpeed")
	UIHero.AutoControls.NoSpeedBtn = UIHero.HeroTrainControls.AutoPanel.transform:FindChild("noChooseSpeed")
end

function UIHero:ToStartAutoAddExp()
	UIHero.IsAutoAddExp = true
	this:SendWebToAddExp(1)
end

function UIHero:ToStopAutoAddExp()
	UIHero.IsAutoAddExp = false
	GameMain.DelUpdateLua(this.UpdataAddExpTime)
end

function UIHero:IsUseSpeedItem(_IsUse)
	UIHero.IsAutoSpeed = _IsUse
	this:ShowAutoUseSpeedInfo()
end

function UIHero:ShowAutoUseSpeedInfo()
	if UIHero.IsAutoSpeed == true then
		GameMain.CloseObj(UIHero.AutoControls.SpeedBtn)
		GameMain.OpenObj(UIHero.AutoControls.NoSpeedBtn)
	else
		GameMain.OpenObj(UIHero.AutoControls.SpeedBtn)
		GameMain.CloseObj(UIHero.AutoControls.NoSpeedBtn)
	end
end

function UIHero:CloseAutoPanel()
	this:ToStopAutoAddExp()
	GameMain.CloseObj(UIHero.HeroTrainControls.AutoPanel)
end

function UIHero:UIHand(_LuaName , _Gob)
MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseSuccessGradeBtn" then
		this:CloseSuccessGradePanel()
	end
	if _Gob.name=="CloseHeroInfo" then
		this:CloseObj(UIHero.UIHeroGob.gameObject)
		
		this:CloseSendWebEquip()
        TeamSys.SaveThePveTeam()
	end
	
	if _Gob.name=="ZhuanShengBtn" then
		this:CloseSendWebEquip()
        TeamSys.SaveThePveTeam()
		this:ShowHeroUpGradePanel()
	end
	if _Gob.name=="CloseHeroUpGrade" then 
		this:ShowHeroInfoPanel()	
	end

	if _Gob.name=="TrianBtn" then
		this:CloseSendWebEquip()
		this:ShowHeroTrainPanel()
	end
	if _Gob.name=="CloseHeroTrain" then
		this:ShowHeroInfoPanel()
	end
	if _Gob.name=="GuaShuaiBtn" then --挂帅 PVP
		this:ShowGuaShuaiInfo(1)
	end
	if _Gob.name=="JiePinBtn" then 
		this:ShowGuaShuaiInfo(2)
	end
	if _Gob.name=="WaitBtn" then --出站 PVE
		
		local num=0
		if UIHero.HeroInfoControls.HeroWaitObj.activeInHierarchy==true then	
			num=1  --侯战斗
		else
			num=2  --出站
		end
		this:ShowGoAtkInfo(num)

	end

	local ItemKey = tonumber(_Gob.name)
    local ParentName = _Gob.transform.parent.name
       if ItemKey~=nil and ParentName=="HeroGrid" then
           if ItemKey~=nil and UIHero.HeroList[ItemKey]~=nil then     
				 --先发送数据，然后再显示武将信息
				 this:SendWebAboutEquip(ItemKey)    
                         
                 return
           end
       end
	   if ItemKey~=nil and ParentName == "HeroMatsGrid" then
			this:ShowClickMatItemInfo(ItemKey)
	   end
		
	   if ItemKey~=nil and ParentName == "ItemsGrid" then
		
			this:ShowDressEquipListInfo(ItemKey)											--穿装备
	   end
		
	   if ItemKey~=nil and ParentName == "EquipList" then
			this:ShowUpEquipListInfo(tonumber(ItemKey))										--卸装备
	   end

	 if _Gob.transform.parent.parent.name == "TeamGrid" then
		UIHero.HeroMatClickIndex = tonumber(_Gob.transform.parent.name)
		this:ShowChooseMatsInfo()															--显示转生需要的材料list
	 end
	
	if _Gob.name == "Mask" and _Gob.transform.parent.name == "ChooseMats" then
		GameMain.CloseObj(UIHero.HeroUpGradeControls.HeroChooseMatsPanel)
	end
	if _Gob.name == "Turn" then
		this:HeroUpGrade()		--转生
	end

	if _Gob.name == "NormalTrainBtn" then
		--普通训练
		this:SendWebToTrain(1)
	end
	if _Gob.name == "BetterTrainBtn" then
		--强化训练
		this:SendWebToTrain(2)
	end
	if _Gob.name == "BestTrainBtn" then
		--vip 训练
		this:SendWebToTrain(3)
	end
	if _Gob.name == "HeroTrianWhy" then
		this:ShowTrainHelpInfo()
	end
	if _Gob.name == "CloseHelpBtn" then
		this:CloseTrainHelpInfo()
	end

	if _Gob.name == "Fly" then
		--突飞
		this:SendWebToAddExp(1)
	end
	if _Gob.name == "HurryUp" then
		--猛进
		this:SendWebToAddExp(2)
	end
	if _Gob.name == "ColdBtn" then
		--清除加经验CD
		this:ClearAddExpCD()
	end
	if _Gob.name == "AutoAddExpBtn" then
		this:OpenAutoPanel()
	end
	if _Gob.name == "StartAutoBtn" then
		this:ToStartAutoAddExp()
	end
	if _Gob.name == "CloseAutoBtn" then
		this:ToStopAutoAddExp()
	end
	if _Gob.name == "CloseAutoPanel" then
		this:CloseAutoPanel()
	end
	if _Gob.name == "chooseUseSpeed" then
		this:IsUseSpeedItem(true)
	end
	if _Gob.name == "noChooseSpeed" then
		this:IsUseSpeedItem(false)
	end
end

function UIHero:ClearAddExpCD()
	local itemcount = ItemPackageSys.GetItemCountById(UIstring.CollectSpeedId)
	if itemcount<=0 then
		DataUIInstance.PopTip("道具不足")
		return
	end
	HeroPackageSys.ClearAddExpCD()
end

function UIHero:ClearAddExpCDCallBack()
	this:ShowTrainColdInfo()
end

function UIHero:ShowAddExpCDInfo()				--显示突飞，猛进的CD时间
	local time = TimeControl.GetTime("AddExpCDTime")
	if time == nil then
		this:DelAddExpTime()
		return
	end
	if time<=0 then
		this:DelAddExpTime()
		return
	end
	GameMain.OpenObj(UIHero.HeroTrainControls.ColdBtn)
	GameMain.AddUpdateLua(this.UpdataAddExpTime)
end

function UIHero:UpdataAddExpTime()
	local time = TimeControl.GetTime("AddExpCDTime")
	if time~=nil then
		if time<=0 then
			this:DelAddExpTime()
		else
			local str =  TimeControl.GetTimeString(time)
			if time>10*60 then
				UIHero.HeroTrainControls.ColdTime.text = UIstring.Red .. "冷却时间：" .. str .. "[-]"
			else
				UIHero.HeroTrainControls.ColdTime.text = "冷却时间：" .. str
			end
		end
	else
		this:DelAddExpTime()
	end
	
end

function UIHero:DelAddExpTime()
	GameMain.DelUpdateLua(this.UpdataAddExpTime)
	GameMain.CloseObj(UIHero.HeroTrainControls.ColdBtn)
end

function UIHero:SendWebToAddExp(_Type)
	local data = UIHero.HeroList[UIHero.ClickTempHeroIndex]
	local isCanAddExp = data:IsCanAddExp()	
	if isCanAddExp == false then
		DataUIInstance.PopTip("请提升主角等级")
		return
	end
	local itemCount = ItemPackageSys.GetItemCountById(UIstring.AddExpItem)

	if itemCount<=0 then
		DataUIInstance.PopTip("道具不足")
		return
	end
	if _Type == 1 then
		local time = TimeControl.GetTime("AddExpCDTime")
		if time~=nil then
			if time>=10*60 then
				if UIHero.IsAutoAddExp == true then
					if UIHero.IsAutoSpeed == true then
						this:ClearAddExpCD()
					else
						DataUIInstance.PopTip("冷却时间内不可以突飞")
					end
					return
				end
				DataUIInstance.PopTip("冷却时间内不可以突飞")
				return
			end
		end
	end
	if _Type == 2 then
		local listCount = data:GetAddExpItemCount()
		if itemCount< listCount[1] then
			DataUIInstance.PopTip("道具不足")
			return
		end
		local speedCount = ItemPackageSys.GetItemCountById(UIstring.CollectSpeedId)
		if speedCount<listCount[2] then
			DataUIInstance.PopTip("道具不足")
			return
		end
		GameMain.CloseObj(UIHero.HeroInfoControls.MengJinEff)
		GameMain.OpenObj(UIHero.HeroInfoControls.MengJinEff)
	end
	data:AddExpByItem(_Type)
end

function UIHero:ShowAddExpByItemCallBack(data)			--显示突飞猛进之后的信息
	UIHero.HeroList[UIHero.ClickTempHeroIndex] = data
	this:ShowHeroItem(UIHero.HeroList[UIHero.ClickTempHeroIndex] , UIHero.HeroGodList[UIHero.ClickTempHeroIndex])
	this:ShowHeroItemPanel(UIHero.ClickTempHeroIndex)
	this:ShowTrainColdInfo()
	if UIHero.IsAutoAddExp == true then
		local str = "消耗1个突飞令,增加100经验"
		this:ShowAutoInfo(str)
		TimeControl.LoginTime(1,"AutoAddHeroExpTime")
		GameMain.AddUpdateLua(this.UpdateAutoAddExp)
	end
end

function UIHero:ShowAutoInfo(_Str)
	local strs = UIHero.AutoControls.Info.text
	if strs == "" then
		strs = _Str
	else
		strs = strs .. "\n" .. _Str
	end
	UIHero.AutoControls.Info.text = strs
end

function UIHero.UpdateAutoAddExp()
	local time = TimeControl.GetTime("AutoAddHeroExpTime")
	if time <= 0 then
		this:SendWebToAddExp(1)
		GameMain.DelUpdateLua(this.UpdateAutoAddExp)
	end
end

function UIHero:ShowTrainInfo(data)
	this:ShowNoTrainInfo()
	if data == nil then
		return
	end
	local curLvlExp = data:GetLvlAndExp()
	this:ShowTrainItemInfo(curLvlExp[1])
	if data.TrainType == 0 then
		local train = UIHero.HeroGodList[UIHero.ClickTempHeroIndex].transform:FindChild("train")
		GameMain.CloseObj(train)
--		this:ShowNormalBtnInfo()
		return
	end
	this:ShowGrayBtnInfo(data.TrainType)
	GameMain.AddUpdateLua(this.UpdateTime)
end

function UIHero:SendWebTrainAfterInfo(_Data)
	MusicManagerSys.Train()
	UIHero.HeroList[UIHero.ClickTempHeroIndex] = _Data
	
	local train = UIHero.HeroGodList[UIHero.ClickTempHeroIndex].transform:FindChild("train")
	GameMain.OpenObj(train)
	this:ShowTrainInfo(UIHero.HeroList[UIHero.ClickTempHeroIndex])
end

function UIHero:SendWebToTrain(_Type)
	local data = UIHero.HeroList[UIHero.ClickTempHeroIndex]
	if data == nil then
		return
	end
	local lvl = data:GetLvl()
    
	if lvl >= ClinetInfomation.Lvl - 1 then
       DataUIInstance.PopTip("武将等级不得高于等于主公")
       return
    end
	if data.TrainType == 0 then
		local isCanTrain = data:IsCanAddExp()	
		if isCanTrain == false then
			DataUIInstance.PopTip("请提升主角等级")
			return
		end
		if UIHero.CurTrainCount>=UIHero.TrainLimitCount then
			DataUIInstance.PopTip("训练个数已经达到上限")
			return
		end
		if _Type == 1 then
			local ownCount = ClinetInfomation.GetCoin()
			local needCount = RoleDataSys.GetRoleTrain8(lvl)
			if ownCount<needCount then
				DataUIInstance.PopTip("金钱不足")
				return
			end
		end
		if _Type ==2 then
			local ownCount = ClinetInfomation.GetCoin()
			local needCount = RoleDataSys.GetRoleTrain12(lvl)
			if ownCount<needCount then
				DataUIInstance.PopTip("金钱不足")
				return
			end
		end
		if _Type == 3 then
			if VipSys.VipLevel<1 then
				DataUIInstance.PopTip("Vip等级不足")
				return
			end
			local count = ItemPackageSys.GetItemCountById(UIstring.VipTrainId)
			local needCount = RoleDataSys.GetRoleTrain24(lvl)
			if count<needCount then
               DataUIInstance.PopTip("专家训练符不足")
				return
			end
		end
		UIHero.CurTrainCount = UIHero.CurTrainCount + 1
		data:HeroTrain(_Type)
	else
		if data.TrainType == _Type then
			this:PopConfrimPanel(data)
		else
			DataUIInstance.PopTip("武将训练中")
		end
	end
	this:ShowTrainCountInfo()
end

function UIHero:PopConfrimPanel(data)
	DataUIInstance.PopConfirmPanel("是否确认终止此次训练？" , this.ConfirmCancelTrain , nil)
end

function UIHero:ConfirmCancelTrain()
	UIHero.CurTrainCount = UIHero.CurTrainCount -1
	local data = UIHero.HeroList[UIHero.ClickTempHeroIndex]
	data:StopHeroTrain()
	data.TrainType = 0
	local train = UIHero.HeroGodList[UIHero.ClickTempHeroIndex].transform:FindChild("train")
	GameMain.CloseObj(train)
	this:ShowNoTrainInfo()
	this:ShowTrainCountInfo()
end

function UIHero:ShowNoTrainInfo()
	this:ShowNormalBtnInfo()
	GameMain.DelUpdateLua(this.UpdateTime)
	GameMain.CloseObj(UIHero.HeroTrainControls.NormalTrainIng)
	GameMain.CloseObj(UIHero.HeroTrainControls.BetterTrainIng)
	GameMain.CloseObj(UIHero.HeroTrainControls.BestTrainIng)
	GameMain.OpenObj(UIHero.HeroTrainControls.NormalNoTrain)
	GameMain.OpenObj(UIHero.HeroTrainControls.BetterNoTrain)
	GameMain.OpenObj(UIHero.HeroTrainControls.BestNoTrain)
end

function UIHero:ShowGrayBtnInfo(_Type)--1普通 2 高级 3 VIP
	if _Type == 1 then
		AtlasMsg.SetAtlas(UIHero.HeroTrainControls.NormalTrainBg , "UI_ZQ_Button" , "daanniu" )
		AtlasMsg.SetAtlas(UIHero.HeroTrainControls.NormalCostImg , "MainCityItems" , "qianbitubiao")
		AtlasMsg.SetAtlas(UIHero.HeroTrainControls.NormalTimeImg , "UI_ZQ_Index2" , "shijian")
	else
		AtlasMsg.SetGrayAtlas(UIHero.HeroTrainControls.NormalTrainBg,"daanniu",1)
		AtlasMsg.SetGrayAtlas(UIHero.HeroTrainControls.NormalCostImg , "qianbitubiao" ,1)
		AtlasMsg.SetGrayAtlas(UIHero.HeroTrainControls.NormalTimeImg ,  "shijian" ,1)
	end
	if _Type == 2 then
		AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BetterTrainBg , "UI_ZQ_Button" , "daanniu" )
		AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BetterCostImg , "MainCityItems" , "qianbitubiao")
		AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BetterTimeImg , "UI_ZQ_Index2" , "shijian")
	else
		AtlasMsg.SetGrayAtlas(UIHero.HeroTrainControls.BetterTrainBg,"daanniu",1)
		AtlasMsg.SetGrayAtlas(UIHero.HeroTrainControls.BetterCostImg , "qianbitubiao" ,1)
		AtlasMsg.SetGrayAtlas(UIHero.HeroTrainControls.BetterTimeImg ,  "shijian" ,1)
	end
	if _Type == 3 then
		AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BestTrainBg , "UI_ZQ_Button" , "daanniu" )
		AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BestCostImg , "MainCityItems" , "qianbitubiao")
		AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BestTimeImg , "UI_ZQ_Index2" , "shijian")
	else
		AtlasMsg.SetGrayAtlas(UIHero.HeroTrainControls.BestTrainBg,"daanniu",1)
		AtlasMsg.SetGrayAtlas(UIHero.HeroTrainControls.BestCostImg , "qianbitubiao" ,1)
		AtlasMsg.SetGrayAtlas(UIHero.HeroTrainControls.BestTimeImg ,  "shijian" ,1)
	end
end

function UIHero:ShowNormalBtnInfo()
	AtlasMsg.SetAtlas(UIHero.HeroTrainControls.NormalTrainBg , "UI_ZQ_Button" , "daanniu" )
	AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BetterTrainBg , "UI_ZQ_Button" , "daanniu" )
	AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BestTrainBg , "UI_ZQ_Button" , "daanniu" )
	AtlasMsg.SetAtlas(UIHero.HeroTrainControls.NormalTimeImg , "UI_ZQ_Index2" , "shijian")
	AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BetterTimeImg , "UI_ZQ_Index2" , "shijian")
	AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BestTimeImg , "UI_ZQ_Index2" , "shijian")
	AtlasMsg.SetAtlas(UIHero.HeroTrainControls.NormalCostImg , "MainCityItems" , "qianbitubiao")
	AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BetterCostImg , "MainCityItems" , "qianbitubiao")
	AtlasMsg.SetAtlas(UIHero.HeroTrainControls.BestCostImg , "MainCityItems" , "qianbitubiao")
end

function UIHero:UpdateTime()
	local data = UIHero.HeroList[UIHero.ClickTempHeroIndex]
	local timeName = "Train" .. data.UUID
	local time = TimeControl.GetTime(timeName)
	
	if data.TrainType == 1 then
		--普通训练
		if time<=0 then
			GameMain.CloseObj(UIHero.HeroTrainControls.NormalTrainIng)
			GameMain.OpenObj(UIHero.HeroTrainControls.NormalNoTrain)
			GameMain.DelUpdateLua(this.UpdateTime)
			return
		end
		GameMain.OpenObj(UIHero.HeroTrainControls.NormalTrainIng)
		GameMain.CloseObj(UIHero.HeroTrainControls.NormalNoTrain)
		UIHero.HeroTrainControls.NormalTrainIngTxt.text = TimeControl.GetTimeString(time)
	end
	if data.TrainType == 2 then
		--高级训练
		if time<=0 then
			GameMain.CloseObj(UIHero.HeroTrainControls.BetterTrainIng)
			GameMain.OpenObj(UIHero.HeroTrainControls.BetterNoTrain)
			GameMain.DelUpdateLua(this.UpdateTime)
			return
		end
		GameMain.OpenObj(UIHero.HeroTrainControls.BetterTrainIng)
		GameMain.CloseObj(UIHero.HeroTrainControls.BetterNoTrain)
		UIHero.HeroTrainControls.BetterTrainIngTxt.text = TimeControl.GetTimeString(time)
	end
	if data.TrainType == 3 then
		--Vip训练
		if time<=0 then
			GameMain.CloseObj(UIHero.HeroTrainControls.BestTrainIng)
			GameMain.OpenObj(UIHero.HeroTrainControls.BestNoTrain)
			GameMain.DelUpdateLua(this.UpdateTime)
			return
		end
		GameMain.OpenObj(UIHero.HeroTrainControls.BestTrainIng)
		GameMain.CloseObj(UIHero.HeroTrainControls.BestNoTrain)
		UIHero.HeroTrainControls.BestTrainIngTxt.text = TimeControl.GetTimeString(time)
	end

end


function UIHero:HeroUpGrade()				
	local len = #UIHero.ChooseHeroMatList
	if #UIHero.ChooseHeroMatList < UIHero.HeroUpGradeMatNum then
		DataUIInstance.PopTip("转生的所需的材料不足")
		return
	end
	local coin = ClinetInfomation:GetCoin()
	local data = UIHero.HeroList[UIHero.ClickTempHeroIndex]
	if coin< data.UpGradeCost then
		DataUIInstance.PopTip("铜钱不足")
		DataUIInstance.OpenCollect()
		return
	end
	local msg = ""
	for key,value in pairs(UIHero.ChooseHeroMatList) do
		if value.quality>=4 and value.quality<value.Aptitude then
			msg = msg .. UIstring.WordColor[tonumber(value.quality)] .."["..value.nickname .."]".."[-]"
		end
	end
	if msg~="" then
		msg = msg .. "为可以转生的武将 , 您是否确定将其作为转生材料？" 
	else
		msg = tostring(UIHero.HeroUpGradeMatNum).."个材料武将转生后会消失" .. "\n" .. UIstring.Red .. "是否确认转生？".."[-]"
	end
	DataUIInstance.PopConfirmPanel(msg , this.IsUpGrade)
end

function UIHero:IsUpGrade()			--确认
	local data = UIHero.HeroList[UIHero.ClickTempHeroIndex]
	local id = 0
	for key,value in pairs(UIHero.ChooseHeroMatList) do
		if value.UUID == ClinetInfomation.GuaShuaiUUID then
			id = 1
		end
		TeamSys.RePveHero(value)
	end
	if id == 0 then
		data:ChangeGrade(UIHero.ChooseHeroMatList , 0)
	else
		if #UIHero.HeroMatList>0 then
			data:ChangeGrade(UIHero.ChooseHeroMatList , UIHero.HeroMatList[1].UUID)
		else
			data:ChangeGrade(UIHero.ChooseHeroMatList , 1)
		end
	end
end

function UIHero:ShowUpGradeAfterInfo()
	local data=UIHero.HeroList[UIHero.ClickTempHeroIndex]
	local nextData = RoleDataSys.GetRoleById(data.AdvanceId)
	this:ShowSuccessGradePanel(data , nextData)
	this:ShowHeroInfoPanel()
end

function UIHero:ShowSuccessGradePanel(_BeforeData , _NextData)		--显示转生成功信息
	GameMain.OpenObj(UIHero.HeroInfoControls.SuccessGradePanel)
	if UIHero.SucessGradeControls.beforeAtk == nil then
		this:GetSuccessGradeControls()
	end
	AtlasMsg.SetAtlas(UIHero.SucessGradeControls.beforeImg , _BeforeData.AtlasName , _BeforeData.SpriteName)
	AtlasMsg.SetAtlas(UIHero.SucessGradeControls.nextImg , _NextData.AtlasName , _NextData.SpriteName)
	UIHero.SucessGradeControls.beforeQuality.spriteName = UIstring.ItemFg[_BeforeData.quality]
	UIHero.SucessGradeControls.beforeFG.spriteName = UIstring.ItemFg[_BeforeData.quality]
	UIHero.SucessGradeControls.nextQuality.spriteName = UIstring.ItemFg[_NextData.Quality]
	UIHero.SucessGradeControls.nextFG.spriteName = UIstring.ItemFg[_NextData.Quality]
	UIHero.SucessGradeControls.NextSkillQuality.spriteName = UIstring.ItemFg[_NextData.Quality]
	UIHero.SucessGradeControls.BeforeSkillQuality.spriteName = UIstring.ItemFg[_BeforeData.quality]
	local skillData = RoleSkillConfig.GetRoleSkillById(_BeforeData.SkillId)
	AtlasMsg.SetAtlas(	UIHero.SucessGradeControls.BeforeSkillImg ,skillData.AtlasName , skillData.SpriteName)
	local nextSkill = RoleSkillConfig.GetRoleSkillById(_NextData.Spell_Id)
	AtlasMsg.SetAtlas(UIHero.SucessGradeControls.NextSkillImg , nextSkill.AtlasName , nextSkill.SpriteName)

	local beforeAtk = _BeforeData:GetAtk()
	UIHero.SucessGradeControls.beforeAtk.text = "攻击:" ..beforeAtk
	local beforeHp = _BeforeData:GetLife()
	UIHero.SucessGradeControls.beforeHp.text = "血量:" .. beforeHp
	local beforeAtkSpeed = _BeforeData:GetAtkSpeed()
	UIHero.SucessGradeControls.beforeAtkSpeed.text = "攻击速度:" .. beforeAtkSpeed
	UIHero.SucessGradeControls.beforeAtkDistance.text = "攻击距离:" .. _BeforeData.AttackRange
--	local nextAtk = RoleDataSys.GetRoleAtk(nextData , data.lvl)
	local nextAtk =  RoleDataSys.GetRoleAtk(_NextData , _BeforeData.lvl)
	local nextHp = RoleDataSys.GetRoleLife(_NextData , _BeforeData.lvl)
	local nextAtkSpeed = RoleDataSys.GetRoleAtkSpeed(_NextData , _BeforeData.lvl)
	local atkAddStr = this:GetSuccessGradeAttr(beforeAtk , nextAtk)
	local hpAddStr = this:GetSuccessGradeAttr(beforeHp , nextHp)
	local atkSpeedAddStr = this:GetSuccessGradeAttr(beforeAtkSpeed , nextAtkSpeed)
	local atkDistanceStr = this:GetSuccessGradeAttr(_BeforeData.AttackRange , _NextData.AttackRange)
	
	UIHero.SucessGradeControls.nextAtk.text = "攻击:" .. nextAtk .. atkAddStr
	UIHero.SucessGradeControls.nextHp.text = "血量:" .. nextHp .. hpAddStr
	UIHero.SucessGradeControls.nextAtkSpeed.text = "攻击速度:" .. nextAtkSpeed .. atkSpeedAddStr
	UIHero.SucessGradeControls.nextAtkDistance.text = "攻击距离:" .. _NextData.AttackRange .. atkDistanceStr
end

function UIHero:GetSuccessGradeAttr(_Before , _Next)
	local str = ""
	local del = _Next - _Before
	if del>0 then
		str = UIstring.Green .. "(+" .. del .. ")" .. "[-]"
	end
	return str
end

function UIHero:CloseSuccessGradePanel()
	GameMain.CloseObj(UIHero.HeroInfoControls.SuccessGradePanel)
end

function UIHero:ShowGuaShuaiInfo(num)		--挂帅/解雇后相关显示
	
	if UIHero.ClickTempHeroIndex ~=0 then
		local shuai=UIHero.HeroGodList[UIHero.ClickTempHeroIndex].transform:FindChild("Shuai")
		local zhan = UIHero.HeroGodList[UIHero.ClickTempHeroIndex].transform:FindChild("Zhan") 
		local data=UIHero.HeroList[UIHero.ClickTempHeroIndex]
		if num==1 then  --挂帅
			data:UpPvpHero()
			if UIHero.GuaShuaiHeroIndex~=0 then
				this:CloseObj(UIHero.HeroGodList[UIHero.GuaShuaiHeroIndex].transform:FindChild("Shuai"))
				UIHero.HeroList[UIHero.GuaShuaiHeroIndex]:DownPvpHero()
			end
			UIHero.GuaShuaiHeroIndex=UIHero.ClickTempHeroIndex
			
			this:CloseObj(UIHero.HeroInfoControls.HeroGuaShuaiBtn.gameObject)
			this:OpenObj(shuai.gameObject)
			DataUIInstance.PopTip("挂帅成功")
			MusicManagerSys.HeroCommand()
		end
		if num==2 then  --解雇
			if data:GetEquipLen() ~= 0 then
				DataUIInstance.PopTip("请先卸载装备")
				return
			end
			local isCanAdd = TeamSys.GetUpTeams(data.UUID)
			if isCanAdd == false then
				DataUIInstance.PopTip("该武将已在阵上")
				return
			end
			if UIHero.GuaShuaiHeroIndex ~=0 and UIHero.GuaShuaiHeroIndex == UIHero.ClickTempHeroIndex then
				UIHero.GuaShuaiHeroIndex=0
				this:CloseObj(shuai.gameObject)
			end
			if data.IsUp == true then
				this:CloseObj(zhan.gameObject)
				this:CloseObj(UIHero.HeroInfoControls.HeroWaitObj.transform.parent)
			end
			this:CloseObj(UIHero.HeroInfoControls.HeroJiePinBtn.gameObject)
			this:CloseObj(UIHero.HeroInfoControls.HeroGuaShuaiBtn.gameObject)
			this:CloseObj(UIHero.HeroInfoControls.HeroTrianBtn.gameObject)
			this:CloseObj(UIHero.HeroInfoControls.HeroZhuanShengBtn)
			this:CloseObj(UIHero.HeroInfoControls.HeroWaitObj.transform.parent)
			if data.UUID == ClinetInfomation.GuaShuaiUUID then
				if UIHero.ClickTempHeroIndex == 1 then
					if UIHero.HeroList[2] ~= nil then
						local curUUID = UIHero.HeroList[2].UUID
						data:RePvpHero(curUUID)
					else
						data:RePvpHero(0)
						GameMain.CloseObj(UIHero.HeroInfoControls.HeroInfos)
						GameMain.CloseObj(UIHero.HeroInfoControls.Btns)
					end
				else
					local curUUID = UIHero.HeroList[1].UUID
					data:RePvpHero(curUUID)
				end
			else
				data:RePvpHero(0)
			end
			DataUIInstance.PopTip("解雇成功")	
			MusicManagerSys.HeroFire()
		end
	this:ShowHeroInfoEff(UIHero.HeroGodList[UIHero.ClickTempHeroIndex])
	end
end

function UIHero:ShowHeroInfoEff(_God)
	UIHero.HeroInfoControls.Eff.transform.position = _God.transform.position
	GameMain.CloseObj(UIHero.HeroInfoControls.Eff)
	GameMain.OpenObj(UIHero.HeroInfoControls.Eff)
end


function UIHero:ShowGoAtkInfo(num)  --出战/侯战后相关显示

	if UIHero.ClickTempHeroIndex~=0 then
		local zhan=UIHero.HeroGodList[UIHero.ClickTempHeroIndex].transform:FindChild("Zhan")
		local data=UIHero.HeroList[UIHero.ClickTempHeroIndex]
		
		if num==1 then
			this:CloseObj(UIHero.HeroInfoControls.HeroWaitObj)
			this:OpenObj(UIHero.HeroInfoControls.HeroZhanObj)
			this:CloseObj(zhan.gameObject)
--			TeamSys.RePveHero(data)
			UIHero.GoAtkCount = UIHero.GoAtkCount -1
			data:RePveHero()
			DataUIInstance.PopTip("候战成功")
		elseif num==2 then
			if UIHero.GoAtkCount>=UIHero.GoAtkMaxCount then
				DataUIInstance.PopTip("出战人数已达到最高")
				return 
			end
			this:OpenObj(zhan.gameObject)
			this:CloseObj(UIHero.HeroInfoControls.HeroZhanObj)
			this:OpenObj(UIHero.HeroInfoControls.HeroWaitObj)
--			TeamSys.UpPveHero(data)
			UIHero.GoAtkCount = UIHero.GoAtkCount +1
			data:UpPveHero()
			DataUIInstance.PopTip("出战成功")
		end
		this:ShowHeroInfoEff(UIHero.HeroGodList[UIHero.ClickTempHeroIndex])
	MusicManagerSys.HeroAtkOrStop()
	end
end

UIHero.PressGod = nil

function UIHero:UIOnPress(_LuaName , _Gob , _isPress)--按钮按下显示相应的信息
	
	if _isPress==false then  
		this:CloseTipsPanel()
	end                                
     
	if _isPress==true then
		UIHero.PressGod = _Gob
		
		TimeControl.LoginTime(UIHero.PressTimeDel,"heroTime")
		GameMain.AddUpdateLua(this.ShowPressTips)
		
	end
end

function UIHero:ShowPressTips()
	local _Gob = UIHero.PressGod
	local time = TimeControl.GetTime("heroTime")
	if time<=0 then
		if _Gob.name == "SkillIcon" then
			this:ShowSkillTipsPanel(_Gob)
		end
		local ItemKey = tonumber(_Gob.name)
		
		if ItemKey ~=nil then
			local ItemParentName = _Gob.transform.parent.name
			if ItemParentName=="HeroGrid" then
				if UIHero.HeroList[ItemKey]~=nil then                       --点击武将tips
					 this:ShowHeroTipsPanel(UIHero.HeroList[ItemKey],_Gob)             
					 return
				end
			 end
			if ItemParentName == "ItemsGrid" then
				local equipData = UIHero.HeroBagList[ItemKey]
				this:ShowEquipTisPanel(_Gob , equipData)
			end	
			if ItemParentName == "EquipList" then
				local heroData = UIHero.HeroList[UIHero.ClickTempHeroIndex]
				if heroData == nil then
					return
				end
				local uuid = heroData.Equips[ItemKey]
				if uuid == nil then
					return
				end
				local equipData = EquipSys.FindEquipByUUID(uuid)
				this:ShowEquipTisPanel(_Gob , equipData)	
			end
		end
		GameMain.DelUpdateLua(this.ShowPressTips)
	end
	
end

function UIHero:ShowEquipTisPanel(_Gob , equipData)
	local pos = _Gob.transform.position
	local vec = Vector3(pos.x,pos.y,-460)
	DataUIInstance.CreateTipsPanel( equipData, "Equip" , vec)
end

function UIHero:ShowHeroTipsPanel(heroData , obj)--武将tips信息显示
	local pos = obj.transform.position
	local vec = Vector3(pos.x,pos.y,-460)
	DataUIInstance.CreateTipsPanel( heroData, "Hero" , vec)
end

function UIHero:ShowSkillTipsPanel(_Gob)		--技能tips显示
	if UIHero.ClickTempHeroIndex~=0 then
		local data = UIHero.HeroList[UIHero.ClickTempHeroIndex]
		local skillData = RoleSkillConfig.GetRoleSkillById(data.SkillId)
		if skillData~=nil then
			local pos = _Gob.transform.position
			local equipList = data:GetEquipBattleValue()
			local atk = data:GetAtk() + equipList.Atk
			local hp = data:GetLife() + equipList.Hp
			local list = {}
			list["atk"] = atk
			list["hp"] = hp
			list["qlvl"] = data.qualityLvl
			list["q"] = data.quality
			list["lvl"] = data:GetLvl()
			list["skill"] = skillData
			local vec = Vector3(pos.x,pos.y,0)
			DataUIInstance.CreateTipsPanel( list , "Skill" , vec)
		end
	end
end

function UIHero:CloseTipsPanel()
	TimeControl.SetTime("heroTime" , 0)	
	GameMain.DelUpdateLua(this.ShowPressTips)
	local uiTar = MainGameUI.FindPanelTarget("TipsPanel")
	if uiTar~=nil then
		uiTar:ClosePanel()
	end
end
function UIHero:ReleasPanel()
	UIHero.UIHeroGob = nil
	UIHero.PressGod = nil
	UIHero.HeroUpGradePanel=nil
	UIHero.HeroInfoPanel=nil
	UIHero.HeroTrainPanel=nil

	UIHero.HeroInfoControls={}
	UIHero.HeroTrainControls={}
	UIHero.HeroUpGradeControls={}

	UIHero.ClickTempHeroIndex=0 --当前点击的那个英雄
	UIHero.GuaShuaiHeroIndex=0--当前挂帅的那个武将

	UIHero.HeroList= {}
	UIHero.HeroGodList = {}
	UIHero.HeroTempGodList = {} --用于第二次显示

	UIHero.HeroMatList = {}			--转生材料
	UIHero.HeroMatGodList = {}

	UIHero.HeroMatClickIndex = 0  --武将转生所需材质的点击Index
	UIHero.ChooseHeroMat = nil --武将转生选择的转生材料
	UIHero.ChooseHeroMatList = {} --武将转生选择的武将材料列表
	UIHero.PressTimeDel = 0.1

	UIHero.HeroBagList = {}
	UIHero.HeroBagGodList = {}
	UIHero.HeroTeamGridGod = {}		--选择的add材料list
	UIHero.HeroUpGradeMatNum = 0	--进阶需要的材料数目


	UIHero.TempHeroEquipUUIDs = {}--当前点击的武将的装备原始UUID
	UIHero.HeroEquipGod = --装备， 根据装备类型来定义
	{
		[1] = nil, --装备
		[2] = nil, --头
		[3] = nil, --胸
		[4] = nil, --护腕
		[5] = nil, --鞋子
		[6] = nil, --披风
		[7] = nil, --护符
		[8] = nil, --戒指
	} 

	UIHero.HeroTrainGodList = {}

	UIHero.TempHeroModel = nil		--显示的武将模型

	UIHero.GoAtkMaxCount = 5			--出站人数最多5位
	UIHero.GoAtkCount = 0				--出站的人数计数
	UIHero.SucessGradeControls = {}
	GameMain.DelUpdateLua(this.UpdateAutoAddExp)
	GameMain.DelUpdateLua(this.UpdateTime)
	GameMain.DelUpdateLua(this.UpdataAddExpTime)
end

function UIHero:ReleasData()			--清理数据
	HeroPackageSys.Heros = {}

	HeroPackageSys.QuilityHeros = {}

	HeroPackageSys.IsSort = true											--是否排序
	HeroPackageSys.TrainTempUUID = ""										--武将训练的临时UUID
	HeroPackageSys.TempAddExpUUID = ""	
    UIHero.GoAtkMaxCount = 5			--出站人数最多5位
	UIHero.GoAtkCount = 0				--出站的人数计数

	UIHero.HeroMusic = nil
end

--公用的方法
function UIHero:CloseObj(obj)
	if obj ~=nil then
		obj.gameObject:SetActive(false)
	end
	
end
function UIHero:OpenObj(obj)
	if obj ~= nil then
		obj.gameObject:SetActive(true)
	end
end


return UIHero