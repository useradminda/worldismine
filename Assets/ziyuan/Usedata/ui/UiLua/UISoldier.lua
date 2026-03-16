
UISoldier={}
local UISoldier = BasePanel:new()     
local this = UISoldier
UISoldier.UISoldierGob = nil

UISoldier.SoliderInfoPanel=nil
UISoldier.SoliderUpGradePanel=nil
UISoldier.SoliderTrainPanel=nil
UISoldier.SoliderTipsPanel=nil

UISoldier.SoliderInfoControls={}
UISoldier.SoliderUpGradeControls={}
UISoldier.SoliderTrainControls={}

UISoldier.GongSoliderGodList={}
UISoldier.DunSoliderGodList={}
UISoldier.QiangSoldierGodList={}
UISoldier.SliderGodList = {}
UISoldier.SliderTrainGodList = {}
UISoldier.AutoControls = {}

UISoldier.TempInfoModel = nil		--显示的武将模型
UISoldier.TempTrainModel = nil		--训练的武将模型
UISoldier.TempReGradeModel = nil	--武将升阶前的武将模型
UISoldier.TempUpGradeModel = nil	--武将升阶后的武将模型

UISoldier.clickInfoTemp = nil		--士兵信息面板中的选中的单个士兵
--Data
UISoldier.SoldierDataList={}		--所有的士兵数据
--UISoldier.ClickItemInfoIndex=0		--士兵信息面板中的选中的单个士兵
UISoldier.ClickTrainIndex=0 --士兵训练面板中选中的单个士兵

UISoldier.GongDataList = {}
UISoldier.QiangDataList = {}
UISoldier.DunDataList = {}

UISoldier.ClickInfoType = 0		--点击士兵的类型

UISoldier.FirstCreateInfoModel = false

UISoldier.TrainIndex = 0		--正在训练的武将标记一下

UISoldier.BattleFlagsAttr = nil	--战旗的相关属性

UISoldier.TrainLimitCount = 0	--士兵训练的限制
UISoldier.CurTrainCount = 0		--当前训练的个数

UISoldier.IsAutoSpeed = false		--是否自动加速
UISoldier.IsAutoAddExp = false		--是否自动加经验

UISoldier.SuccessGradeControls = {}
UISoldier.SoliderUpLimit = 1	--士兵进阶等级上限

function UISoldier:OpenUI(_PanelName , _LuaName)
	if UISoldier.UISoldierGob==nil then
		UISoldier.UISoldierGob=MainGameUI.FindPanel("UISoldier")
		UISoldier.SoliderInfoPanel=UISoldier.UISoldierGob.transform:FindChild("SoldierInfo")
		UISoldier.SoliderUpGradePanel=UISoldier.UISoldierGob.transform:FindChild("SoldierUpGrade")
		UISoldier.SoliderTrainPanel=UISoldier.UISoldierGob.transform:FindChild("SoliderTrain")
		
		UISoldier.SoldierTipsPanel=UISoldier.UISoldierGob.transform:FindChild("Tips")
		this:GetSoliderInfoControls()

	end
	this:SetInitData()
	this:ShowPanel("SoliderInfo")
end


function UISoldier:SetInitData()
	UISoldier.TrainLimitCount = LimitDataSys.GetTrainLimitCount()
	UISoldier.SoliderUpLimit = LimitDataSys.GetLimitSoliderUpLvl()
	local data = BattleFlagSys.BattleProp()
	if data~=nil then
		UISoldier.BattleFlagsAttr = data
	end
	local list = SoliderPackageSys.GetNormalSoliders()
	UISoldier.GongDataList = {}
	UISoldier.QiangDataList = {}
	UISoldier.DunDataList = {}

	for i=1,#list,1 do
		local item = list[i]
 --1-弓，2-盾牌，3-枪，
		if item.RoleSeries ==2 then
			table.insert(UISoldier.DunDataList , #UISoldier.DunDataList +1 , item)
		end
		if item.RoleSeries == 1 then
			table.insert(UISoldier.GongDataList , #UISoldier.GongDataList +1 , item)
		end
		if item.RoleSeries ==3 then
			table.insert(UISoldier.QiangDataList , #UISoldier.QiangDataList +1 , item)
		end
	end
end

function UISoldier:GetSoliderInfoControls() --得到士兵信息面板的控件
	local infoPanel=UISoldier.SoliderInfoPanel.transform:FindChild("SoldierInfoPanel/SoldierPanel/SoldierInfo")
	UISoldier.SoliderInfoControls.Name=infoPanel.transform:FindChild("SoliderName/Word"):GetComponent("UILabel")
	
	UISoldier.SoliderInfoControls.Model=infoPanel.transform:FindChild("SoliderPic")
	UISoldier.SoliderInfoControls.SoliderExp=infoPanel.transform:FindChild("SoliderExp"):GetComponent("UISlider")
	UISoldier.SoliderInfoControls.ExpNum=infoPanel.transform:FindChild("SoliderExp/ExpNum"):GetComponent("UILabel")
	
	local solderInfo = infoPanel.transform:FindChild("Soliderinfo")
	UISoldier.SoliderInfoControls.SoliderAtk = solderInfo.transform:FindChild("Up/Label"):GetComponent("UILabel")
	UISoldier.SoliderInfoControls.SoliderHp = solderInfo.transform:FindChild("Hp/Label"):GetComponent("UILabel")
	UISoldier.SoliderInfoControls.SoliderAtkSpeed =solderInfo.transform:FindChild("AtkSpeed/Label"):GetComponent("UILabel")
	UISoldier.SoliderInfoControls.SoliderType = solderInfo.transform:FindChild("Type/Label"):GetComponent("UILabel")
	UISoldier.SoliderInfoControls.SoliderDistance = solderInfo.transform:FindChild("AtkDistance/Label"):GetComponent("UILabel")
	local soliderList=UISoldier.SoliderInfoPanel.transform:FindChild("SoldierS")
	UISoldier.SoliderInfoControls.GongGrid=soliderList.transform:FindChild("Gong/HeroPanel/GongGrid"):GetComponent("UIGrid")
	UISoldier.SoliderInfoControls.QiangGrid=soliderList.transform:FindChild("Qiang/HeroPanel/QiangGrid"):GetComponent("UIGrid")
	UISoldier.SoliderInfoControls.DunGrid=soliderList.transform:FindChild("Dun/HeroPanel/DunGrid"):GetComponent("UIGrid")

end

function UISoldier:GetSoliderUpGradeControls()	--得到士兵升阶的控件
	local Left = UISoldier.SoliderUpGradePanel.transform:FindChild("SoldierLeft/SoldierPanel/Info")
	UISoldier.SoliderUpGradeControls.leftName=Left.transform:FindChild("SoliderName/Word"):GetComponent("UILabel")
	UISoldier.SoliderUpGradeControls.leftModel=Left.transform:FindChild("SoliderPic")
	UISoldier.SoliderUpGradeControls.leftEff = UISoldier.SoliderUpGradePanel.transform:FindChild("FX_shib_jinjie01")--
--	UISoldier.SoliderUpGradeControls.rightEff = UISoldier.SoliderUpGradePanel.transform:FindChild("FX_shib_jinjie01 (1)")
--	UISoldier.SoliderUpGradeControls.LeftAtkType = Left.transform:FindChild("SoliderPropdes/Type/Label"):GetComponent("UILabel")
	UISoldier.SoliderUpGradeControls.LeftAtk = Left.transform:FindChild("SoliderPropdes/Up/Label"):GetComponent("UILabel")
	UISoldier.SoliderUpGradeControls.LeftHp = Left.transform:FindChild("SoliderPropdes/Hp/Label"):GetComponent("UILabel")
	UISoldier.SoliderUpGradeControls.LeftAtkSpeed = Left.transform:FindChild("SoliderPropdes/AtkSpeed/Label"):GetComponent("UILabel")
	UISoldier.SoliderUpGradeControls.LeftAtkDistance = Left.transform:FindChild("SoliderPropdes/AtkDistance/Label"):GetComponent("UILabel")
	
	local right=UISoldier.SoliderUpGradePanel.transform:FindChild("SoldierRight/SoldierPanel/Info")
	UISoldier.SoliderUpGradeControls.rightNoOpen = UISoldier.SoliderUpGradePanel.transform:FindChild("SoldierRight/SoldierPanel/noOpen")
	UISoldier.SoliderUpGradeControls.rightShow = UISoldier.SoliderUpGradePanel.transform:FindChild("SoldierRight/SoldierPanel")

	UISoldier.SoliderUpGradeControls.rightName = right.transform:FindChild("SoliderName/Word"):GetComponent("UILabel")
	UISoldier.SoliderUpGradeControls.rightModel = right.transform:FindChild("SoliderPic")
--	UISoldier.SoliderUpGradeControls.RightAtkType = right.transform:FindChild("SoliderPropdes/Type/Label"):GetComponent("UILabel")
	UISoldier.SoliderUpGradeControls.RightAtk = right.transform:FindChild("SoliderPropdes/Up/Label"):GetComponent("UILabel")
	UISoldier.SoliderUpGradeControls.RightHp = right.transform:FindChild("SoliderPropdes/Hp/Label"):GetComponent("UILabel")
	UISoldier.SoliderUpGradeControls.RightAtkSpeed = right.transform:FindChild("SoliderPropdes/AtkSpeed/Label"):GetComponent("UILabel")
	UISoldier.SoliderUpGradeControls.RightAtkDistance = right.transform:FindChild("SoliderPropdes/AtkDistance/Label"):GetComponent("UILabel")
	
	local needMat=UISoldier.SoliderUpGradePanel.transform:FindChild("NeedMaterial/MaterialPanel/NeedMaterial/Item")
	UISoldier.SoliderUpGradeControls.ownMatNum = needMat.transform:FindChild("Num"):GetComponent("UILabel")
	UISoldier.SoliderUpGradeControls.needMatQuilaty = needMat.transform:FindChild("FG"):GetComponent("UISprite")
	UISoldier.SoliderUpGradeControls.needMatFg = needMat.transform:FindChild("bgFG"):GetComponent("UISprite")
	UISoldier.SoliderUpGradeControls.needMatImg = needMat.transform:FindChild("IMG"):GetComponent("UISprite")

	UISoldier.SoliderUpGradeControls.ShowOwnCount = UISoldier.SoliderUpGradePanel.transform:FindChild("NeedMaterial/MaterialPanel/num/Word"):GetComponent("UILabel")
	UISoldier.SoliderUpGradeControls.SuccessGradePanel = UISoldier.SoliderUpGradePanel.transform:FindChild("SuccessUpGradePanel") 
end

function UISoldier:GetSoliderTrainControls()	--得到士兵训练的控件
	UISoldier.SoliderTrainControls.TrainCount = UISoldier.SoliderTrainPanel.transform:FindChild("TrainCount"):GetComponent("UILabel")
	local infoPanel=UISoldier.SoliderTrainPanel.transform:FindChild("HeroInfoPanel/HeroPanel/SoldierInfo")
	UISoldier.SoliderTrainControls.Model = infoPanel.transform:FindChild("Solidermodel")
	UISoldier.SoliderTrainControls.Name = infoPanel.transform:FindChild("SoliderName/Word"):GetComponent("UILabel")
	UISoldier.SoliderTrainControls.sliderExp = infoPanel.transform:FindChild("SoliderExp"):GetComponent("UISlider")
	UISoldier.SoliderTrainControls.sliderExpNum = infoPanel.transform:FindChild("SoliderExp/ExpNum"):GetComponent("UILabel")
	
	UISoldier.SoliderTrainControls.Hp = infoPanel.transform:FindChild("Hp/Label"):GetComponent("UILabel")
	UISoldier.SoliderTrainControls.AtkSpeed = infoPanel.transform:FindChild("AtkSpeed/Label"):GetComponent("UILabel")
	UISoldier.SoliderTrainControls.Atk = infoPanel.transform:FindChild("Atk/Label"):GetComponent("UILabel")
	
	UISoldier.SoliderTrainControls.Grid = UISoldier.SoliderTrainPanel.transform:FindChild("Heroes/HeroesPanel/TrainGrid"):GetComponent("UIGrid")
	
	local trainInfo = UISoldier.SoliderTrainPanel.transform:FindChild("TrainPanel")
	UISoldier.SoliderTrainControls.NormalNoTrain = trainInfo.transform:FindChild("NormalTrainBtn/TrainInfo")
	UISoldier.SoliderTrainControls.NormalTrainIng = trainInfo.transform:FindChild("NormalTrainBtn/TrainIng")
	UISoldier.SoliderTrainControls.NormalTimeLabel = UISoldier.SoliderTrainControls.NormalTrainIng:FindChild("time"):GetComponent("UILabel")
	UISoldier.SoliderTrainControls.NormalCostCount = UISoldier.SoliderTrainControls.NormalNoTrain.transform:FindChild("cost"):GetComponent("UILabel")
	UISoldier.SoliderTrainControls.NormalTrainBg = trainInfo.transform:FindChild("NormalTrainBtn/BG"):GetComponent("UISprite")
	UISoldier.SoliderTrainControls.BetterTrainBg = trainInfo.transform:FindChild("BetterTrainBtn/BG"):GetComponent("UISprite")
	UISoldier.SoliderTrainControls.BestTrainBg = trainInfo.transform:FindChild("BestTrainBtn/BG"):GetComponent("UISprite")

	UISoldier.SoliderTrainControls.BetterNoTrain = trainInfo.transform:FindChild("BetterTrainBtn/TrainInfo")
	UISoldier.SoliderTrainControls.BetterTrainIng = trainInfo.transform:FindChild("BetterTrainBtn/TrainIng")
	UISoldier.SoliderTrainControls.BetterTimeLabel = UISoldier.SoliderTrainControls.BetterTrainIng:FindChild("time"):GetComponent("UILabel")
	UISoldier.SoliderTrainControls.BetterCostCount = UISoldier.SoliderTrainControls.BetterNoTrain.transform:FindChild("cost"):GetComponent("UILabel")
	
	UISoldier.SoliderTrainControls.BestNoTrain = trainInfo.transform:FindChild("BestTrainBtn/TrainInfo")
	UISoldier.SoliderTrainControls.BestTrainIng = trainInfo.transform:FindChild("BestTrainBtn/TrainIng")
	UISoldier.SoliderTrainControls.IsOpenBestTrain = UISoldier.SoliderTrainControls.BestNoTrain.transform:FindChild("open")
	UISoldier.SoliderTrainControls.NoOpenBestTrain = UISoldier.SoliderTrainControls.BestNoTrain.transform:FindChild("noOpen")
	UISoldier.SoliderTrainControls.BestTimeLabel = UISoldier.SoliderTrainControls.BestTrainIng:FindChild("time"):GetComponent("UILabel")
	UISoldier.SoliderTrainControls.BestTrainItemImg = UISoldier.SoliderTrainControls.IsOpenBestTrain.transform:FindChild("cost/Sprite"):GetComponent("UISprite")
	UISoldier.SoliderTrainControls.BestTrainCount = UISoldier.SoliderTrainControls.IsOpenBestTrain.transform:FindChild("cost"):GetComponent("UILabel")

	UISoldier.SoliderTrainControls.ColdBtn = trainInfo.transform:FindChild("ColdBtn")
	UISoldier.SoliderTrainControls.ColdTime = UISoldier.SoliderTrainControls.ColdBtn.transform:FindChild("ColdTime/Word"):GetComponent("UILabel")
	UISoldier.SoliderTrainControls.SpeedItem = UISoldier.SoliderTrainControls.ColdBtn.transform:FindChild("LeftSpeedMaterial/Word"):GetComponent("UILabel")
	UISoldier.SoliderTrainControls.AddExpItemLabel =  trainInfo.transform:FindChild("surplusMat/Word"):GetComponent("UILabel")

	UISoldier.SoliderTrainControls.AutoPanel = UISoldier.SoliderTrainPanel.transform:FindChild("AutoPanel")

	UISoldier.SoliderTrainControls.NormalTimeImg = UISoldier.SoliderTrainControls.NormalNoTrain.transform:FindChild("time/Sprite"):GetComponent("UISprite")
	UISoldier.SoliderTrainControls.BetterTimeImg = UISoldier.SoliderTrainControls.BetterNoTrain.transform:FindChild("time/Sprite"):GetComponent("UISprite")
	UISoldier.SoliderTrainControls.BestTimeImg = UISoldier.SoliderTrainControls.BestNoTrain.transform:FindChild("open/time/Sprite"):GetComponent("UISprite")
	UISoldier.SoliderTrainControls.NormalCostImg = UISoldier.SoliderTrainControls.NormalNoTrain.transform:FindChild("cost/Sprite"):GetComponent("UISprite")
	UISoldier.SoliderTrainControls.BetterCostImg = UISoldier.SoliderTrainControls.BetterNoTrain.transform:FindChild("cost/Sprite"):GetComponent("UISprite")
	UISoldier.SoliderTrainControls.BestCostImg = UISoldier.SoliderTrainControls.BestNoTrain.transform:FindChild("open/cost/Sprite"):GetComponent("UISprite")
	
end

function UISoldier:ShowPanel(panelName)--显示相应的面板
	local name=tostring(panelName)
	UISoldier.SoliderInfoPanel.gameObject:SetActive("SoliderInfo"==name)
	UISoldier.SoliderUpGradePanel.gameObject:SetActive("SoliderUpGrade"==name)
	UISoldier.SoliderTrainPanel.gameObject:SetActive("SoliderTrain"==name)

	if panelName=="SoliderInfo" then
		this:ShowSoliderInfoPanel()
	end

	if panelName=="SoliderUpGrade" then
		this:ShowHeroUpGradePanel()
	end

	if panelName=="SoliderTrain" then
		this:ShowHeroTrainPanel()
	end
end


function UISoldier:ShowSoliderInfoPanel()
	
	this:ShowSoliderList()
end

function UISoldier:ShowSoliderList()--显示不同类型的士兵list

	this:ShowTypeList(UISoldier.GongDataList)
	--弓 枪 盾
end

function UISoldier:ShowTypeList(DataList)
	
	for i=1,#DataList,1 do
		local itemData = DataList[i]
		local data = 
		{
			Index =i,
			Data = itemData,
			Len = #DataList,
		}
		if itemData.RoleSeries ==2 then
			if UISoldier.DunSoliderGodList[i]~=nil then
				this:CreateSoldierListCallBack(UISoldier.DunSoliderGodList[i] , data)
			else
				--1-盾
				MainGameUI.CreateLittleItem(tostring(i) ,"SoldierItem" , UISoldier.SoliderInfoControls.DunGrid, data , this.CreateSoldierListCallBack , "UISoldier") 
			end
		end
		if itemData.RoleSeries ==1 then
			if UISoldier.GongSoliderGodList[i] ~=nil then
				this:CreateSoldierListCallBack(UISoldier.GongSoliderGodList[i] , data)
			else
				--2-弓
				MainGameUI.CreateLittleItem(tostring(i) ,"SoldierItem" , UISoldier.SoliderInfoControls.GongGrid, data , this.CreateSoldierListCallBack , "UISoldier") 
			end
			
		end
		if itemData.RoleSeries ==3 then
			if UISoldier.QiangSoldierGodList[i]~=nil then
				this:CreateSoldierListCallBack(UISoldier.QiangSoldierGodList[i] , data)
			else
				--3-枪
				MainGameUI.CreateLittleItem(tostring(i) ,"SoldierItem" , UISoldier.SoliderInfoControls.QiangGrid, data , this.CreateSoldierListCallBack , "UISoldier") 
			end
			
		end
	end
	
	
end

function UISoldier:CreateSoldierListCallBack(_God , _Info)
	local index = _Info.Index
	
--	UISoldier.SliderGodList[index] = _God
	local data = _Info.Data
	if data == null then
		GameMain.CloseObj(_God)
		return
	end
	
	this:ShowItemInfo(_God , data)
--	UISoldier.SoliderInfoControls.SoliderExp.value = 
	if data.RoleSeries ==2 then
		--2-盾
		UISoldier.DunSoliderGodList[index] = _God
		_God.transform.parent = UISoldier.SoliderInfoControls.DunGrid.transform
		
		if index == _Info.Len then
			UISoldier.SoliderInfoControls.DunGrid.enabled = true
			UISoldier.SoliderInfoControls.DunGrid:Reposition()

			local model = UISoldier.SoliderInfoControls.Model.transform:FindChild("Hero")
			if model == nil and UISoldier.FirstCreateInfoModel == false then
				if #UISoldier.DunSoliderGodList>0 then
					this:ShowSoliderItemInfo(UISoldier.DunSoliderGodList[1] , UISoldier.DunDataList[1])
					UISoldier.ClickInfoType = 1
					UISoldier.FirstCreateInfoModel = true
				end
			end
		
		end
	end
	if data.RoleSeries ==1 then
		--1-弓
		UISoldier.GongSoliderGodList[index] = _God
		_God.transform.parent = UISoldier.SoliderInfoControls.GongGrid.transform

		if index == _Info.Len then
			UISoldier.SoliderInfoControls.GongGrid.enabled = true
			UISoldier.SoliderInfoControls.GongGrid:Reposition()
			
			local model = UISoldier.SoliderInfoControls.Model.transform:FindChild("Hero")
			if model == nil and UISoldier.FirstCreateInfoModel == false then
				if #UISoldier.GongSoliderGodList>0 then
					this:ShowSoliderItemInfo(UISoldier.GongSoliderGodList[1] , UISoldier.GongDataList[1])
					UISoldier.FirstCreateInfoModel = true
					UISoldier.ClickInfoType = 2
				end
			end
			this:ShowTypeList(UISoldier.QiangDataList)
		end
	end
	if data.RoleSeries ==3 then
		--3-枪
		UISoldier.QiangSoldierGodList[index] = _God
		_God.transform.parent = UISoldier.SoliderInfoControls.QiangGrid.transform

		if index == _Info.Len then
			UISoldier.SoliderInfoControls.QiangGrid.enabled = true
			UISoldier.SoliderInfoControls.QiangGrid:Reposition()
		
			local model = UISoldier.SoliderInfoControls.Model.transform:FindChild("Hero")
			if model == nil and UISoldier.FirstCreateInfoModel == false then
				if #UISoldier.QiangSoldierGodList>0 then
					this:ShowSoliderItemInfo(UISoldier.QiangSoldierGodList[1] , UISoldier.QiangDataList[1])
					UISoldier.ClickInfoType = 3
					UISoldier.FirstCreateInfoModel = true
				end
			end
			this:ShowTypeList(UISoldier.DunDataList)
		end
	end

end


function UISoldier:ShowItemInfo(_God , data)
	GameMain.OpenObj(_God)
--2-盾，1-弓，3-枪，
	local spriteName=nil
	if data.RoleSeries ==2 then
		spriteName="dun"
	end
	if data.RoleSeries ==1 then
		spriteName="gong"
	end
	if data.RoleSeries ==3 then
		spriteName="qiang"
	end

	local typeSprite=_God.transform:FindChild("typeIMg/zhan"):GetComponent("UISprite")
	typeSprite.spriteName = spriteName

	--显示相关信息
	local lv=_God.transform:FindChild("Lvl"):GetComponent("UILabel")
	local name=_God.transform:FindChild("name"):GetComponent("UILabel")
	local Train=_God.transform:FindChild("train")
	local img=_God.transform:FindChild("IMG"):GetComponent("UISprite")
	local Quality=_God.transform:FindChild("FG"):GetComponent("UISprite")
	local fg = _God.transform:FindChild("bgFG"):GetComponent("UISprite")--bgFG
	local isTrain = data:IsTrain()
	if isTrain==true then
		UISoldier.CurTrainCount = UISoldier.CurTrainCount +1
		GameMain.OpenObj(Train)
	else
		GameMain.CloseObj(Train)
	end
	
	Quality.spriteName = UIstring.ItemFg[data.quality]
	AtlasMsg.SetAtlas(img,data.AtlasName ,data.SpriteName)
	fg.spriteName = UIstring.ItemFg[data.quality]

	local lvl = data:GetLvl()
	lv.text="LV" .. tostring(lvl)
	local qlvl = ""
	if data.qualityLvl>0 then
		qlvl = "+" .. data.qualityLvl
	end
	name.text= UIstring.WordColor[data.quality] .. tostring(data.nickname) ..qlvl.. "[-]"
end

function UISoldier:ClearSoliderList(_list) --清一下士兵列表
	for key,value in pairs(_list) do
		value.gameObject:SetActive(false)
	end
end
--region *.士兵进阶
function UISoldier:ShowHeroUpGradePanel() --显示士兵升阶面板
--	GameMain.CloseObj(UISoldier.SoliderUpGradeControls.rightEff)
	GameMain.CloseObj(UISoldier.SoliderUpGradeControls.leftEff)
	if UISoldier.SoliderUpGradeControls.leftName==nil then
		this:GetSoliderUpGradeControls()
	end
	if UISoldier.clickInfoTemp~=nil then
		local index = tonumber(UISoldier.clickInfoTemp.name)
		if UISoldier.ClickInfoType ==1 then
			this:ShowHeroUpGradeInfo(UISoldier.DunDataList[index])
		--1-盾，2-弓，3-枪
		end
		if UISoldier.ClickInfoType ==2 then
			this:ShowHeroUpGradeInfo(UISoldier.GongDataList[index])
		--1-盾，2-弓，3-枪
		end
		if UISoldier.ClickInfoType ==3 then
			this:ShowHeroUpGradeInfo(UISoldier.QiangDataList[index])
		--1-盾，2-弓，3-枪
		end
	end

end

function UISoldier:ShowSoliderUpEff()
	GameMain.CloseObj(UISoldier.SoliderUpGradeControls.leftEff)
--	GameMain.CloseObj(UISoldier.SoliderUpGradeControls.rightEff)
	GameMain.OpenObj(UISoldier.SoliderUpGradeControls.leftEff)
--	GameMain.OpenObj(UISoldier.SoliderUpGradeControls.rightEff)
end

function UISoldier:ShowHeroUpGradeWebAfterInfo(_NextData)
	this:ShowSoliderUpEff()
	GameMain.OpenObj(UISoldier.SoliderUpGradeControls.SuccessGradePanel)
	if UISoldier.SuccessGradeControls.beforeAtk==nil then
		this:GetSucessUpGradeControls()
	end
	local index = tonumber(UISoldier.clickInfoTemp.name)
	local data = nil
	--2-盾，1-弓，3-枪
	if _NextData.RoleSeries ==2 then
		data =  UISoldier.DunDataList[index]
	end
	if _NextData.RoleSeries ==1 then
		data = UISoldier.GongDataList[index]
	end
	if _NextData.RoleSeries ==3 then
		data = UISoldier.QiangDataList[index]
	end
	local beforeAtk = data:GetAtk()
	UISoldier.SuccessGradeControls.beforeAtk.text = "攻击:" .. beforeAtk
	local beforeHp = data:GetLife()
	UISoldier.SuccessGradeControls.beforeHp.text = "血量:" .. beforeHp
	local beforeAtkSpeed = data:GetAtkSpeed()
	UISoldier.SuccessGradeControls.beforeAtkSpeed.text = "攻击速度:"	 .. beforeAtkSpeed
	UISoldier.SuccessGradeControls.beforeAtkDistance.text = "攻击距离" .. data.AttackRange
	
	local nextAtk =  _NextData:GetAtk()
	local nextHp = _NextData:GetLife()
	local nextAtkSpeed = _NextData:GetAtkSpeed()
	local atkAddStr = this:GetSuccessGradeAttr(beforeAtk , nextAtk)
	local hpAddStr = this:GetSuccessGradeAttr(beforeHp , nextHp)
	local atkSpeedAddStr = this:GetSuccessGradeAttr(beforeAtkSpeed , nextAtkSpeed)
	local atkDistanceStr = this:GetSuccessGradeAttr(data.AttackRange , _NextData.AttackRange)
	
	UISoldier.SuccessGradeControls.nextAtk.text = "攻击:" .. nextAtk .. atkAddStr
	UISoldier.SuccessGradeControls.nextHp.text = "血量:" .. nextHp .. hpAddStr
	UISoldier.SuccessGradeControls.nextAtkSpeed.text = "攻击速度:" .. nextAtkSpeed .. atkSpeedAddStr
	UISoldier.SuccessGradeControls.nextAtkDistance.text = "攻击距离:" .. _NextData.AttackRange .. atkDistanceStr
	
	AtlasMsg.SetAtlas(UISoldier.SuccessGradeControls.beforeImg , data.AtlasName , data.SpriteName)
	UISoldier.SuccessGradeControls.beforeQuality.spriteName = UIstring.ItemFg[data.quality]
	AtlasMsg.SetAtlas(UISoldier.SuccessGradeControls.nextImg , _NextData.AtlasName , _NextData.SpriteName)
	UISoldier.SuccessGradeControls.nextQuality.spriteName = UIstring.ItemFg[_NextData.quality]
	
	this:ShowHeroUpGradeInfo(_NextData)
end

function UISoldier:GetSuccessGradeAttr(_Before , _Next)
	local str = ""
	local del = _Next - _Before
	if del>0 then
		str = UIstring.Green .. "(+" .. del .. ")" .. "[-]"
	end
	return str
end

function UISoldier:GetSucessUpGradeControls()
	local beforeInfo = UISoldier.SoliderUpGradeControls.SuccessGradePanel.transform:FindChild("Left")
	local nextInfo = UISoldier.SoliderUpGradeControls.SuccessGradePanel.transform:FindChild("Right")
	UISoldier.SuccessGradeControls.beforeImg = beforeInfo.transform:FindChild("HeroPic/IMG"):GetComponent("UISprite")
	UISoldier.SuccessGradeControls.nextImg = nextInfo.transform:FindChild("HeroPic/IMG"):GetComponent("UISprite")
	UISoldier.SuccessGradeControls.beforeQuality = beforeInfo.transform:FindChild("Type"):GetComponent("UISprite")
	UISoldier.SuccessGradeControls.nextQuality = nextInfo.transform:FindChild("Type"):GetComponent("UISprite")
	
	local beforeAttr = beforeInfo.transform:FindChild("Attr")
	local nextAttr = nextInfo.transform:FindChild("Attr")
	UISoldier.SuccessGradeControls.beforeAtk = beforeAttr.transform:FindChild("atk"):GetComponent("UILabel")
	UISoldier.SuccessGradeControls.beforeHp = beforeAttr.transform:FindChild("hp"):GetComponent("UILabel")
	UISoldier.SuccessGradeControls.beforeAtkSpeed = beforeAttr.transform:FindChild("atkSpeed"):GetComponent("UILabel")
	UISoldier.SuccessGradeControls.beforeAtkDistance = beforeAttr.transform:FindChild("atkDistance"):GetComponent("UILabel")
	
	UISoldier.SuccessGradeControls.nextAtk = nextAttr.transform:FindChild("atk"):GetComponent("UILabel")
	UISoldier.SuccessGradeControls.nextHp = nextAttr.transform:FindChild("hp"):GetComponent("UILabel")
	UISoldier.SuccessGradeControls.nextAtkSpeed = nextAttr.transform:FindChild("atkSpeed"):GetComponent("UILabel")
	UISoldier.SuccessGradeControls.nextAtkDistance = nextAttr.transform:FindChild("atkDistance"):GetComponent("UILabel")
end

function UISoldier:CloseSuccessGradePanel()
	GameMain.CloseObj(UISoldier.SoliderUpGradeControls.SuccessGradePanel)
end

function UISoldier:ShowHeroUpGradeInfo(itemData)
	local index = tonumber(UISoldier.clickInfoTemp.name)
	--2-盾，1-弓，3-枪
	if itemData.RoleSeries ==2 then
		UISoldier.DunDataList[index] = itemData
	end
	if itemData.RoleSeries ==1 then
		UISoldier.GongDataList[index] = itemData
	end
	if itemData.RoleSeries ==3 then
		UISoldier.QiangDataList[index] = itemData
	end
		local nameStr = ""
		if itemData.qualityLvl ~= 0 then
			nameStr = "+".. tostring(itemData.qualityLvl)
		end
		UISoldier.SoliderUpGradeControls.leftName.text= UIstring.WordColor[itemData.quality].. tostring(itemData.nickname) ..nameStr.."[-]"
--		UISoldier.SoliderUpGradeControls.LeftAtkType.text =tostring(itemData.AttackType)
		UISoldier.SoliderUpGradeControls.LeftAtk.text = tostring(itemData:GetAtk())
		UISoldier.SoliderUpGradeControls.LeftAtkDistance.text = tostring(itemData.AttackRange)
		UISoldier.SoliderUpGradeControls.LeftAtkSpeed.text = tostring(itemData:GetAtkSpeed())
		UISoldier.SoliderUpGradeControls.LeftHp.text = tostring(itemData:GetLife())

		local item = ItemPackageSys.GetItemById(UIstring.SoliderUpGradeItemId)
		if item==nil then
			UISoldier.SoliderUpGradeControls.ShowOwnCount.text = UIstring.SoliderHasOwnZero
		else
			UISoldier.SoliderUpGradeControls.ShowOwnCount.text = UIstring.SoldierOwn .. tostring(item.Count) .. UIstring.SoliderItem
		end
		local curGradeData = SoliderQualityUpConfig.GetDBByQuilityAndLv(itemData.quality , itemData.qualityLvl)
		UISoldier.SoliderUpGradeControls.ownMatNum.text =tostring(curGradeData.UpNeed)
		UISoldier.SoliderUpGradeControls.leftModel.transform.localEulerAngles = Vector3(0,150,0)
		UISoldier.SoliderUpGradeControls.rightModel.transform.localEulerAngles = Vector3(0,150,0)
		local itemDataConfig = ItemDataConfig.GetItemDBConfig(UIstring.SoliderUpGradeItemId)
		AtlasMsg.SetAtlas(UISoldier.SoliderUpGradeControls.needMatImg , itemDataConfig.AtlasName , itemDataConfig.SpriteName)
		UISoldier.SoliderUpGradeControls.needMatQuilaty.spriteName = UIstring.ItemFg[itemDataConfig.Quality]
		UISoldier.SoliderUpGradeControls.needMatFg.spriteName = UIstring.ItemFg[itemDataConfig.Quality]
		if UISoldier.TempReGradeModel ~=nil then
				if itemData.ModelName~= UISoldier.TempReGradeModel.name then
				  GameObject.Destroy(UISoldier.TempReGradeModel)
				  UISoldier.TempReGradeModel = nil
				end
		end
		Create3DModel.CreateThModel(itemData.ModelName , "walk" , 5 , UISoldier.SoliderUpGradeControls.leftModel,this.CreateReGradeModelCallBack ,true , nil)

	if itemData.AdvanceId == 0 then
			DataUIInstance.PopTip(UIstring.SoldierHasUpHeigthGrade)
			GameMain.CloseObj(UISoldier.SoliderUpGradeControls.rightShow)
			GameMain.OpenObj(UISoldier.SoliderUpGradeControls.rightNoOpen)
			return
		end
		local nextSoliderGrade = SoliderPackageSys.NextGradeData(itemData)

		if nextSoliderGrade == nil then
			GameMain.CloseObj(UISoldier.SoliderUpGradeControls.rightShow)
			GameMain.OpenObj(UISoldier.SoliderUpGradeControls.rightNoOpen)
			return
		end
	GameMain.OpenObj(UISoldier.SoliderUpGradeControls.rightShow)
	GameMain.CloseObj(UISoldier.SoliderUpGradeControls.rightNoOpen)
		if nextSoliderGrade.QualityLvl ==0 then
			local nextData =  RoleDataSys.GetRoleById(itemData.AdvanceId)

			UISoldier.SoliderUpGradeControls.rightName.text= UIstring.WordColor[nextData.Quality] .. tostring(nextData.Name) .. "[-]"
--			UISoldier.SoliderUpGradeControls.RightAtkType.text = tostring(nextData.AttackType)

			if UISoldier.TempUpGradeModel ~=nil then
				if nextData.FbxName~= UISoldier.TempUpGradeModel.name then
				  GameObject.Destroy(UISoldier.TempUpGradeModel)
				  UISoldier.TempUpGradeModel = nil
				end
			end
			
			Create3DModel.CreateThModel(nextData.FbxName , "walk" , 5 , UISoldier.SoliderUpGradeControls.rightModel,UISoldier.CreateUpGradeModelCallBack ,true , nil)
			
			local atk = CalculateRoleProp.CalculationAttr(nextData.AttackList, nextData.Quality ,itemData.lvl)
			local hp = CalculateRoleProp.CalculationAttr(nextData.LifeList, nextData.Quality ,itemData.lvl)
			local atkSpeed = CalculateRoleProp.CalculationAttr(nextData.AttackSpeedList, nextData.Quality ,itemData.lvl)
		
			UISoldier.SoliderUpGradeControls.RightAtk.text = tostring(atk)
			UISoldier.SoliderUpGradeControls.RightAtkSpeed.text = tostring(atkSpeed)
			UISoldier.SoliderUpGradeControls.RightAtkDistance.text = tostring(nextData.AttackRange)
			UISoldier.SoliderUpGradeControls.RightHp.text = tostring(hp)
		else
			if UISoldier.TempUpGradeModel ~=nil then
				if itemData.ModelName~= UISoldier.TempUpGradeModel.name then
				  GameObject.Destroy(UISoldier.TempUpGradeModel)
				  UISoldier.TempUpGradeModel = nil
				end
			end
			
			Create3DModel.CreateThModel(itemData.ModelName , "walk" , 5 , UISoldier.SoliderUpGradeControls.rightModel,UISoldier.CreateUpGradeModelCallBack ,true , nil)
			
			UISoldier.SoliderUpGradeControls.rightName.text= UIstring.WordColor[itemData.quality] .. tostring(itemData.nickname) .."+".. tostring(nextSoliderGrade.QualityLvl).. "[-]"
--			UISoldier.SoliderUpGradeControls.RightAtkType.text = tostring(itemData.AttackType)
--			AtlasMsg.SetAtlas(UISoldier.SoliderUpGradeControls.rightImg ,nextData.AtlasName , nextData.SpriteName)
	
			UISoldier.SoliderUpGradeControls.RightAtk.text = tostring(itemData:GetNextAtk())
			UISoldier.SoliderUpGradeControls.RightAtkSpeed.text = tostring(itemData:GetNextAtkSpeed())
			UISoldier.SoliderUpGradeControls.RightAtkDistance.text = tostring(itemData.AttackRange)
			UISoldier.SoliderUpGradeControls.RightHp.text = tostring(itemData:GetNextLife())
		end
	
end

function UISoldier.CreateUpGradeModelCallBack(NeedModel , _Data)
	UISoldier.TempUpGradeModel = NeedModel
end

function UISoldier.CreateReGradeModelCallBack(NeedModel , _Data)
	UISoldier.TempReGradeModel = NeedModel
end

function UISoldier:SoliderUpGrade()
	local role = nil
	local index = tonumber(UISoldier.clickInfoTemp.name)
	if UISoldier.ClickInfoType == 1 then
		role = UISoldier.DunDataList[index]
		--1-盾，2-弓，3-枪
	end
	if UISoldier.ClickInfoType == 2 then
		role = UISoldier.GongDataList[index]
	end
	if UISoldier.ClickInfoType == 3 then
		role = UISoldier.QiangDataList[index]
	end

	local curGradeData = SoliderQualityUpConfig.GetDBByQuilityAndLv(role.quality , role.qualityLvl)
	if curGradeData.UpToId == 0 then
		DataUIInstance.PopTip("已经升到最高阶")
		return
	end
	if role.AdvanceId == 0 then
		DataUIInstance.PopTip("已经升到最高阶")
		return
	end
	local nextData = SoliderQualityUpConfig.GetSoliderQualityInfoById(curGradeData.UpToId)
	if nextData.Quality > UISoldier.SoliderUpLimit then
		DataUIInstance.PopTip("学习科技可以提高进阶等级")
		return
	end
	local item = ItemPackageSys.GetItemById(UIstring.SoliderUpGradeItemId)
	if item == nil then
		local DBItemData = ShopSys.GetItemById(UIstring.SoliderUpGradeItemId , 1)
		local data = 
		{
			Buy_SellType = 1,
			Item = DBItemData,
			BuyCount = curGradeData.UpNeed,
		}
		
		DataUIInstance.PopTipPanel("Buy_SellItems" , UISoldier.BuyNormalCallBack , data) 
		return
	end
	if item.Count< tonumber(curGradeData.UpNeed) then
--		DataUIInstance.PopTip(UIstring.SoliderHasNoProp)
		local DBItemData = ShopSys.GetItemById(UIstring.SoliderUpGradeItemId , 1)
		local data = 
		{
			Buy_SellType = 1,
			Item = DBItemData,
			BuyCount = curGradeData.UpNeed - item.Count,
		}
		
		DataUIInstance.PopTipPanel("Buy_SellItems" , UISoldier.BuyNormalCallBack , data) 
		return 
	end
	
	local elus = item.Count- tonumber(curGradeData.UpNeed)
	UISoldier.SoliderUpGradeControls.ShowOwnCount.text = UIstring.SoldierOwn .. tostring(elus) .. UIstring.SoliderItem
	UISoldier.SoliderUpGradeControls.ownMatNum.text =tostring(elus)
	role:UpGrade()
end

function UISoldier.BuyNormalCallBack(_Data)
	local _Item = _Data.Item
    ShopSys.BuyNormalItem(_Item.ShopId , _Data.Num)
end

function UISoldier:ShowUpAfterInfo()
	GameMain.OpenObj(UISoldier.SoliderInfoPanel.gameObject)
	GameMain.CloseObj(UISoldier.SoliderUpGradePanel.gameObject)
	GameMain.CloseObj(UISoldier.SoliderTrainPanel.gameObject)

	local god = UISoldier.clickInfoTemp-- 15
	local parent = god.transform.parent
	if parent.name == "GongGrid" then
		local data = UISoldier.GongDataList[tonumber(god.name)]
		this:ShowItemInfo(god , data)
		this:ShowSoliderItemInfo(god , data)
	end
	if parent.name == "QiangGrid" then
		local data = UISoldier.QiangDataList[tonumber(god.name)]
		this:ShowItemInfo(god , data)
		this:ShowSoliderItemInfo(god , data)
	end
	if parent.name == "DunGrid" then
		local data = UISoldier.DunDataList[tonumber(god.name)]
		this:ShowItemInfo(god , data)
		this:ShowSoliderItemInfo(god , data)
	end
	
end
--endregion


function UISoldier:ShowHeroTrainPanel()	--显示士兵训练面板
	if UISoldier.SoliderTrainControls.Name==nil then
		this:GetSoliderTrainControls()
	end
	local data = this:GetCurTrainData()
	local list = SoliderPackageSys.GetSoliders()
	for i=1,#list,1 do
		UISoldier.SoldierDataList[i] = list[i]
		if list[i].Dbid == data.Dbid then
			UISoldier.ClickTrainIndex = i
		end
	end
	UISoldier.CurTrainCount = 0
	this:ShowTrainSoldierList()
	this:ShowTrainColdInfo()
	this:ShowTrainOpenInfo()
	this:ShowTrainCountInfo()
end

function UISoldier:ShowTrainCountInfo()
	UISoldier.SoliderTrainControls.TrainCount.text = "训练队列:".. UISoldier.CurTrainCount .. "\\" .. UISoldier.TrainLimitCount
end

function UISoldier:ShowNormalBtnInfo()
	AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.NormalTrainBg , "UI_ZQ_Button" , "daanniu" )
	AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BetterTrainBg , "UI_ZQ_Button" , "daanniu" )
	AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BestTrainBg , "UI_ZQ_Button" , "daanniu" )
	AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.NormalTimeImg , "UI_ZQ_Index2" , "shijian")
	AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BetterTimeImg , "UI_ZQ_Index2" , "shijian")
	AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BestTimeImg , "UI_ZQ_Index2" , "shijian")
	AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.NormalCostImg , "MainCityItems" , "qianbitubiao")
	AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BetterCostImg , "MainCityItems" , "qianbitubiao")
	AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BestCostImg , "MainCityItems" , "qianbitubiao")
end

function UISoldier:ShowGrayBtnInfo(_Type)--1普通 2 高级 3 VIP
	if _Type == 1 then
		AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.NormalTrainBg , "UI_ZQ_Button" , "daanniu" )
		AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.NormalCostImg , "MainCityItems" , "qianbitubiao")
		AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.NormalTimeImg , "UI_ZQ_Index2" , "shijian")
	else
		AtlasMsg.SetGrayAtlas(UISoldier.SoliderTrainControls.NormalTrainBg,"daanniu",1)
		AtlasMsg.SetGrayAtlas(UISoldier.SoliderTrainControls.NormalCostImg , "qianbitubiao" ,1)
		AtlasMsg.SetGrayAtlas(UISoldier.SoliderTrainControls.NormalTimeImg ,  "shijian" ,1)
	end
	if _Type == 2 then
		AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BetterTrainBg , "UI_ZQ_Button" , "daanniu" )
		AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BetterCostImg , "MainCityItems" , "qianbitubiao")
		AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BetterTimeImg , "UI_ZQ_Index2" , "shijian")
	else
		AtlasMsg.SetGrayAtlas(UISoldier.SoliderTrainControls.BetterTrainBg,"daanniu",1)
		AtlasMsg.SetGrayAtlas(UISoldier.SoliderTrainControls.BetterCostImg , "qianbitubiao" ,1)
		AtlasMsg.SetGrayAtlas(UISoldier.SoliderTrainControls.BetterTimeImg ,  "shijian" ,1)
	end
	if _Type == 3 then
		AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BestTrainBg , "UI_ZQ_Button" , "daanniu" )
		AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BestCostImg , "MainCityItems" , "qianbitubiao")
		AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BestTimeImg , "UI_ZQ_Index2" , "shijian")
	else
		AtlasMsg.SetGrayAtlas(UISoldier.SoliderTrainControls.BestTrainBg,"daanniu",1)
		AtlasMsg.SetGrayAtlas(UISoldier.SoliderTrainControls.BestCostImg , "qianbitubiao" ,1)
		AtlasMsg.SetGrayAtlas(UISoldier.SoliderTrainControls.BestTimeImg ,  "shijian" ,1)
	end
end

function UISoldier:GetCurTrainData()
	local data = nil
	local index = tonumber(UISoldier.clickInfoTemp.name)
	if UISoldier.ClickInfoType ==1 then
		data = UISoldier.DunDataList[index]--1-盾，2-弓，3-枪
	end
	if UISoldier.ClickInfoType ==2 then
		data =UISoldier.GongDataList[index]
	end
	if UISoldier.ClickInfoType ==3 then
		data =UISoldier.QiangDataList[index]
	end
	return data
end

function UISoldier:ShowTrainOpenInfo()
	if VipSys.VipLevel>=1 then
		GameMain.OpenObj(UISoldier.SoliderTrainControls.IsOpenBestTrain)
		GameMain.CloseObj(UISoldier.SoliderTrainControls.NoOpenBestTrain)
		local item = ItemDataConfig.GetItemDBConfig(UIstring.VipTrainId)
		AtlasMsg.SetAtlas(UISoldier.SoliderTrainControls.BestTrainItemImg , item.AtlasName , item.SpriteName)
	else
		GameMain.OpenObj(UISoldier.SoliderTrainControls.NoOpenBestTrain)
		GameMain.CloseObj(UISoldier.SoliderTrainControls.IsOpenBestTrain)
	end
end

function UISoldier:ShowTrainItemInfo(_Lvl)
	local normal = RoleDataSys.GetRoleTrain8(_Lvl)
	UISoldier.SoliderTrainControls.NormalCostCount.text = tostring(normal)
	local better = RoleDataSys.GetRoleTrain12(_Lvl)
	UISoldier.SoliderTrainControls.BetterCostCount.text = tostring(better)
	local best = RoleDataSys.GetRoleTrain24(_Lvl)
	UISoldier.SoliderTrainControls.BestTrainCount.text = tostring(best)
end

function UISoldier:ShowTrainColdInfo()			
	local itemCount = ItemPackageSys.GetItemCountById(UIstring.AddExpItem)
	UISoldier.SoliderTrainControls.AddExpItemLabel.text = "剩余突飞令：" .. itemCount
	
	local speedCount = ItemPackageSys.GetItemCountById(UIstring.CollectSpeedId)
	UISoldier.SoliderTrainControls.SpeedItem.text = "剩余加速符：" .. speedCount

	this:ShowAddExpCDInfo()
end

function UISoldier:ShowTrainSoldierList()
	this:ClearSoliderList(UISoldier.SliderTrainGodList)
	UISoldier.SoliderTrainControls.Grid.transform.parent:GetComponent("UIWrap"):ResetTrans(#UISoldier.SoldierDataList)
	UISoldier.SoliderTrainControls.Grid.transform.parent:GetComponent("UIPanel").clipOffset = Vector2(0,0)
	UISoldier.SoliderTrainControls.Grid.transform.parent.localPosition = Vector3(0,0,0)
	for i=1,#UISoldier.SoldierDataList , 1  do
		local data =
		{
			Index = i,
			Len = #UISoldier.SoldierDataList,
		}
		if UISoldier.SliderTrainGodList[i]~=nil then
			this:CreateSoldierTrainCallBack(UISoldier.SliderTrainGodList[i],data)
		else
			MainGameUI.CreateLittleItem(tostring(i) ,"SoldierItem" , UISoldier.SoliderTrainControls.Grid, data , this.CreateSoldierTrainCallBack , "UISoldier") 
		end
	end
	
end

function UISoldier:CreateSoldierTrainCallBack(_God , _Info)
	local index = _Info.Index
	UISoldier.SliderTrainGodList[index] = _God
	local data = UISoldier.SoldierDataList[index]

	if data == nil  then
		GameMain.CloseObj(_God)
		return
	end
	this:ShowItemInfo(_God , data)
	if index == _Info.Len then
		this:ShowTrainSoldierInfo(UISoldier.ClickTrainIndex)
		UISoldier.SoliderTrainControls.Grid.enabled = true
	end
end

function UISoldier:ShowTrainSoldierInfo(index)
	if UISoldier.ClickTrainIndex ~=0 then
		this:CloseObj(UISoldier.SliderTrainGodList[UISoldier.ClickTrainIndex].transform:FindChild("Choose"))
	end
		UISoldier.ClickTrainIndex=index
		this:OpenObj(UISoldier.SliderTrainGodList[index].transform:FindChild("Choose"))
		UISoldier.SoliderTrainControls.Model.transform.localEulerAngles = Vector3(0,150,0)
		local data=UISoldier.SoldierDataList[index]

		if UISoldier.TempTrainModel ~=nil then
			if data.ModelName~= UISoldier.TempTrainModel.name then
			  GameObject.Destroy(UISoldier.TempTrainModel)
			  UISoldier.TempTrainModel = nil
			end
		end		

		Create3DModel.CreateThModel(data.ModelName , "walk" , 5 , UISoldier.SoliderTrainControls.Model,UISoldier.CreateTrainModelCallBack ,true , nil)
		
		
		
		UISoldier.SoliderTrainControls.Hp.text = tostring(data:GetLife()) ..data:GetLifeGrowStr()
		UISoldier.SoliderTrainControls.Atk.text = tostring(data:GetAtk()) .. data:GetAtkGrowStr()
		UISoldier.SoliderTrainControls.AtkSpeed.text = tostring(data:GetAtkSpeed()) .. data:GetAtkSpeedGrowStr()
	local curLvlExp = data:GetLvlAndExp()
	local nextExp = RoleDataSys.GetRoleUpExp(curLvlExp[1])
	
	if nextExp ~= nil then
		if nextExp == 0 then
			UISoldier.SoliderTrainControls.sliderExp.value = 1
		else
			UISoldier.SoliderTrainControls.sliderExp.value = tonumber(curLvlExp[2])/nextExp
		end
	end
	if nextExp ~= 0 then
		UISoldier.SoliderTrainControls.sliderExpNum.text = tostring(curLvlExp[2]) .. "/" .. (nextExp)
	else
		UISoldier.SoliderTrainControls.sliderExpNum.text = tostring(curLvlExp[2])
	end
	
	
	UISoldier.SoliderTrainControls.Name.text=  UIstring.WordColor[data.quality].. "Lv" .. tostring(curLvlExp[1]).." "..tostring(data.nickname).."[-]"
	this:ShowTrainInfo(data)
	this:ShowTrainItemInfo(curLvlExp[1])
end

function UISoldier:ShowTrainInfo(data)				--显示训练的信息
	this:ShowNoTrainInfo()
	if data.TrainType == 0 then
		local train = UISoldier.SliderTrainGodList[UISoldier.ClickTrainIndex].transform:FindChild("train")
		GameMain.CloseObj(train)
		return
	end
	this:ShowGrayBtnInfo(data.TrainType)
	UISoldier.TrainIndex = UISoldier.ClickTrainIndex
	GameMain.AddUpdateLua(this.UpdateTime)
end

function UISoldier:UpdateTime()
	local data = UISoldier.SoldierDataList[UISoldier.ClickTrainIndex]
	local timeName = "Train" .. data.Dbid
	local time = TimeControl.GetTime(timeName)
	
	if data.TrainType == 1 then
		--普通训练
		if time<=0 then
			GameMain.CloseObj(UISoldier.SoliderTrainControls.NormalTrainIng)
			GameMain.OpenObj(UISoldier.SoliderTrainControls.NormalNoTrain)
			GameMain.DelUpdateLua(this.UpdateTime)
			return
		end
		GameMain.OpenObj(UISoldier.SoliderTrainControls.NormalTrainIng)
		GameMain.CloseObj(UISoldier.SoliderTrainControls.NormalNoTrain)
		UISoldier.SoliderTrainControls.NormalTimeLabel.text = TimeControl.GetTimeString(time)
	end
	if data.TrainType == 2 then
		--高级训练
		if time<=0 then
			GameMain.CloseObj(UISoldier.SoliderTrainControls.BetterTrainIng)
			GameMain.OpenObj(UISoldier.SoliderTrainControls.BetterNoTrain)
			GameMain.DelUpdateLua(this.UpdateTime)
			return
		end
		GameMain.OpenObj(UISoldier.SoliderTrainControls.BetterTrainIng)
		GameMain.CloseObj(UISoldier.SoliderTrainControls.BetterNoTrain)
		UISoldier.SoliderTrainControls.BetterTimeLabel.text = TimeControl.GetTimeString(time)
	end
	if data.TrainType == 3 then
		--Vip训练
		if time<=0 then
			GameMain.CloseObj(UISoldier.SoliderTrainControls.BestTrainIng)
			GameMain.OpenObj(UISoldier.SoliderTrainControls.BestNoTrain)
			GameMain.DelUpdateLua(this.UpdateTime)
			return
		end
		GameMain.OpenObj(UISoldier.SoliderTrainControls.BestTrainIng)
		GameMain.CloseObj(UISoldier.SoliderTrainControls.BestNoTrain)
		UISoldier.SoliderTrainControls.BestTimeLabel.text = TimeControl.GetTimeString(time)
	end

end

function UISoldier:SendWebToTrain(_Type)
	local data = UISoldier.SoldierDataList[UISoldier.ClickTrainIndex]
	local isCanTrain = data:IsCanAddExp()	
	if isCanTrain == false then
		DataUIInstance.PopTip("请提升主角等级")
		return
	end
	local lvl = data:GetLvl()
	
	if data.TrainType == 0 then
		
		if UISoldier.CurTrainCount>=UISoldier.TrainLimitCount then
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
				return
			end
		end
		UISoldier.CurTrainCount = UISoldier.CurTrainCount + 1
		data:SoliderTrain(_Type)
	else
		if data.TrainType == _Type then
			this:PopConfrimPanel(data)
		else
			DataUIInstance.PopTip("士兵训练中")
		end
	end
	this:ShowTrainCountInfo()
end

function UISoldier:PopConfrimPanel(data)
	DataUIInstance.PopConfirmPanel("是否确认终止此次训练？" , this.ConfirmCancelTrain , nil)
end

function UISoldier:ConfirmCancelTrain()
	UISoldier.CurTrainCount = UISoldier.CurTrainCount -1
	local data = UISoldier.SoldierDataList[UISoldier.ClickTrainIndex]
	data:StopSoliderTrain()
	data.TrainType = 0
	local train = UISoldier.SliderTrainGodList[UISoldier.ClickTrainIndex].transform:FindChild("train")
	GameMain.CloseObj(train)
	this:ShowNoTrainInfo()
	this:ShowTrainCountInfo()
end

function UISoldier:SendWebTrainAfterInfo(_Data)
	UISoldier.SoldierDataList[UISoldier.ClickTrainIndex] = _Data
	this:SetTypeData(_Data)
	local Train = UISoldier.SliderTrainGodList[UISoldier.ClickTrainIndex].transform:FindChild("train")
	GameMain.OpenObj(Train)
	this:ShowTrainInfo(UISoldier.SoldierDataList[UISoldier.ClickTrainIndex])
end

function UISoldier:SendWebToAddExp(_Type)			--1突飞 2猛进
	local data = UISoldier.SoldierDataList[UISoldier.ClickTrainIndex]
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
				if UISoldier.IsAutoAddExp == true then
					if UISoldier.IsAutoSpeed == true then
						this:ClearAddExpCD()
					else
						DataUIInstance.PopTip("冷却时间内不可以突飞")
					end
					return
				else
					DataUIInstance.PopTip("冷却时间内不可以突飞")
					return
				end
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
	end
	data:AddExpByItem(_Type)
end

function UISoldier:ShowAddExpByItemCallBack(data)			--显示突飞猛进之后的信息
	UISoldier.SoldierDataList[UISoldier.ClickTrainIndex] = data
	this:ShowItemInfo(UISoldier.SliderTrainGodList[UISoldier.ClickTrainIndex],UISoldier.SoldierDataList[UISoldier.ClickTrainIndex])
	this:SetTypeData(data)
	this:ShowTrainSoldierInfo(UISoldier.ClickTrainIndex)
	this:ShowTrainColdInfo()
	if UISoldier.IsAutoAddExp == true then
		this:ToAutoAddExpAfter()
		local str = "消耗1个突飞令,增加100经验"
		this:ShowAutoInfo(str)
	end
end

function UISoldier:SetTypeData(_Data)
-- 2-盾，1-弓，3-枪，4-
	if _Data.RoleSeries ==2 then
		local index = this:GetIndexById(_Data.Dbid , UISoldier.DunDataList)
		UISoldier.DunDataList[index] = _Data
	end
	if _Data.RoleSeries ==1 then
		local index = this:GetIndexById(_Data.Dbid , UISoldier.GongDataList)
		UISoldier.GongDataList[index] = _Data
	end
	if _Data.RoleSeries ==3 then
		local index = this:GetIndexById(_Data.Dbid , UISoldier.QiangDataList)
		UISoldier.QiangDataList[index] = _Data
	end
end

function UISoldier:GetIndexById(_Id , _List)
	for i=1,#_List,1  do
		if _List[i].Dbid == _Id then
			return i
		end
	end
end

function UISoldier:ShowNoTrainInfo()
	this:ShowNormalBtnInfo()
	GameMain.DelUpdateLua(this.UpdateTime)
	GameMain.CloseObj(UISoldier.SoliderTrainControls.NormalTrainIng)
	GameMain.CloseObj(UISoldier.SoliderTrainControls.BetterTrainIng)
	GameMain.CloseObj(UISoldier.SoliderTrainControls.BestTrainIng)
	GameMain.OpenObj(UISoldier.SoliderTrainControls.NormalNoTrain)
	GameMain.OpenObj(UISoldier.SoliderTrainControls.BetterNoTrain)
	GameMain.OpenObj(UISoldier.SoliderTrainControls.BestNoTrain)
end

function UISoldier:OpenAutoPanel()
	GameMain.OpenObj(UISoldier.SoliderTrainControls.AutoPanel)
	if UISoldier.AutoControls.Info == nil then
		this:GetAutoControls()
	end
	UISoldier.IsAutoAddExp = false
	UISoldier.IsAutoSpeed = false
	UISoldier.AutoControls.Info.text = ""
	this:ShowUseSpeedInfo()
end

function UISoldier:GetAutoControls()
	UISoldier.AutoControls.Info = UISoldier.SoliderTrainControls.AutoPanel.transform:FindChild("text/Info"):GetComponent("UILabel")
	UISoldier.AutoControls.UseSpeedBtn = UISoldier.SoliderTrainControls.AutoPanel.transform:FindChild("chooseUseSpeed")
	UISoldier.AutoControls.NoUseSpeedBtn = UISoldier.SoliderTrainControls.AutoPanel.transform:FindChild("noChooseSpeed")
end

function UISoldier:ToStartAutoAddExp()	
	UISoldier.IsAutoAddExp = true	
	this:SendWebToAddExp(1)
end

function UISoldier:ToStopAutoAddExp()
	UISoldier.IsAutoAddExp = false	
	GameMain.DelUpdateLua(this.UpdateAutoExp)
end

function UISoldier:IsUseAutoSpeed(_IsUse)
	UISoldier.IsAutoSpeed = _IsUse
	this:ShowUseSpeedInfo()
end

function UISoldier:ShowUseSpeedInfo()
	if UISoldier.IsAutoSpeed == false then
		GameMain.OpenObj(UISoldier.AutoControls.UseSpeedBtn)
		GameMain.CloseObj(UISoldier.AutoControls.NoUseSpeedBtn)
	else
		GameMain.CloseObj(UISoldier.AutoControls.UseSpeedBtn)
		GameMain.OpenObj(UISoldier.AutoControls.NoUseSpeedBtn)
	end
end

function UISoldier:CloseAutoPanel()
	this:ToStopAutoAddExp()
	GameMain.CloseObj(UISoldier.SoliderTrainControls.AutoPanel)
	
end

function UISoldier.CreateTrainModelCallBack(NeedModel , _Data)
	UISoldier.TempTrainModel = NeedModel
	 
end

function UISoldier:UIHand(_LuaName , _Gob)
MusicManagerSys.ButtonClick()
	if _Gob.name=="Train" then --打开训练面板
		UISoldier.FirstCreateInfoModel = false
		this:ShowPanel("SoliderTrain")
	end
	if _Gob.name == "CloseSuccessGradeBtn" then
		this:CloseSuccessGradePanel()
	end

	if _Gob.name=="GoUp" then --打开进阶面板
		this:ShowPanel("SoliderUpGrade")
	end
	if _Gob.name=="CloseSoldierInfoBtn" then
		this:CloseObj(UISoldier.UISoldierGob)
	end
	if _Gob.name=="CloseUpGrade" then
		this:ShowUpAfterInfo()
	end
	if _Gob.name=="CloseHeroTrain" then
		this:ShowPanel("SoliderInfo")
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
		--专家训练
		this:SendWebToTrain(3)
	end
	if _Gob.name == "Fly" then
		--突飞
		this:SendWebToAddExp(1)
	end
	if _Gob.name == "HurryUp" then
		--猛进
		this:SendWebToAddExp(2)
	end
	local key=tonumber(_Gob.name)
	
	if key~=nil  then
		local parentName =_Gob.transform.parent.name
		--1-盾，2-弓，3-枪
		if parentName == "DunGrid" then
			UISoldier.ClickInfoType = 1
			this:ShowSoliderItemInfo(_Gob , UISoldier.DunDataList[key])
		end
		if parentName == "QiangGrid" then
			UISoldier.ClickInfoType = 3
			this:ShowSoliderItemInfo(_Gob , UISoldier.QiangDataList[key])
		end
		if parentName == "GongGrid" then
			UISoldier.ClickInfoType = 2

			this:ShowSoliderItemInfo(_Gob , UISoldier.GongDataList[key])
		end
		if parentName == "TrainGrid" then
			this:ShowTrainSoldierInfo(key)   
		end
		
	end
	
	if _Gob.name == "UpGrade" then
		this:SoliderUpGrade()
	end

	if _Gob.name == "HeroTrianWhy" then
		this:ShowHelpPanel()
	end
	if _Gob.name == "CloseHelpBtn" then
		this:CloseHelpPanel()
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
		this:IsUseAutoSpeed(true)
	end
	if _Gob.name == "noChooseSpeed" then
		this:IsUseAutoSpeed(false)
	end
	if _Gob.name == "SoliderPic" then
		this:SetCurSoliderPlayAni()
	end
	if _Gob.name == "Solidermodel" then
		this:SetCurSoliderPlayAni()
	end
end

function UISoldier:SetCurSoliderPlayAni()
	if UISoldier.TempInfoModel ~= nil then
		if UISoldier.TempInfoModel.activeInHierarchy == true then
			GameMain.ToPlayAni(UISoldier.TempInfoModel , "run")
		end
	end
	
	if UISoldier.TempUpGradeModel ~= nil then
		if UISoldier.TempUpGradeModel.activeInHierarchy == true then
			GameMain.ToPlayAni( UISoldier.TempUpGradeModel , "run")
		end
	end
	
	if UISoldier.TempReGradeModel ~= nil then
		if UISoldier.TempReGradeModel.activeInHierarchy == true then
			GameMain.ToPlayAni(UISoldier.TempReGradeModel , "run")
		end
	end
	
	if UISoldier.TempTrainModel ~= nil then
		if UISoldier.TempTrainModel.activeInHierarchy == true then
			GameMain.ToPlayAni(UISoldier.TempTrainModel , "run")
		end
	end
	
end

function UISoldier:ClearAddExpCD()
	local itemcount = ItemPackageSys.GetItemCountById(UIstring.CollectSpeedId)
	if itemcount<=0 then
		DataUIInstance.PopTip("道具不足")
		return
	end
	SoliderPackageSys.ClearAddExpCD()
end

function UISoldier:ClearAddExpCDCallBack()
	if UISoldier.IsAutoAddExp == true then
		this:ToAutoAddExpAfter()
		local str = "消耗1个加速符,增加100经验"
		this:ShowAutoInfo(str)
	end
	this:ShowTrainColdInfo()
end

function UISoldier:ShowAutoInfo(_Str)
	local strs = UISoldier.AutoControls.Info.text
	if strs == "" then
		strs = _Str
	else
		strs = strs .. "\n" .. _Str
	end
	UISoldier.AutoControls.Info.text = strs
end

function UISoldier:ToAutoAddExpAfter()
	TimeControl.LoginTime(1 , "AutoSoldierAddExp")
	GameMain.AddUpdateLua(this.UpdateAutoExp)
end

function UISoldier.UpdateAutoExp()
	local time = TimeControl.GetTime("AutoSoldierAddExp")
	if time<=0 then
		this:ToStartAutoAddExp()
		GameMain.DelUpdateLua(this.UpdateAutoExp)
	end
end

function UISoldier:ShowAddExpCDInfo()				--显示突飞，猛进的CD时间
	local time = TimeControl.GetTime("AddExpCDTime")
	if time == nil then
		this:DelAddExpTime()
		return
	end
	if time<=0 then
		this:DelAddExpTime()
		return
	end
	
	GameMain.OpenObj(UISoldier.SoliderTrainControls.ColdBtn)
	GameMain.AddUpdateLua(this.UpdataAddExpTime)
end

function UISoldier:UpdataAddExpTime()
	local time = TimeControl.GetTime("AddExpCDTime")
	if time~=nil then
		if time<=0 then
			this:DelAddExpTime()
		else
			local str =  TimeControl.GetTimeString(time)
			if time>10*60 then
				UISoldier.SoliderTrainControls.ColdTime.text = UIstring.Red .. "冷却时间：" .. str .. "[-]"
			else
				UISoldier.SoliderTrainControls.ColdTime.text = "冷却时间：" .. str
			end
		end
	else
		this:DelAddExpTime()
	end
	
end

function UISoldier:DelAddExpTime()
	GameMain.DelUpdateLua(this.UpdataAddExpTime)
	GameMain.CloseObj(UISoldier.SoliderTrainControls.ColdBtn)
end

function UISoldier:ShowHelpPanel()
	if UISoldier.SoliderTrainControls.HelpPanel == nil then
		UISoldier.SoliderTrainControls.HelpPanel = UISoldier.SoliderTrainPanel.transform:FindChild("HelpPanel")
	end
	GameMain.OpenObj(UISoldier.SoliderTrainControls.HelpPanel)
	if UISoldier.SoliderTrainControls.HelpInfo == nil then
			UISoldier.SoliderTrainControls.HelpInfo = UISoldier.SoliderTrainControls.HelpPanel.transform:FindChild("Scroll View/Label"):GetComponent("UILabel")
	end
	local helpInfo = TipsConfig.GetDataById(201)
		
	UISoldier.SoliderTrainControls.HelpInfo.text = helpInfo.Description
end

function UISoldier:CloseHelpPanel()
	GameMain.CloseObj(UISoldier.SoliderTrainControls.HelpPanel)
end


function UISoldier:UIOnPress(_LuaName , _Gob , _isPress)--按钮按下Icon事件
	
	 if _isPress==false then  
		this:CloseTipsPanel()
		end
	if _isPress==true then
		if _Gob.name == "Item" then
			this:ShowItemTipsPanel(_Gob)
		end
		
		local ItemKey = tonumber(_Gob.name)
	
       if ItemKey~=nil  then
			local ItemParent = _Gob.transform.parent
			
			if ItemParent.name=="GongGrid" then
				this:ShowSoliderTipsPanel(UISoldier.GongDataList[ItemKey],_Gob)
			elseif ItemParent.name=="QiangGrid" then
				this:ShowSoliderTipsPanel(UISoldier.QiangDataList[ItemKey],_Gob)
			elseif ItemParent.name=="DunGrid" then
				this:ShowSoliderTipsPanel(UISoldier.DunDataList[ItemKey],_Gob)
			elseif ItemParent.name == "TrainGrid" then
				this:ShowSoliderTipsPanel(UISoldier.SoldierDataList[ItemKey] , _Gob)
			end
	   end
	end
end

function UISoldier:ShowItemTipsPanel(_Gob)
	local pos = _Gob.transform.position
	local vec = Vector3(pos.x , pos.y , -460)
	local itemdata = ItemDataConfig.GetItemDBConfig(UIstring.SoliderUpGradeItemId)
	
	DataUIInstance.CreateTipsPanel( itemdata ,"Item" , vec)
end

function UISoldier:ShowSoliderTipsPanel(heroData , obj)--士兵tips信息显示
	local pos = obj.transform.position
	
	local vec = Vector3(pos.x,pos.y,-460)
	DataUIInstance.CreateTipsPanel(heroData, "Solider" , vec)
end

function UISoldier:CloseTipsPanel()
	local uiTar = MainGameUI.FindPanelTarget("TipsPanel")
	if uiTar~=nil then
		uiTar:ClosePanel()
	end
end

function UISoldier:ShowSoliderItemInfo(_Gob , data) --显示一个士兵的信息 
	if UISoldier.clickInfoTemp ~=nil then
		this:CloseObj(UISoldier.clickInfoTemp.transform:FindChild("Choose"))
	end
	UISoldier.clickInfoTemp = _Gob
	this:OpenObj(_Gob.transform:FindChild("Choose"))
	local curLvlExp = data:GetLvlAndExp()
	local ExpData = RoleDataSys.GetRoleUpExp(curLvlExp[1])
	
	if ExpData~=nil then
		if ExpData == 0 then
			UISoldier.SoliderInfoControls.SoliderExp.value = 1
		else
			UISoldier.SoliderInfoControls.SoliderExp.value = tonumber(curLvlExp[2])/ExpData
		end
	end
	local atk = data:GetAtk()
	local hp = data:GetLife()
	local atkDes = ""
	if UISoldier.BattleFlagsAttr[data.RoleSeries].Attack <= 0 then
		atkDes = ""
	else
		local value = GameMain.ConvertToInt(atk * UISoldier.BattleFlagsAttr[data.RoleSeries].Attack / 100)
		atkDes = UIstring.Green .. "+" .. value.."[-]"
	end
	
	local hpDes = ""
	if UISoldier.BattleFlagsAttr[data.RoleSeries].Hp <= 0 then
		hpDes = ""
	else
		local value = GameMain.ConvertToInt( hp * UISoldier.BattleFlagsAttr[data.RoleSeries].Hp / 100)
		hpDes =  UIstring.Green .."+"..value .."[-]"
	end
	if ExpData ~= 0 then
		UISoldier.SoliderInfoControls.ExpNum.text = tostring(curLvlExp[2]).."/" ..(ExpData)
	else
		UISoldier.SoliderInfoControls.ExpNum.text = tostring(curLvlExp[2])
	end
	
		local qlvl = ""
		if data.qualityLvl>0 then
			qlvl = "+" .. data.qualityLvl
		end
		UISoldier.SoliderInfoControls.Name.text= UIstring.WordColor[data.quality].."LV" .. tostring(curLvlExp[1]).." " .. tostring(data.nickname) .. qlvl .. "[-]"
		
		UISoldier.SoliderInfoControls.SoliderAtk.text = tostring(atk) .. data:GetAtkGrowStr() ..atkDes
		UISoldier.SoliderInfoControls.SoliderHp.text = tostring(hp) .. data:GetLifeGrowStr() .. hpDes
		UISoldier.SoliderInfoControls.SoliderAtkSpeed.text = tostring(data:GetAtkSpeed()) .. data:GetAtkSpeedGrowStr()
		UISoldier.SoliderInfoControls.SoliderType.text = tostring(data.AttackType)
		UISoldier.SoliderInfoControls.SoliderDistance.text = tostring(data.AttackRange)
		UISoldier.SoliderInfoControls.Model.transform.localEulerAngles = Vector3(0,150,0)
		if UISoldier.TempInfoModel ~=nil then
			if data.ModelName~= UISoldier.TempInfoModel.name then
			  GameObject.Destroy(UISoldier.TempInfoModel)
			  UISoldier.TempInfoModel = nil
			end
		end
		Create3DModel.CreateThModel(data.ModelName , "walk" , 5 , UISoldier.SoliderInfoControls.Model,UISoldier.CreateInfoModelCallBack ,true , nil)
end

function UISoldier.CreateInfoModelCallBack(NeedModel , _Data)
	UISoldier.TempInfoModel = NeedModel
end

function UISoldier:ReleasPanel()
	UISoldier.UISoldierGob = nil

	UISoldier.SoliderInfoPanel=nil
	UISoldier.SoliderUpGradePanel=nil
	UISoldier.SoliderTrainPanel=nil
	UISoldier.SoliderTipsPanel=nil

	UISoldier.SoliderInfoControls={}
	UISoldier.SoliderUpGradeControls={}
	UISoldier.SoliderTrainControls={}

	UISoldier.GongSoliderGodList={}
	UISoldier.DunSoliderGodList={}
	UISoldier.QiangSoldierGodList={}
	UISoldier.SliderGodList = {}
	UISoldier.SliderTrainGodList = {}
	UISoldier.AutoControls = {}

	UISoldier.TempInfoModel = nil		--显示的武将模型
	UISoldier.TempTrainModel = nil		--训练的武将模型
	UISoldier.TempReGradeModel = nil	--武将升阶前的武将模型
	UISoldier.TempUpGradeModel = nil	--武将升阶后的武将模型

	UISoldier.clickInfoTemp = nil		--士兵信息面板中的选中的单个士兵
	--Data
	UISoldier.SoldierDataList={}		--所有的士兵数据
	--UISoldier.ClickItemInfoIndex=0		--士兵信息面板中的选中的单个士兵
	UISoldier.ClickTrainIndex=0 --士兵训练面板中选中的单个士兵

	UISoldier.GongDataList = {}
	UISoldier.QiangDataList = {}
	UISoldier.DunDataList = {}

	UISoldier.ClickInfoType = 0		--点击士兵的类型

	UISoldier.FirstCreateInfoModel = false

	UISoldier.TrainIndex = 0		--正在训练的武将标记一下

	UISoldier.BattleFlagsAttr = nil	--战旗的相关属性

	UISoldier.TrainLimitCount = 0	--士兵训练的限制
	UISoldier.CurTrainCount = 0		--当前训练的个数

	UISoldier.IsAutoSpeed = false		--是否自动加速
	UISoldier.IsAutoAddExp = false		--是否自动加经验
	UISoldier.SoliderUpLimit = 1	--士兵进阶等级上限
	UISoldier.SuccessGradeControls = {}
	GameMain.DelUpdateLua(this.UpdataAddExpTime)
	GameMain.DelUpdateLua(this.UpdateAutoExp)
	GameMain.DelUpdateLua(this.UpdateTime)
end

function UISoldier:ReleasData()
	SoliderPackageSys.Soliders = {}
	SoliderPackageSys.DunSoliders={}
	SoliderPackageSys.QiangSoliders={}
	SoliderPackageSys.GongSoliders={}

	SoliderPackageSys.UpGradeTempId = 0		--进阶士兵的临时ID（用于区分是进阶的，还是获得的）
	SoliderPackageSys.TrainTempId = 0		--当前训练的士兵ID
	SoliderPackageSys.AddExpId = 0			--当前突飞，猛进的武将
	--是否排序
	SoliderPackageSys.IsSort = true;
end


--公用的方法
function UISoldier:CloseObj(obj)
	obj.gameObject:SetActive(false)
end
function UISoldier:OpenObj(obj)
	obj.gameObject:SetActive(true)
end

return UISoldier