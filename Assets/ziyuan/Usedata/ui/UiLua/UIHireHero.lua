--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIHireHero = {}
UIHireHero = BasePanel:new()
local this = UIHireHero
UIHireHero.UIHireHeroGod = nil

UIHireHero.HireInfoPanel = nil
UIHireHero.HeroShopPanel = nil
UIHireHero.HeroRotatePanel = nil
UIHireHero.HireAutoPanel = nil

UIHireHero.HireHeroInfoControls={}
UIHireHero.HeroShopControls = {}
UIHireHero.HeroRotateControls = {}
UIHireHero.HeroAutoControls = {}

UIHireHero.HireHeroTempList = {}
UIHireHero.HireHeroGodTempList = {}

UIHireHero.ClickHeroIndex = 0

UIHireHero.AutoHire = false

UIHireHero.ClickHireType = 0		--点击的招募的类型

UIHireHero.TempModel = nil			--武将模型

UIHireHero.ClickTag = 1				--当前所在的界面 1 招募 ， 2 转盘， 3 商店
UIHireHero.ClickShopTag = 0			--在商店所在的界面 1 武将 2 将魂

UIHireHero.ShopHeroDataList = {}
UIHireHero.ShopHunDataList = {}

UIHireHero.ShopGodList = {}

UIHireHero.HeroDiscDataList = {}

UIHireHero.AutoHireType = 0			--自动招募的类型 1初级 2高级 3VIP招募

UIHireHero.RotateAngle = 
{
	[1] = 120,
	[2] = 92, 
	[3] = 48,
	[4] = 20,
	[5] = 0, 
	[6] = -40,
	[7] = -60,
	[8] = -86, 
	[9] = -130,
	[10] = -156,
	[11] = -176, 
	[12] = 140,
}

UIHireHero.ChooseIndex = 0		--抽中的那个index
UIHireHero.AutoLotteyIndex = 0	--自动招募的index
UIHireHero.IsAutoLottery = false	--是否自动招募
UIHireHero.AutoLotteryHeroName = nil	--自动招募到的武将名字

function UIHireHero:OpenUI(_PanelName , _LuaName)
		
	if UIHireHero.UIHireHeroGod == nil then
		UIHireHero.UIHireHeroGod = MainGameUI.FindPanel("UIHireHero")
		UIHireHero.HireInfoPanel = UIHireHero.UIHireHeroGod.transform:FindChild("HireInfoPanel")
		UIHireHero.HeroShopPanel = UIHireHero.UIHireHeroGod.transform:FindChild("HeroShopPanel")
		UIHireHero.HeroRotatePanel = UIHireHero.UIHireHeroGod.transform:FindChild("HeroRotatePanel")
		UIHireHero.HireAutoPanel = UIHireHero.HireInfoPanel.transform:FindChild("AutoPanel")

		this:GetHireHeroInfoControls()
--		SummonSys.SummonStoreInit()
	end
	UIHireHero.AutoLotteryHeroData = nil
	this:ShowHireHeroPanelInfo()
end

function UIHireHero:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseHireInfo" then
		this:CloseHireHeroInfoPanel()
		
	end
	if _Gob.name == "NormalAutoBtn" then
		this:OpenAutoPanel(1)	--打开自动招募
	end
	if _Gob.name == "BetterAutoBtn" then
		this:OpenAutoPanel(2)
	end
	if _Gob.name == "closeAutoBtn" then
		UIHireHero.AutoHire = false
		this:CloseAutoHireHero()	--关闭自动招募
	end
	if _Gob.name == "CloseAutoPanel" then
		this:CloseAutoPanel()
	end
	if _Gob.name == "StartAutoBtn" then
		UIHireHero.AutoHire = true
		this:SetToAutoHireHero()
	end
	if _Gob.name == "NormalHireBtn" then
		this:HireHero(1)
	end
	if _Gob.name == "BetterHireBtn" then
		this:HireHero(2)
	end
	if _Gob.name == "BestHireBtn" then
		this:HireHero(3)
	end
	
	if  _Gob.name == "chooseAutoBtn" then
		this:SetIsAutoLottery(true)
	end
	if _Gob.name == "noChooseAutoBtn" then
		this:SetIsAutoLottery(false)	
	end

	if _Gob.name == "HireBtn" then
		this:lotteryHero()
	end

	if _Gob.name == "ChooseBtn" then
		this:OpenHeroRotatePanel()
	end
	
	if _Gob.name == "HeroShopBtn" then
		this:OpenHeroShopPanel()
	end

	if _Gob.name == "HelpHireInfo" then
		this:OpenHireInfoHelpPanel()
	end
	if _Gob.name == "CloseHelpBtn" then
		this:CloseHireInfoHelpPanel()
	end
	
	if _Gob.name == "CloseHireShop" then
		this:CloseHireShopPanel()
	end
	
	if _Gob.name == "CloseHireRotate" then
		this:CloseHireRotatePanel()
	end

	local ItemKey = tonumber(_Gob.name)
   
    if ItemKey~=nil  then
		local ParentName = _Gob.transform.parent.name
		if  ParentName=="HeroGrid" then
			if UIHireHero.HireHeroTempList[ItemKey]~=nil then                       --点击背包里面的道具
				this:ShowClickHeroInfo (ItemKey)             
				return
			end
		end
     end

	if _Gob.name == "buyHeroBtn" then
		local index = tonumber(_Gob.transform.parent.parent.name)
		this:ToBuyHeroShop(index)
	end
	if _Gob.name == "buyHunBtn" then
		local index = tonumber(_Gob.transform.parent.parent.name)
		this:ToBuyHeroShop(index)
	end
	if _Gob.name == "HeroBtn" then
		this:ShowHeroShopInfo()
	end
	if _Gob.name == "HeroHunBtn" then
		this:ShowHunShopInfo()
	end

	if _Gob.name == "addHunBtn" then

		local index = tonumber(_Gob.transform.parent.parent.name)
		this:ShowShopHunBuyInfo(index)
	end

	if _Gob.name == "RotateChooseBtn" then
		this:ToChooseReward()
	end
end

--region *.lua招募面板相关
function UIHireHero:GetHireHeroInfoControls()      --得到招募主面板的相关控件
	UIHireHero.HireHeroInfoControls.HelpPanel = UIHireHero.HireInfoPanel.transform:FindChild("HelpPanel")
 
	UIHireHero.HireHeroInfoControls.HeroGrid = UIHireHero.HireInfoPanel.transform:FindChild("HeroList/HeroesPanel/HeroGrid"):GetComponent("UIGrid")
	UIHireHero.HireHeroInfoControls.HeroShow = UIHireHero.HireInfoPanel.transform:FindChild("HeroShow/show")
	UIHireHero.HireHeroInfoControls.HeroType = UIHireHero.HireHeroInfoControls.HeroShow.transform:FindChild("Sprite"):GetComponent("UISprite")
	UIHireHero.HireHeroInfoControls.HeroModel = UIHireHero.HireHeroInfoControls.HeroShow.transform:FindChild("Model")
	
	UIHireHero.HireHeroInfoControls.HeroSkillImg = UIHireHero.HireInfoPanel.transform:FindChild("HeroInfo/HeroSkill/IMG"):GetComponent("UISprite")
	UIHireHero.HireHeroInfoControls.HeroSkillBorder = UIHireHero.HireInfoPanel.transform:FindChild("HeroInfo/HeroSkill/FG"):GetComponent("UISprite")
	UIHireHero.HireHeroInfoControls.HeroDefault = UIHireHero.HireInfoPanel.transform:FindChild("DefaultShow")

	UIHireHero.HireHeroInfoControls.HeroInfo = UIHireHero.HireInfoPanel.transform:FindChild("HeroInfo")
	UIHireHero.HireHeroInfoControls.HeroInfoName = UIHireHero.HireHeroInfoControls.HeroInfo.transform:FindChild("Name/Label"):GetComponent("UILabel")
	UIHireHero.HireHeroInfoControls.HeroInfoType = UIHireHero.HireHeroInfoControls.HeroInfo.transform:FindChild("Type/Label"):GetComponent("UILabel")
	UIHireHero.HireHeroInfoControls.HeroInfoAtk = UIHireHero.HireHeroInfoControls.HeroInfo.transform:FindChild("Atk/Label"):GetComponent("UILabel")
	UIHireHero.HireHeroInfoControls.HeroInfoBlood = UIHireHero.HireHeroInfoControls.HeroInfo.transform:FindChild("Blood/Label"):GetComponent("UILabel")
	UIHireHero.HireHeroInfoControls.HeroInfoSkill = UIHireHero.HireHeroInfoControls.HeroInfo.transform:FindChild("Skill/Label"):GetComponent("UILabel")
	
	local btns = UIHireHero.HireInfoPanel.transform:FindChild("Btns")
	UIHireHero.HireHeroInfoControls.HeroNormalHire = btns.transform:FindChild("NormalHireBtn/Label"):GetComponent("UILabel")
	UIHireHero.HireHeroInfoControls.HeroBetterHire = btns.transform:FindChild("BetterHireBtn/Label"):GetComponent("UILabel")
	UIHireHero.HireHeroInfoControls.HeroBestHire = btns.transform:FindChild("BestHireBtn/Label"):GetComponent("UILabel")
	UIHireHero.HireHeroInfoControls.HeroNormalHireCount = btns.transform:FindChild("NormalHireBtn/Count"):GetComponent("UILabel")
	UIHireHero.HireHeroInfoControls.HeroBetterHireCount = btns.transform:FindChild("BetterHireBtn/Count"):GetComponent("UILabel")
	UIHireHero.HireHeroInfoControls.HeroBestHireCount = btns.transform:FindChild("BestHireBtn/Count"):GetComponent("UILabel")

	UIHireHero.HireHeroInfoControls.PeopleSlider = UIHireHero.HireInfoPanel.transform:FindChild("Solider"):GetComponent("UISlider")
	UIHireHero.HireHeroInfoControls.PeopleValue = UIHireHero.HireInfoPanel.transform:FindChild("People/PeopleValue/Label"):GetComponent("UILabel")
	
	UIHireHero.HireHeroInfoControls.SummonValueCount = UIHireHero.HireInfoPanel.transform:FindChild("HireValue/Label"):GetComponent("UILabel")
	UIHireHero.HireHeroInfoControls.BetterHeroHunCount = UIHireHero.HireInfoPanel.transform:FindChild("BetterValue/Label"):GetComponent("UILabel")
	UIHireHero.HireHeroInfoControls.BestHeroHunCount = UIHireHero.HireInfoPanel.transform:FindChild("BestValue/Label"):GetComponent("UILabel")
	
	UIHireHero.HireHeroInfoControls.HireEff = UIHireHero.HireInfoPanel.transform:FindChild("HireEff")
	
end


function UIHireHero:GetAutoHireControls()			--得到自动招募的面板信息
	UIHireHero.HeroAutoControls.Info = UIHireHero.HireAutoPanel.transform:FindChild("Info"):GetComponent("UILabel")
	local choose = UIHireHero.HireAutoPanel.transform:FindChild("choose")
	UIHireHero.HeroAutoControls.ChooseBtn = choose.transform:FindChild("chooseAutoBtn")
	UIHireHero.HeroAutoControls.NoChooseBtn = choose.transform:FindChild("noChooseAutoBtn")
end

function UIHireHero:ShowHireCallBack()				--显示招募到武将库结果
	MusicManagerSys.HireHeroMusic()	
	this:ShowHireHeroPanelInfo()
	if UIHireHero.AutoHire == false then
		TimeControl.LoginTime(1,"HireHeroTime")
		--[[GameMain.OpenObj(UIHireHero.HireHeroInfoControls.HireEff)
		UIHireHero.HireHeroInfoControls.HireEff.transform:FindChild("HireEff (1)").localScale = Vector3(0,0,0)
		local tween = UIHireHero.HireHeroInfoControls.HireEff.transform:FindChild("HireEff (1)"):GetComponent("TweenScale")--]]
		--tween.enabled = true
		--tween:ResetToBeginning()
		--tween:Play()
		--GameMain.AddUpdateLua(this.UpDataHireEffTime)
		local list = SummonSys.TempSummonResult
		if #list>0 then
			for i=1,#list,1  do
				local data = SummonSys.GetSummonHeroById(SummonSys.TempSummonResult[i])
				if data.quality>=4 then
					DataUIInstance.PopConfirmPanel("招募到高级武将，主公别错过哦！")
					return
				end
			end
		end
	else
		this:ShowAutoHireNameInfo()
		if UIHireHero.IsAutoLottery == true then
			this:ShowAutoHireInfo(UIHireHero.AutoLotteyIndex)
		else
			this:SetAutoHire()
		end
	end
end

function UIHireHero:ShowAutoHireNameInfo()
	local list = UIHireHero.HireHeroTempList
	local strs = ""
	for i=1,#list,1  do
		if strs == "" then
			strs = "刷新到" .. UIstring.WordColor[list[i].quality].. list[i].nickname .. "[-]"
		else
			strs = strs .. "\n" .. "刷新到" .. UIstring.WordColor[list[i].quality] ..  list[i].nickname .. "[-]"
		end
	end
	UIHireHero.HeroAutoControls.Info.text = strs
end

function UIHireHero:SetAutoHire()
	TimeControl.SetTime("HireAutoTime" , 0)
	TimeControl.LoginTime(1,"HireAutoTime")
	GameMain.AddUpdateLua(this.WaitToAutoHire)
end

function UIHireHero:WaitToAutoHire()
	local time = TimeControl.GetTime("HireAutoTime")
	if time<=0 then
		this:SetToAutoHireHero()
		GameMain.DelUpdateLua(this.WaitToAutoHire)
	end
end

function UIHireHero:ShowAutoHireInfo(_Index)							--显示自动招募的信息
	local data = UIHireHero.HireHeroTempList[_Index]
	if data ~= nil then
		if data.quality>=4 then
			this:lotteryHero(_Index)
			return
		else
			UIHireHero.AutoLotteyIndex = UIHireHero.AutoLotteyIndex +1
		end
	end
	if _Index >= #UIHireHero.HireHeroTempList then
		UIHireHero.AutoLotteyIndex = 1
		this:SetAutoHire()
	else
		this:ShowAutoHireInfo(UIHireHero.AutoLotteyIndex)
	end
end

function UIHireHero:UpDataHireEffTime()
	--[[local time = TimeControl.GetTime("HireHeroTime")
	if time<=0 then
		--GameMain.CloseObj(UIHireHero.HireHeroInfoControls.HireEff)
		GameMain.DelUpdateLua(this.UpDataHireEffTime)
	end--]]
end

function UIHireHero:ShowHireHeroPanelInfo()			--显示招募主面板的信息
	UIHireHero.ClickTag = 1	
	local gridParent = UIHireHero.HireHeroInfoControls.HeroGrid.transform.parent
	gridParent:GetComponent("UIPanel").clipOffset = Vector2(0 , 0)
	gridParent.localPosition = Vector3(0 , 0 ,0)
	gridParent:GetComponent("UIScrollView").currentMomentum = Vector3(0,0,0)
	this:ShowHireHeroProp()	
	this:ShowFreeInfo()
	this:ShowSummonLocky()
	if #SummonSys.TempSummonResult == 0 then
		GameMain.CloseObj( UIHireHero.HireHeroInfoControls.HeroShow)
		GameMain.CloseObj( UIHireHero.HireHeroInfoControls.HeroInfo)
	else
		GameMain.OpenObj( UIHireHero.HireHeroInfoControls.HeroShow)
		GameMain.OpenObj( UIHireHero.HireHeroInfoControls.HeroInfo)
		
		for i=1,#SummonSys.TempSummonResult,1  do
			UIHireHero.HireHeroTempList[i] = SummonSys.GetSummonHeroById(SummonSys.TempSummonResult[i])
		end
		table.sort(UIHireHero.HireHeroTempList , UIHireHero.Comp)
		this:ShowHireHeroTempList()
	end
end

function UIHireHero:ShowSummonLocky()	--显示招募值和人品信息
	local summeValue = SummonSys.GetSummonPointValue()
	local lucky = SummonSys.GetLuckyPoint()
	local allLuck = ConstConfig.GetLuckLimit()
	UIHireHero.HireHeroInfoControls.SummonValueCount.text = tostring(summeValue)
	local betterCount = DebrisPackageSys.GetCountById(UIstring.BetterHeroHunId)
	local bestCount = DebrisPackageSys.GetCountById(UIstring.BetterHeroHunId)
	UIHireHero.HireHeroInfoControls.BetterHeroHunCount.text = tostring(betterCount)
	UIHireHero.HireHeroInfoControls.BestHeroHunCount.text = tostring(bestCount)
	if lucky>=allLuck then
		UIHireHero.HireHeroInfoControls.PeopleSlider.value = 1
	else
		UIHireHero.HireHeroInfoControls.PeopleSlider.value = lucky / allLuck
	end
	
	UIHireHero.HireHeroInfoControls.PeopleValue.text = tostring(lucky)
end

function UIHireHero:ShowFreeInfo()		--显示免费信息
	if UIHireHero.ClickHireType == 0 then
		this:ShowTypeFreeInfo(1 , UIHireHero.HireHeroInfoControls.HeroNormalHire)
		this:ShowTypeFreeInfo(2 , UIHireHero.HireHeroInfoControls.HeroBetterHire)
		this:ShowTypeFreeInfo(3 , UIHireHero.HireHeroInfoControls.HeroBestHire)
	else
		if UIHireHero.ClickHireType == 1 then
			this:ShowTypeFreeInfo(1 , UIHireHero.HireHeroInfoControls.HeroNormalHire)
		end
		if UIHireHero.ClickHireType == 2 then
			this:ShowTypeFreeInfo(2 , UIHireHero.HireHeroInfoControls.HeroBetterHire)
		end
		if UIHireHero.ClickHireType == 3 then
			this:ShowTypeFreeInfo(3 , UIHireHero.HireHeroInfoControls.HeroBestHire)
		end
	end
	
end

function UIHireHero:ShowTypeFreeInfo(_Type , _Label)
	if _Type==3 then
		if VipSys.VipLevel<3 then
			_Label.text = "vip3开启"
			return
		end
	end
	local free = SummonSys.IsFree(_Type)
	if free == true then
		--免费
		_Label.text = "免费招募一次"
	else
		if _Type ==1 then
			GameMain.AddUpdateLua(this.UpdateTimeOne)
		end
		if _Type ==2 then
			GameMain.AddUpdateLua(this.UpdateTimeTwo)
		end
		if _Type ==3 then
			GameMain.AddUpdateLua(this.UpdateTimeThree)
		end
	end
	UIHireHero.ClickHireType = 0
end

function UIHireHero:UpdateTimeOne()
	local time = TimeControl.GetTime("FreeSummonTime1")
	if time==nil then
		UIHireHero.HireHeroInfoControls.HeroNormalHire.text = "免费招募一次"
		GameMain.DelUpdateLua(this.UpdateTimeOne)
	else
		if time <=0 then
			UIHireHero.HireHeroInfoControls.HeroNormalHire.text = "免费招募一次"
			GameMain.DelUpdateLua(this.UpdateTimeOne)
		else
			UIHireHero.HireHeroInfoControls.HeroNormalHire.text = TimeControl.GetTimeString(time)
		end
	end
end

function UIHireHero:UpdateTimeTwo()
	local time = TimeControl.GetTime("FreeSummonTime2")
	if time==nil then
		UIHireHero.HireHeroInfoControls.HeroBetterHire.text = "免费招募一次"
		GameMain.DelUpdateLua(this.UpdateTimeTwo)
	else
		if time <= 0 then
			UIHireHero.HireHeroInfoControls.HeroBetterHire.text = "免费招募一次"
			GameMain.DelUpdateLua(this.UpdateTimeTwo)
		else
			UIHireHero.HireHeroInfoControls.HeroBetterHire.text = TimeControl.GetTimeString(time)
		end
		
	end
end

function UIHireHero:UpdateTimeThree()
	local time = TimeControl.GetTime("FreeSummonTime3")
	if time == nil then
		UIHireHero.HireHeroInfoControls.HeroBestHire.text = "免费招募一次"
		GameMain.DelUpdateLua(this.UpdateTimeThree)
	else
		if time <=0 then
			UIHireHero.HireHeroInfoControls.HeroBestHire.text = "免费招募一次"
			GameMain.DelUpdateLua(this.UpdateTimeThree)
		else
			UIHireHero.HireHeroInfoControls.HeroBestHire.text = TimeControl.GetTimeString(time)
		end
	end
end

function UIHireHero.Comp(A ,B)
	if A~=nil and B~=nil then
		if A.quality>B.quality then
			return true
		else
			return false
		end
	else
		return false
	end
end

function UIHireHero:ShowHireHeroTempList()
	if #UIHireHero.HireHeroTempList ==0 then
		GameMain.CloseObj( UIHireHero.HireHeroInfoControls.HeroShow)
		GameMain.CloseObj( UIHireHero.HireHeroInfoControls.HeroInfo)
		return
	end
	for i=1,#UIHireHero.HireHeroTempList,1  do
		local data = 
		{
			Index = i,
			HeroData = UIHireHero.HireHeroTempList[i],
			Len = #UIHireHero.HireHeroTempList,
		}
	
		if UIHireHero.HireHeroGodTempList[i] ~= nil then
			this:CreateTempHeroListCallBack(UIHireHero.HireHeroGodTempList[i] , data)
		else
			MainGameUI.CreateLittleItem(tostring(i) ,"HeroItem" , UIHireHero.HireHeroInfoControls.HeroGrid.transform , data , this.CreateTempHeroListCallBack , "UIHireHero") 	
		end
	end

end	
function UIHireHero:CreateTempHeroListCallBack(_God,_Info)
	local data = _Info
	UIHireHero.HireHeroGodTempList[_Info.Index] = _God
	this:ShowHeroItemInfo(data.HeroData , _God)

	if _Info.Len == _Info.Index then
		UIHireHero.HireHeroInfoControls.HeroGrid.enabled =true
		UIHireHero.HireHeroInfoControls.HeroGrid:Reposition()
		if _Info.Len>6 then
			GameMain.CloseObj(UIHireHero.HireHeroInfoControls.HeroDefault)
		else
			GameMain.OpenObj(UIHireHero.HireHeroInfoControls.HeroDefault)
		end
		this:ShowClickHeroInfo(1)
	end
end

function UIHireHero:ShowHeroItemInfo(data , _God)
	
	if data == nil then
		GameMain.CloseObj(_God)
	else
		local lvl = _God.transform:FindChild("Lvl"):GetComponent("UILabel")
		local quility = _God.transform:FindChild("FG"):GetComponent("UISprite")
		local heroIcon = _God.transform:FindChild("IMG"):GetComponent("UISprite")
		local name = _God.transform:FindChild("name"):GetComponent("UILabel")
		local Fg = _God.transform:FindChild("bg"):GetComponent("UISprite")
		GameMain.OpenObj(_God)

		name.text = UIstring.WordColor[data.quality] .. data.nickname .. "[-]" 
		AtlasMsg.SetAtlas(heroIcon , data.AtlasName ,data.SpriteName)
		quility.spriteName = UIstring.ItemFg[tonumber(data.quality)]
		Fg.spriteName = UIstring.ItemFg[tonumber(data.quality)]
		lvl.text = "lv." .. tostring(1)
	end
end

function UIHireHero:ShowHireHeroProp()							--显示招募道具的数量
	local normalData = ItemPackageSys.GetItemById(UIstring.NormalHireHeroId)
	local betterData = ItemPackageSys.GetItemById(UIstring.BetterHireHeroId)
	local bestData = ItemPackageSys.GetItemById(UIstring.BestHireHeroId)
	
	this:ShowHireHeroPropByType(UIHireHero.HireHeroInfoControls.HeroNormalHireCount , normalData)
	this:ShowHireHeroPropByType(UIHireHero.HireHeroInfoControls.HeroBetterHireCount , betterData)
	this:ShowHireHeroPropByType(UIHireHero.HireHeroInfoControls.HeroBestHireCount , bestData)

end

function UIHireHero:ShowHireHeroPropByType(_God , _Data)
	if _Data == nil then
		_God.text = 0
	else
		_God.text = tostring(_Data.Count)
	end
end

function UIHireHero:HireHeroClear()								--每次招募都要初始化清空
	SummonSys.ClearTempHeros()
	if #UIHireHero.HireHeroTempList ~= 0  then
		UIHireHero.HireHeroTempList = {}
	end
	this:ClearTempHeroGodList()
end

function UIHireHero:ClearTempHeroGodList()							--武将库列表初始化
	if #UIHireHero.HireHeroGodTempList~=0 then
		for key,value in pairs(UIHireHero.HireHeroGodTempList) do
			GameMain.CloseObj(value)
		end
	end
end

function UIHireHero:CloseHireHeroInfoPanel()				
	GameMain.CloseObj(UIHireHero.UIHireHeroGod.gameObject)
end

function UIHireHero:CloseAutoHireHero()
--	GameMain.CloseObj(UIHireHero.HireAutoPanel)
	UIHireHero.AutoHire = false
	if UIHireHero.AutoLotteryHeroData ~= nil then
		local str = "本次自动招募成功招募到" .. UIstring.WordColor[UIHireHero.AutoLotteryHeroData.quality] .. UIHireHero.AutoLotteryHeroData.nickname .. "[-]"
		DataUIInstance.PopConfirmPanel(str , nil ,nil)
	end
end

function UIHireHero:CloseAutoPanel()
	UIHireHero.AutoHire = false
	GameMain.CloseObj(UIHireHero.HireAutoPanel)
end

function UIHireHero:OpenAutoPanel(_Type)								--自动招募到武将库							
--	this:HireHero(_Type) 
	if UIHireHero.HeroAutoControls.Info == nil then
		this:GetAutoHireControls()
	end
	UIHireHero.AutoLotteryHeroData= nil
	UIHireHero.HeroAutoControls.Info.text = ""
	GameMain.OpenObj(UIHireHero.HireAutoPanel)
	UIHireHero.AutoHireType = _Type
	UIHireHero.AutoLotteyIndex = 1
	UIHireHero.AutoHire = false
end

function UIHireHero:SetToAutoHireHero()							--自动招募
		if UIHireHero.AutoHire == true then
			this:HireHero(UIHireHero.AutoHireType)
		end
	
end

function UIHireHero:SetIsAutoLottery(_IsAuto)
	UIHireHero.IsAutoLottery = _IsAuto
	if _IsAuto == true then
		GameMain.CloseObj(UIHireHero.HeroAutoControls.ChooseBtn)
		GameMain.OpenObj(UIHireHero.HeroAutoControls.NoChooseBtn)
	else
		GameMain.OpenObj(UIHireHero.HeroAutoControls.ChooseBtn)
		GameMain.CloseObj(UIHireHero.HeroAutoControls.NoChooseBtn)
	end
end

function UIHireHero:HireHero( _Type)							--招募到武将库
	UIHireHero.ClickHireType  = _Type
	if _Type == 3 then
		if VipSys.VipLevel<3 then
			DataUIInstance.PopTip("Vip3开启")
			return 
		end
	end
	if UIHireHero.AutoHire == false then
		if #UIHireHero.HireHeroTempList>0 then
			for i=1,#UIHireHero.HireHeroTempList,1  do
				if UIHireHero.HireHeroTempList[i].quality>=4 then
					DataUIInstance.PopConfirmPanel("招募到高级武将，主公别错过哦！")
					return
				end
			end
		end
	end
	
	local free = SummonSys.IsFree(_Type)
	if free == true then
		--免费
		SummonSys.SummonCard(_Type,1) 
	else	
		local count = 0	
		if _Type == 1 then
			count = ItemPackageSys.GetItemCountById(UIstring.NormalHireHeroId)
			if count<1 then
				DataUIInstance.PopTip("道具不足")
				return
			end
		end
		if _Type == 2 then
			count = ItemPackageSys.GetItemCountById(UIstring.BetterHireHeroId)
			if count<1 then
				local DBItemData = ShopSys.GetItemById(UIstring.BetterHireHeroId , 1)
				local data = 
				{
					Buy_SellType = 1,
					Item = DBItemData,
				}
				DataUIInstance.PopTipPanel("Buy_SellItems" , UIHireHero.BuyNormalCallBack , data)
				return 
			end
		end
		if _Type == 3 then
			count = ItemPackageSys.GetItemCountById(UIstring.BestHireHeroId)
			if count<1 then
				local DBItemData = ShopSys.GetItemById(UIstring.BestHireHeroId , 1)
				local data = 
				{
					Buy_SellType = 1,
					Item = DBItemData,
				}
				DataUIInstance.PopTipPanel("Buy_SellItems" , UIHireHero.BuyNormalCallBack , data)
				return 
			end
		end
		
		SummonSys.SummonCard(_Type,0) 
	end
	this:HireHeroClear()
--	DataUIInstance.PopTip(UIstring.HireHeroChoose)
end

function UIHireHero.BuyNormalCallBack(_Data)
	local _Item = _Data.Item
    ShopSys.BuyNormalItem(_Item.ShopId , _Data.Num)
end

function UIHireHero:lotteryHero(Index)								--正式招募武将
	if Index~=nil then
		local data = UIHireHero.HireHeroTempList[Index] 
		if data ~=nil then
			SummonSys.SummonGetCard(data.Dbid)
		end
	else
		if UIHireHero.ClickHeroIndex ~= 0  then
			local data = UIHireHero.HireHeroTempList[UIHireHero.ClickHeroIndex] 
			if data ~=nil then
				SummonSys.SummonGetCard(data.Dbid)
			end
		end
	end
end

function UIHireHero:ShowLotteryHeroInfo()					--显示正式招募后的信息
	if UIHireHero.AutoHire == true then
		local str = UIHireHero.HeroAutoControls.Info.text
		local data = UIHireHero.HireHeroTempList[UIHireHero.AutoLotteyIndex]
		UIHireHero.HeroAutoControls.Info.text = UIHireHero.HeroAutoControls.Info.text.."\n" .. "招募到" .. UIstring.WordColor[data.quality] .. data.nickname .. "[-]"
		UIHireHero.AutoLotteryHeroData = data
		UIHireHero.AutoLotteyIndex = UIHireHero.AutoLotteyIndex + 1
		this:ShowAutoHireInfo(UIHireHero.AutoLotteyIndex)
		return
	end
	local index = UIHireHero.ClickHeroIndex
	this:ClearTempHeroGodList()
	table.remove(UIHireHero.HireHeroTempList , this:GetHireTempIndex(index))
	DataUIInstance.PopTip("招募成功")
	GameMain.CloseObj(UIHireHero.HireHeroGodTempList[index].transform:FindChild("Choose"))
	UIHireHero.ClickHeroIndex = 0

	this:ShowHireHeroTempList()
	MusicManagerSys.HireHeroSuccessMusic()
end

function UIHireHero:GetHireTempIndex(index)
	for key,value in pairs(UIHireHero.HireHeroTempList) do
		if key == index then
			return key
		end
	end
	return nil
end
function UIHireHero:ShowClickHeroInfo(Index)
	local data = UIHireHero.HireHeroTempList[Index]
	if UIHireHero.HireHeroTempList[Index] ==nil then
		return
	end

	if UIHireHero.ClickHeroIndex ~=0 then
		GameMain.CloseObj( UIHireHero.HireHeroGodTempList[UIHireHero.ClickHeroIndex].transform:FindChild("Choose"))
	end
	UIHireHero.ClickHeroIndex = Index
	if UIHireHero.HireHeroGodTempList[UIHireHero.ClickHeroIndex] ~= nil then
		GameMain.OpenObj(UIHireHero.HireHeroGodTempList[UIHireHero.ClickHeroIndex].transform:FindChild("Choose"))
	end
	UIHireHero.HireHeroInfoControls.HeroInfoName.text =	UIstring.WordColor[data.quality] .. tostring(data.nickname) .."[-]"
	UIHireHero.HireHeroInfoControls.HeroModel.transform.localEulerAngles = Vector3(0,150,0)
	if UIHireHero.TempModel ~=nil then
		if data.ModelName~= UIHireHero.TempModel.name then
			 GameObject.Destroy(UIHireHero.TempModel)
			 UIHireHero.TempModel = nil
		end
	end
	if data.ModelName~=nil then
		Create3DModel.CreateThModel(data.ModelName , nil , 5 , UIHireHero.HireHeroInfoControls.HeroModel , UIHireHero.CreateModelCallBack , true , nil)  
	end

	UIHireHero.HireHeroInfoControls.HeroType.spriteName = UIstring.ItemFg[data.quality]
	UIHireHero.HireHeroInfoControls.HeroInfoType.text = tostring(data.AttackType)
	UIHireHero.HireHeroInfoControls.HeroInfoAtk.text =tostring(data:GetAtk())
	UIHireHero.HireHeroInfoControls.HeroInfoBlood.text =tostring(data:GetLife())
	
	UIHireHero.HireHeroInfoControls.HeroType.spriteName =  UIstring.QuilityImg[data.quality] 
	local skillData = RoleSkillConfig.GetRoleSkillById(data.SkillId)
	UIHireHero.HireHeroInfoControls.HeroInfoSkill.text = UIstring.WordColor[data.quality] .. tostring(skillData.Name) .. "[-]"
	UIHireHero.HireHeroInfoControls.HeroSkillBorder.spriteName = UIstring.ItemFg[data.quality]
	AtlasMsg.SetAtlas(UIHireHero.HireHeroInfoControls.HeroSkillImg , skillData.AtlasName , skillData.SpriteName)
	
end

function UIHireHero.CreateModelCallBack(NeedModel , _Data)
	UIHireHero.TempModel = NeedModel
	Create3DModel.CreateHorse(UIHireHero.TempModel , UIHireHero.Create3DHorseCallBack)  
end

function UIHireHero.Create3DHorseCallBack(_Model , _Data)
   _Model.transform.parent = UIHireHero.TempModel.transform
   _Model.transform.localPosition = Vector3(0 , -2 , 0)
end

function UIHireHero:OpenHireInfoHelpPanel()						--打开招募帮助面板
	if UIHireHero.ClickTag == 1 then
		GameMain.OpenObj(UIHireHero.HireHeroInfoControls.HelpPanel)
		if UIHireHero.HireHeroInfoControls.HelpInfo == nil then
			UIHireHero.HireHeroInfoControls.HelpInfo = UIHireHero.HireHeroInfoControls.HelpPanel.transform:FindChild("Scroll View/Label"):GetComponent("UILabel")
		end
		local helpInfo = TipsConfig.GetDataById(301)
		
		UIHireHero.HireHeroInfoControls.HelpInfo.text = helpInfo.Description
	end
end

function UIHireHero:CloseHireInfoHelpPanel()
	if UIHireHero.ClickTag == 1 then
		GameMain.CloseObj(UIHireHero.HireHeroInfoControls.HelpPanel)
	end
end
--endregion


--region *.lua  武将，武魂商店相关
function UIHireHero:OpenHeroShopPanel()							--打开面板
	UIHireHero.ClickTag = 3				--当前所在的界面 1 招募 ， 2 转盘， 3 商店
	GameMain.CloseObj(UIHireHero.HeroRotatePanel.gameObject)
	GameMain.CloseObj(UIHireHero.HireInfoPanel.gameObject)
	GameMain.OpenObj(UIHireHero.HeroShopPanel.gameObject)
	if UIHireHero.HeroShopControls.HireValue == nil then
		this:GetHeroShopControls()
		this:GetShopConfigData()
	end
	
	this:ShowHeroShopInfo()
end

function UIHireHero:GetHeroShopControls()
	UIHireHero.HeroShopControls.HeroGrid = UIHireHero.HeroShopPanel.transform:FindChild("ListPanel/HeroGrid"):GetComponent("UIGrid")
	UIHireHero.HeroShopControls.HireValue = UIHireHero.HeroShopPanel.transform:FindChild("HireValue/Label"):GetComponent("UILabel")
	UIHireHero.HeroShopControls.ListPanel = UIHireHero.HeroShopPanel.transform:FindChild("ListPanel"):GetComponent("UIPanel")
	UIHireHero.HeroShopControls.HeroBtn = UIHireHero.HeroShopPanel.transform:FindChild("HeroBtn")
	UIHireHero.HeroShopControls.HunBtn = UIHireHero.HeroShopPanel.transform:FindChild("HeroHunBtn")
end

function UIHireHero:GetShopConfigData()--得到商店的DB数据
	SummonSys.GetConfigData()
	UIHireHero.ShopHeroDataList = {}
	UIHireHero.ShopHunDataList = {}
	local heroList = SummonSys.GetShopHeroList()

	for key,value in pairs(heroList) do
		table.insert(UIHireHero.ShopHeroDataList , #UIHireHero.ShopHeroDataList +1 , value)
	end
	
	local hunList = SummonSys.GetShopHunList()
	for key,value in pairs(hunList) do
		table.insert(UIHireHero.ShopHunDataList , #UIHireHero.ShopHunDataList +1 ,value)
	end
end

function UIHireHero:CloseHireShopPanel()
	UIHireHero.ClickTag = 1				--当前所在的界面 1 招募 ， 2 转盘， 3 商店
	GameMain.CloseObj(UIHireHero.HeroRotatePanel.gameObject)
	GameMain.OpenObj(UIHireHero.HireInfoPanel.gameObject)
	GameMain.CloseObj(UIHireHero.HeroShopPanel.gameObject)
end


function UIHireHero:ClearShopGodList()
	if #UIHireHero.ShopGodList>0 then
		for key,value in pairs(UIHireHero.ShopGodList) do
			GameMain.CloseObj(value)
		end
		
	end
end

function UIHireHero:ShowHeroShopInfo()			--显示武将的商店信息
	UIHireHero.HeroShopControls.HireValue.text = tostring(SummonSys.GetSummonPointValue())
	if UIHireHero.ClickShopTag == 1 then
		return
	end
	UIHireHero.ClickShopTag = 1
	GameMain.OpenObj( UIHireHero.HeroShopControls.HeroBtn.transform:FindChild("click"))
	GameMain.CloseObj( UIHireHero.HeroShopControls.HunBtn.transform:FindChild("click"))
	this:ShowShopList()
end

function UIHireHero:ShowHunShopInfo()			--显示将魂的商店信息
	if UIHireHero.ClickShopTag == 2 then
		return
	end
	UIHireHero.ClickShopTag = 2
	GameMain.CloseObj( UIHireHero.HeroShopControls.HeroBtn.transform:FindChild("click"))
	GameMain.OpenObj( UIHireHero.HeroShopControls.HunBtn.transform:FindChild("click"))
	this:ShowShopList()
end

function UIHireHero:ShowShopList()				--显示商店列表
	this:ClearShopGodList()
	local len = 0
	if UIHireHero.ClickShopTag == 1 then
		len = #UIHireHero.ShopHeroDataList
	else
		len = #UIHireHero.ShopHunDataList
	end
	UIHireHero.HeroShopControls.ListPanel.transform:GetComponent("UIWrap"):ResetTrans(len)
	UIHireHero.HeroShopControls.ListPanel.clipOffset = Vector2(0 ,0)
	UIHireHero.HeroShopControls.ListPanel.transform.localPosition = Vector3(0,0,0)

	for i=1,12,1 do
		local data=
		{
			Index=i,
			Len = len
		}
		if UIHireHero.ShopGodList[i] == nil then
			MainGameUI.CreateLittleItem(tostring(i) , "HeroShopItem" , UIHireHero.HeroShopControls.HeroGrid , data , this.CreateHeroShopListCallBack , "UIHireHero") 
		else
			this:CreateHeroShopListCallBack(UIHireHero.ShopGodList[i],data)
		end
	end
end

function UIHireHero:CreateHeroShopListCallBack(_God , _Info)
	local index = _Info.Index
	if index == 12 then
		UIHireHero.HeroShopControls.HeroGrid.enabled = true
		UIHireHero.HeroShopControls.HeroGrid:Reposition()
		UIHireHero.HeroShopControls.ListPanel:GetComponent("UIWrap"):SetData(_Info.Len , "UIHireHero")
	end
	

	this:ShowShopItemInfo( _God , index)
	
end

function UIHireHero:ShowShopItemInfo(_God,Index)			--单个shopitem信息
	UIHireHero.ShopGodList[Index] = _God
	local data = nil
	if UIHireHero.ClickShopTag == 1 then
		data = UIHireHero.ShopHeroDataList[Index]
	end
	if UIHireHero.ClickShopTag == 2 then
		data = UIHireHero.ShopHunDataList[Index]
	end
	
	if data == nil then
		GameMain.CloseObj(_God)
		return
	end
	GameMain.OpenObj(_God)
	
	local hero = _God.transform:FindChild("hero")
	local hun = _God.transform:FindChild("hun")
	local name = _God.transform:FindChild("Name"):GetComponent("UILabel")
	local img = _God.transform:FindChild("Icon"):GetComponent("UISprite")
	local border = _God.transform:FindChild("type"):GetComponent("UISprite")
    local bg = _God.transform:FindChild("BG"):GetComponent("UISprite")

	if UIHireHero.ClickShopTag == 1 then
		GameMain.CloseObj(hun)
		GameMain.OpenObj(hero)
		local price = hero.transform:FindChild("price"):GetComponent("UILabel")
		price.text = tostring(data.NeedPrice)
	end

	if UIHireHero.ClickShopTag == 2 then
		GameMain.CloseObj(hero)
		GameMain.OpenObj(hun)
		local price = hun.transform:FindChild("price"):GetComponent("UILabel")
		local addNum = hun.transform:FindChild("addNum"):GetComponent("UILabel")
		addNum.text =tostring(1)
		data:SetBuyCount(1)
		price.text = tostring(data.NeedPrice)
	end
	name.text = UIstring.WordColor[data.Quality] .. data.Name .. "[-]"
	border.spriteName = UIstring.ItemFg[data.Quality]
	AtlasMsg.SetAtlas(img, data.AtlasName , data.SpriteName)
    AtlasMsg.SetAtlas(bg , UIstring.QualityBGAtlasName , UIstring.ItemFg[data.Quality])
end

function UIHireHero:UpdateItem(_LuaName , _Item)
	local index = tonumber(_Item.name)
	this:ShowShopItemInfo(_Item , index)
end

function UIHireHero:ShowShopHunBuyInfo(Index)

	if UIHireHero.ClickShopTag == 2 then
		local data = UIHireHero.ShopHunDataList[Index]
		local num = data.BuyCount +1
		local god = UIHireHero.ShopGodList[Index].transform:FindChild("hun")
		god.transform:FindChild("addNum"):GetComponent("UILabel").text = num
		god.transform:FindChild("price"):GetComponent("UILabel").text = tostring(data.NeedPrice*num)
		data:SetBuyCount(num)
	end
	
end

function UIHireHero:ToBuyHeroShop(Index)
	local data = nil
	if UIHireHero.ClickShopTag == 2 then
		data = UIHireHero.ShopHunDataList[Index]
	end
	if UIHireHero.ClickShopTag == 1 then
		data = UIHireHero.ShopHeroDataList[Index]
	end
	local needPrice = data.BuyCount*data.NeedPrice
	
	local myOwn = SummonSys.GetSummonPointValue()
	if myOwn<=needPrice then
		DataUIInstance.PopTip("招募值不足")
		return
	end
	SummonSys.SummonBuyHeroItem(data.Dbid , data.BuyCount)
	this:ShowRecTips(data)
end

function UIHireHero:ShowRecTips(_Data)
	local list = 
	{
		[1] = _Data
	}
	DataUIInstance.OpenRewards(list)
end

function UIHireHero:BuyHeroShopCallBack()
	local count = tostring(SummonSys.GetSummonPointValue())
	UIHireHero.HeroShopControls.HireValue.text = count
	UIHireHero.HireHeroInfoControls.SummonValueCount.text = count
end
--endregion


--region *.lua  转盘抽奖界面相关
function UIHireHero:GetHeroRotateControls()
--	UIHireHero.HeroRotateControls.ResultLabel = UIHireHero.HeroRotatePanel.transform:FindChild("Scroll View/Result/Label"):GetComponent("UILabel")
	UIHireHero.HeroRotateControls.GodList = {}
	local godList = UIHireHero.HeroRotatePanel.transform:FindChild("Lists")
	for i=1,12,1  do
		UIHireHero.HeroRotateControls.GodList[i] = godList.transform:FindChild(tostring(i))
	end	
	UIHireHero.HeroRotateControls.RotateImg = UIHireHero.HeroRotatePanel.transform:FindChild("jiantou")
	UIHireHero.HeroRotateControls.TweenRotate = UIHireHero.HeroRotateControls.RotateImg:GetComponent("TweenRotation")
	
	UIHireHero.HeroRotateControls.noChoose = UIHireHero.HeroRotatePanel.transform:FindChild("noChoose")
	UIHireHero.HeroRotateControls.canChoose = UIHireHero.HeroRotatePanel.transform:FindChild("canChoose")
end


function UIHireHero:OpenHeroRotatePanel()
	UIHireHero.ClickTag = 2				--当前所在的界面 1 招募 ， 2 转盘， 3 商店
	GameMain.OpenObj(UIHireHero.HeroRotatePanel.gameObject)
	GameMain.CloseObj(UIHireHero.HireInfoPanel.gameObject)
	GameMain.CloseObj(UIHireHero.HeroShopPanel.gameObject)
	if UIHireHero.HeroRotateControls.ResultLabel == nil then
		this:GetHeroRotateControls()
		this:SetRotateInfo()
	end
	this:ShowHeroRotateInfo()
	this:ShowIsCanChoose()
end

function UIHireHero:ShowIsCanChoose()
	local luckyValue = SummonSys.GetLuckyPoint()
	local limitValue = ConstConfig.GetLuckLimit()
	if luckyValue>=limitValue then
		GameMain.CloseObj(UIHireHero.HeroRotateControls.noChoose)
		GameMain.OpenObj(UIHireHero.HeroRotateControls.canChoose)
	else
		GameMain.OpenObj(UIHireHero.HeroRotateControls.noChoose)
		GameMain.CloseObj(UIHireHero.HeroRotateControls.canChoose)
	end
end

function UIHireHero:SetRotateInfo()
	local list = SummonSys.GetHeroDiscData()
	for key,value in pairs(list) do
		table.insert(UIHireHero.HeroDiscDataList , #UIHireHero.HeroDiscDataList +1 , value)
	end
	
end

function UIHireHero:ShowHeroRotateInfo()
	for i=1,12,1 do
		local id = UIHireHero.HeroDiscDataList[i].Reward
		local role = RoleDataConfig.GetRoleById(id)
		local god = UIHireHero.HeroRotateControls.GodList[i]
		local img = god.transform:FindChild("IMG"):GetComponent("UISprite")
		local fg = god.transform:FindChild("FG"):GetComponent("UISprite")
		local bgFG = god.transform:FindChild("bgFg"):GetComponent("UISprite")
	
		AtlasMsg.SetAtlas(img , role.AtlasName , role.SpriteName)
		fg.spriteName = UIstring.ItemFg[role.Quality]
		bgFG.spriteName = UIstring.ItemFg[role.Quality]
	end
	
end

function UIHireHero:CloseHireRotatePanel()
	UIHireHero.ClickTag = 1				--当前所在的界面 1 招募 ， 2 转盘， 3 商店
	GameMain.CloseObj(UIHireHero.HeroRotatePanel.gameObject)
	GameMain.OpenObj(UIHireHero.HireInfoPanel.gameObject)
	GameMain.CloseObj(UIHireHero.HeroShopPanel.gameObject)
end

function UIHireHero:ToChooseReward()
	local count = SummonSys.GetLuckyPoint()
	local limitValue = ConstConfig.GetLuckLimit()
	if count<limitValue then
		DataUIInstance.PopTip("人品值不足")
		return
	end
	SummonSys.SummonTurnReward() 
end

function UIHireHero:ToChooseRwdCallBack(_ID)
	UIHireHero.ChooseIndex = 0
	this:ShowIsCanChoose()
	local index = this:GetIndexById(tonumber(_ID))
	if index~=nil then
		this:ShowSummonLocky()
		UIHireHero.ChooseIndex = index
		local curRotate = UIHireHero.HeroRotateControls.RotateImg.transform.localEulerAngles
		UIHireHero.HeroRotateControls.TweenRotate.from = curRotate 
		UIHireHero.HeroRotateControls.TweenRotate.to = Vector3(0,0,-1080+UIHireHero.RotateAngle[index])
		UIHireHero.HeroRotateControls.TweenRotate.enabled = true
		UIHireHero.HeroRotateControls.TweenRotate:ResetToBeginning()
		UIHireHero.HeroRotateControls.TweenRotate:Play()

		local rotateTime = UIHireHero.HeroRotateControls.TweenRotate.duration + 0.3
		local time = TimeControl.GetTime("SummonRotate")
		if time == nil then
			time = TimeControl.LoginTime(rotateTime,"SummonRotate")
		else
			TimeControl.SetTime("SummonRotate", rotateTime)
		end
		GameMain.AddUpdateLua(this.UpdateRoateTime)
	end
	
end

function UIHireHero:UpdateRoateTime()
	local time = TimeControl.GetTime("SummonRotate")
	if time<=0 then
		this:ShowPopRwd(UIHireHero.ChooseIndex)
		GameMain.DelUpdateLua(this.UpdateRoateTime)
	end
end

function UIHireHero:ShowPopRwd(_Index)
	local data = UIHireHero.HeroDiscDataList[_Index]
	local role = RoleDataConfig.GetRoleById(data.Reward)
	
	local list = {}
	list[1] = role
	list[1].Count = 1
	DataUIInstance.OpenRewards(list)
end

function UIHireHero:GetIndexById(_ID)
	for key,value in pairs(UIHireHero.HeroDiscDataList) do
		if value.Id == _ID then
			return key
		end
	end
	return nil 
end
--endregion

function UIHireHero:UIOnPress(_LuaName , _Gob , _isPress)
	if _isPress==false then  
		this:CloseTipsPanel()	
	end    
	if _isPress==true then
		if _Gob.name == "HireValue" then
			this:ShowHireTipsPanel(_Gob)
		end
	end
end
function UIHireHero:ShowHireTipsPanel(_Gob)
	local pos = _Gob.transform.position
	local vec = Vector3(pos.x,pos.y,0)
	DataUIInstance.CreateTipsPanel( nil , "SummonValue" , vec)
end

function UIHireHero:CloseTipsPanel()
	local uiTar = MainGameUI.FindPanelTarget("TipsPanel")
	if uiTar~=nil then
		uiTar:ClosePanel()
	end
end
function UIHireHero:ReleasPanel()
	UIHireHero.UIHireHeroGod = nil

	UIHireHero.HireInfoPanel = nil
	UIHireHero.HeroShopPanel = nil
	UIHireHero.HeroRotatePanel = nil
	UIHireHero.HireAutoPanel = nil

	UIHireHero.HireHeroInfoControls={}
	UIHireHero.HeroShopControls = {}
	UIHireHero.HeroRotateControls = {}
	UIHireHero.HeroAutoControls = {}

	UIHireHero.HireHeroTempList = {}
	UIHireHero.HireHeroGodTempList = {}

	UIHireHero.ClickHeroIndex = 0

	UIHireHero.AutoHire = false

	UIHireHero.ClickHireType = 0		--点击的招募的类型

	UIHireHero.TempModel = nil			--武将模型

	UIHireHero.ClickTag = 1				--当前所在的界面 1 招募 ， 2 转盘， 3 商店
	UIHireHero.ClickShopTag = 0			--在商店所在的界面 1 武将 2 将魂

	UIHireHero.ShopHeroDataList = {}
	UIHireHero.ShopHunDataList = {}

	UIHireHero.ShopGodList = {}

	UIHireHero.HeroDiscDataList = {}

	UIHireHero.AutoHireType = 0			--自动招募的类型 1初级 2高级 3VIP招募

	UIHireHero.RotateAngle = 
	{
		[1] = 120,
		[2] = 92, 
		[3] = 48,
		[4] = 20,
		[5] = 0, 
		[6] = -40,
		[7] = -60,
		[8] = -86, 
		[9] = -130,
		[10] = -156,
		[11] = -176, 
		[12] = 140,
	}

	UIHireHero.ChooseIndex = 0		--抽中的那个index
	UIHireHero.IsAutoLottery = false	--是否自动招募
	UIHireHero.AutoLotteyIndex = 0	--自动招募的index
	UIHireHero.AutoLotteryHeroData = nil	--自动招募到的武将名字
	GameMain.DelUpdateLua(this.UpdateTimeOne)
	GameMain.DelUpdateLua(this.UpdateTimeTwo)
	GameMain.DelUpdateLua(this.UpdateTimeThree)
	GameMain.DelUpdateLua(this.UpDataHireEffTime)
	GameMain.DelUpdateLua(this.UpdateRoateTime)
end

function UIHireHero:ReleasData()
	SummonSys.TempSummonResult = {}					 --临时招募到的英雄
	SummonSys.SummonFreeTime = {}

	SummonSys.ShopHeroList = {}
	SummonSys.ShopHunList = {}

	SummonSys.luckyPoint = 0					--人品值
	SummonSys.SummonPoint = 0					--招募值 

end

return UIHireHero
--endregion