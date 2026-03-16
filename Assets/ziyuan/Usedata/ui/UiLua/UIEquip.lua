--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UIEquip = {}
UIEquip = BasePanel:new()
local this = UIEquip
--UI相关
UIEquip.UIEquipGod = nil

UIEquip.SmeltEquipPanel = nil

UIEquip.HandleEquipPanel = nil
UIEquip.StrengthEquipPanel = nil
UIEquip.PurifyEquipPanel = nil
UIEquip.RecastEquipPanel = nil

UIEquip.SmeltControls = {}	
UIEquip.HandleCommonControls = {}

UIEquip.TempModel = nil	--武将模型

UIEquip.HeroDressEquips = 
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

UIEquip.StrengthControls = {}
UIEquip.RecastControls = {}
UIEquip.PurifyControls = {}

--UIEquip.CurShowPanel = nil
UIEquip.TagClick = nil

UIEquip.TagsName =
{
	[1] = "SmeltTag",
	[2] = "StrongTag",
	[3] = "RecastTag",
	[4] = "PurifyTag",
}

UIEquip.EquipSmeltGodList = {}
UIEquip.HeroGodList = {}
UIEquip.EquipRecastMatGodList = {}				--装备重铸的材料
UIEquip.EquipRecastAddItemList = {}			--显示选择的重铸list
UIEquip.AutoStrengthControls = {}		--自动强化的控件
UIEquip.AutoSmeltControls = {}				--自动冶炼的控件
--Data 相关
UIEquip.EquipSmeltDataList = {}				--冶炼刷新出来的装备
UIEquip.SmeltType = 0						--冶炼的类型
UIEquip.HeroDataList = {}					--武将列表
UIEquip.ClickHeroIndex = 0					--点击的那个武将的index
UIEquip.ClickEquipItem = nil				--点击的那个装备
UIEquip.ClickEquipIndex = 0					--点击的装备的index
UIEquip.EquipRecastMatDataList = {}			--装备选择的材料list
UIEquip.EquipRecastAddDataList = {}			--显示重铸的材料list数据
UIEquip.ClickMatIndex = 0					--点击的那个add材料

UIEquip.PurifyItemCount = 0	--洗炼道具的数量

UIEquip.RecastNeedNum = 0					--重铸的需要的材料数量
UIEquip.UseStrengthProp = false				--是否使用强化符
UIEquip.IsAutoPurify = false				--是否自动洗炼
UIEquip.IsAutoStrong = false				--是否自动强化
UIEquip.IsAutoSpeed = false					--是否自动使用加速符
UIEquip.IsAutoSmelt = false					--是否自动冶炼
UIEquip.IsAutoBuySemltEquip = false			--是否自动购买冶炼品质高的装备
UIEquip.AutoBuySemltIndex = 0				--购买冶炼的index

function UIEquip:OpenUI(_PanelName , _LuaName)

	if UIEquip.UIEquipGod == nil then
		UIEquip.UIEquipGod = MainGameUI.FindPanel("UIEquip")
		UIEquip.SmeltEquipPanel = UIEquip.UIEquipGod.transform:FindChild("SmeltEquipPanel")
		UIEquip.HandleEquipPanel =UIEquip.UIEquipGod.transform:FindChild("EquiphandlePanel")
		local handlePanels = UIEquip.UIEquipGod.transform:FindChild("EquiphandlePanel/Right")
		UIEquip.StrengthEquipPanel = handlePanels.transform:FindChild("StrengthEquip")
		UIEquip.RecastEquipPanel = handlePanels.transform:FindChild("RecastEquip")
		UIEquip.PurifyEquipPanel = handlePanels.transform:FindChild("PurifyEquip")
	end
	this:OpenInit()
end

function UIEquip:OpenInit()
	GameMain.CloseObj(UIEquip.HandleEquipPanel)
	GameMain.OpenObj(UIEquip.SmeltEquipPanel)
	local god = UIEquip.UIEquipGod.transform:FindChild("Tags/SmeltTag")
	if UIEquip.TagClick == nil then
		UIEquip.TagClick = god
	end
	this:SetHeroData()
	this:ChangePanel(god)
end

function UIEquip:ChangePanelToStrength()
	local god = UIEquip.UIEquipGod.transform:FindChild("Tags/StrongTag")
	if UIEquip.TagClick == nil then
		UIEquip.TagClick = god
	end
	this:ChangePanel(god)
end

function UIEquip:ChangePanel(_God)
	if UIEquip.TagClick ~= nil then
		GameMain.OpenObj(UIEquip.TagClick.transform:FindChild("normal"))
		GameMain.CloseObj(UIEquip.TagClick.transform:FindChild("click"))		
	end

	UIEquip.TagClick = _God
	GameMain.CloseObj(UIEquip.TagClick.transform:FindChild("normal"))
	GameMain.OpenObj(UIEquip.TagClick.transform:FindChild("click"))
	this:StopAutoPurify()
	if _God.name == UIEquip.TagsName[1] then
		GameMain.CloseObj(UIEquip.HandleEquipPanel)
		GameMain.OpenObj(UIEquip.SmeltEquipPanel)
		this:ShowSmeltPanelInfo()
		GameMain.DelUpdateLua(this.UpdateRateTime)
	else
		this:ShowHandleCommonInfo()
		GameMain.CloseObj(UIEquip.SmeltEquipPanel)
		GameMain.OpenObj(UIEquip.HandleEquipPanel)
		if _God.name ==UIEquip.TagsName[2] then
			this:ShowStrongPanelInfo()
		end
	
		if _God.name ==UIEquip.TagsName[3] then
			this:ShowRecastPanelInfo()
			GameMain.DelUpdateLua(this.UpdateRateTime)
		end

		if _God.name == UIEquip.TagsName[4] then
			this:ShowPurifyPanelInfo()
			GameMain.DelUpdateLua(this.UpdateRateTime)
		end
	end
end

--region *.装备冶炼
function UIEquip:GetSmeltControls()					
	UIEquip.SmeltControls.SemltItems = UIEquip.SmeltEquipPanel.transform:FindChild("SmeltEquips")
	UIEquip.SmeltControls.NormalSmeltInfo = UIEquip.SmeltEquipPanel.transform:FindChild("SmeltBtns/NormalSmeltBtn/Label"):GetComponent("UILabel")
	UIEquip.SmeltControls.BetterSmeltInfo = UIEquip.SmeltEquipPanel.transform:FindChild("SmeltBtns/BetterSmeltBtn/Label"):GetComponent("UILabel")
	UIEquip.SmeltControls.BestSmeltInfo = UIEquip.SmeltEquipPanel.transform:FindChild("SmeltBtns/BestSmeltBtn/Label"):GetComponent("UILabel")
	
	UIEquip.SmeltControls.NormalSmeltItemImg = UIEquip.SmeltEquipPanel.transform:FindChild("SmeltBtns/NormalSmeltBtn/Sprite"):GetComponent("UISprite")
	UIEquip.SmeltControls.BetterSmeltItemImg = UIEquip.SmeltEquipPanel.transform:FindChild("SmeltBtns/BetterSmeltBtn/Sprite"):GetComponent("UISprite")
	UIEquip.SmeltControls.BestSmeltItemImg = UIEquip.SmeltEquipPanel.transform:FindChild("SmeltBtns/BestSmeltBtn/Sprite"):GetComponent("UISprite")
	
	UIEquip.SmeltControls.NormalSmeltCount =  UIEquip.SmeltControls.NormalSmeltItemImg.transform:FindChild("count"):GetComponent("UILabel")
	UIEquip.SmeltControls.BetterSmeltCount =  UIEquip.SmeltControls.BetterSmeltItemImg.transform:FindChild("count"):GetComponent("UILabel")
	UIEquip.SmeltControls.BestSmeltCount =  UIEquip.SmeltControls.BestSmeltItemImg.transform:FindChild("count"):GetComponent("UILabel")
	
	UIEquip.SmeltControls.HelpPanel = UIEquip.SmeltEquipPanel.transform:FindChild("HelpPanel")
	UIEquip.SmeltControls.AutoPanel = UIEquip.SmeltEquipPanel.transform:FindChild("AutoSmeltPanel")

	local equips = UIEquip.SmeltEquipPanel.transform:FindChild("SmeltEquips")
	for i=1,5,1  do
		UIEquip.EquipSmeltGodList[i] = equips.transform:FindChild(tostring(i))
	end
end

function UIEquip:ShowSmeltCallBack()			--冶炼刷新之后的显示
	this:ShowSmeltPanelInfo()
	if UIEquip.IsAutoSmelt == true then
		this:ShowAutoSmeltInfo()
		this:SmeltAfterToBuyAuto(1)
	else
		local list = EquipSummonSys.GetTempEquipList()
		for i=1,#list,1  do
			if list[i].Quality>=5 then
				DataUIInstance.PopConfirmPanel("恭喜你刷到好装备了，不容错过！")
				return
			end
		end
	end
end

function UIEquip:ShowAutoSmeltInfo()
	local list = EquipSummonSys.GetTempEquipList()
	local strs = ""
	for i=1,#list,1  do
		if strs == "" then
			strs = "刷新到" .. UIstring.WordColor[list[i].Quality] .. list[i].nickname .. "[-]"
		else
			strs = strs .. "\n" .. "刷新到" .. UIstring.WordColor[list[i].Quality] .. list[i].nickname .. "[-]"
		end
	end
	UIEquip.AutoSmeltControls.Info.text = strs
end

function UIEquip:SmeltAfterToBuyAuto(_Index)
	TimeControl.SetTime("AutoSmeltEquipTime",0)
	if UIEquip.IsAutoBuySemltEquip == true then
		UIEquip.AutoBuySemltIndex = _Index
		this:ShowBuyEquipItemInfo(UIEquip.AutoBuySemltIndex)
		if _Index>=#UIEquip.EquipSmeltDataList then
			TimeControl.LoginTime(1 , "AutoSmeltEquipTime")
			GameMain.AddUpdateLua(this.UpdateAutoSmelt)
		end
	else
		TimeControl.LoginTime(1 , "AutoSmeltEquipTime")
		GameMain.AddUpdateLua(this.UpdateAutoSmelt)
	end
	
end

function UIEquip.UpdateAutoSmelt()
	local time = TimeControl.GetTime("AutoSmeltEquipTime")
	if time<=0 then
		this:ToAutoSmeltEquip()
		GameMain.DelUpdateLua(this.UpdateAutoSmelt)
	end
end

function UIEquip:ShowSmeltPanelInfo()
	if UIEquip.SmeltControls.SemltItems ==nil then
		this:GetSmeltControls()
		for i=1,#UIEquip.EquipSmeltGodList,1  do
			local mask = UIEquip.EquipSmeltGodList[i]
			GameMain.CloseObj(mask)
		end
	end
	this:ShowSmeltBasicInfo()
	this:ShowSmeltEquipListInfo()
end

function UIEquip:ShowSmeltBasicInfo()
	local normalItem = ItemDataConfig.GetItemDBConfig(UIstring.NormalEquipSummonId)
	local betterItem = ItemDataConfig.GetItemDBConfig(UIstring.BetterEquipSummonId)
	local bestItem = ItemDataConfig.GetItemDBConfig(UIstring.BestEquipSummonId)
	AtlasMsg.SetAtlas(UIEquip.SmeltControls.NormalSmeltItemImg , normalItem.AtlasName , normalItem.SpriteName)
	AtlasMsg.SetAtlas(UIEquip.SmeltControls.BetterSmeltItemImg , betterItem.AtlasName , betterItem.SpriteName)
	AtlasMsg.SetAtlas(UIEquip.SmeltControls.BestSmeltItemImg , bestItem.AtlasName , bestItem.SpriteName)

	UIEquip.SmeltControls.NormalSmeltCount.text = tostring(ItemPackageSys.GetItemCountById(UIstring.NormalEquipSummonId))
	UIEquip.SmeltControls.BetterSmeltCount.text = tostring(ItemPackageSys.GetItemCountById(UIstring.BetterEquipSummonId))
	UIEquip.SmeltControls.BestSmeltCount.text = tostring(ItemPackageSys.GetItemCountById(UIstring.BestEquipSummonId))
	--_Type 1初级冶炼 2中级冶炼 3高级冶炼
	local isFreeOne = EquipSummonSys.IsFree(1)
	if isFreeOne == true then
		UIEquip.SmeltControls.NormalSmeltInfo.text = "免费冶炼一次"
	else
		GameMain.AddUpdateLua(this.UpdateTimeOne)
	end

	local isFreeTwo = EquipSummonSys.IsFree(2)
	if isFreeTwo == true then
		UIEquip.SmeltControls.BetterSmeltInfo.text = "免费冶炼一次"
	else
		GameMain.AddUpdateLua(this.UpdateTimeTwo)
	end
	if VipSys.VipLevel<2 then
		UIEquip.SmeltControls.BestSmeltInfo.text = "vip2开启"
		return
	end
	local isFreeThree = EquipSummonSys.IsFree(3)
	if isFree == true then
		UIEquip.SmeltControls.BestSmeltInfo.text = "免费冶炼一次"
	else
		GameMain.AddUpdateLua(this.UpdateTimeThree)
	end
end

function UIEquip:UpdateTimeOne()
	local time = TimeControl.GetTime("FreeEquipSummonTime1")
	if time==nil then
		UIEquip.SmeltControls.NormalSmeltInfo.text = "免费冶炼一次"
		GameMain.DelUpdateLua(this.UpdateTimeOne)
	else
		if time <=0 then
			UIEquip.SmeltControls.NormalSmeltInfo.text = "免费冶炼一次"
			GameMain.DelUpdateLua(this.UpdateTimeOne)
		else
			UIEquip.SmeltControls.NormalSmeltInfo.text = TimeControl.GetTimeString(time)
		end
	end
end

function UIEquip:UpdateTimeTwo()
	local time = TimeControl.GetTime("FreeEquipSummonTime2")
	if time==nil then
		UIEquip.SmeltControls.BetterSmeltInfo.text = "免费冶炼一次"
		GameMain.DelUpdateLua(this.UpdateTimeTwo)
	else
		if time <=0 then
			UIEquip.SmeltControls.BetterSmeltInfo.text = "免费冶炼一次"
			GameMain.DelUpdateLua(this.UpdateTimeTwo)
		else
			UIEquip.SmeltControls.BetterSmeltInfo.text = TimeControl.GetTimeString(time)
		end
	end
end

function UIEquip:UpdateTimeThree()
	local time = TimeControl.GetTime("FreeEquipSummonTime3")
	if time==nil then
		UIEquip.SmeltControls.BestSmeltInfo.text = "免费冶炼一次"
		GameMain.DelUpdateLua(this.UpdateTimeThree)
	else
		if time <=0 then
			UIEquip.SmeltControls.BestSmeltInfo.text = "免费冶炼一次"
			GameMain.DelUpdateLua(this.UpdateTimeThree)
		else
			UIEquip.SmeltControls.BestSmeltInfo.text = TimeControl.GetTimeString(time)
		end
	end
end

function UIEquip:ClearSmeltEquipGodList()								--每次刷新都需要清理一下
	UIEquip.EquipSmeltDataList = {}					
	for key,value in pairs(UIEquip.EquipSmeltGodList) do
		GameMain.CloseObj(value)
	end
end

function UIEquip:ShowSmeltEquipListInfo()
	local list = EquipSummonSys.GetTempEquipList()
	if #list == 0 then
		this:ClearSmeltEquipGodList()
		return
	end
	for i=1,#list,1  do
		UIEquip.EquipSmeltDataList[i] = list[i]
	end
	for i=1,5,1  do
		this:ShowSmeltEquipItemInfo(i , UIEquip.EquipSmeltDataList[i])
	end
end

function UIEquip:UpdateRoateTime()
	local time = TimeControl.GetTime("SmeltRotate")
	if time<=0 then
		for i=1,#UIEquip.EquipSmeltGodList,1  do
			local mask = UIEquip.EquipSmeltGodList[i].transform:FindChild("Mask")
			GameMain.CloseObj(mask)
		end
		GameMain.DelUpdateLua(this.UpdateRoateTime)
	end
end

function UIEquip:ShowSmeltEquipItemInfo(i,_EquipItem)			--isBuy 1 购买 0 没有购买
	GameMain.OpenObj(UIEquip.EquipSmeltGodList[i])
	
	local img = UIEquip.EquipSmeltGodList[i].transform:FindChild("IMG"):GetComponent("UISprite")
	local name = UIEquip.EquipSmeltGodList[i].transform:FindChild("Label"):GetComponent("UILabel")
	local price = UIEquip.EquipSmeltGodList[i].transform:FindChild("jinbi/Label"):GetComponent("UILabel")
	local btn = UIEquip.EquipSmeltGodList[i].transform:FindChild("Btn")
	local hasBuy = UIEquip.EquipSmeltGodList[i].transform:FindChild("HasBuy")
	local quility = UIEquip.EquipSmeltGodList[i].transform:FindChild("Quility"):GetComponent("UISprite")
	local BG = UIEquip.EquipSmeltGodList[i].transform:FindChild("BG"):GetComponent("UISprite")
	--BG
	if _EquipItem.IsBuy == false then
		GameMain.CloseObj(hasBuy)
		GameMain.OpenObj(btn)
	else
		GameMain.CloseObj(btn)
		GameMain.OpenObj(hasBuy)
	end
	AtlasMsg.SetAtlas(img, _EquipItem.AtlasName , _EquipItem.SpriteName)
	quility.spriteName = UIstring.ItemFg[_EquipItem.Quality]
	BG.spriteName = UIstring.ItemFg[_EquipItem.Quality]
	name.text = UIstring.WordColor[_EquipItem.Quality] .. tostring(_EquipItem.nickname) .. "[-]"
	local money = ClinetInfomation.GetCoin()
	if money<_EquipItem.BuyPrice then
		price.text = UIstring.Red .. tostring(_EquipItem.BuyPrice) .. "[-]"
	else
		price.text = tostring(_EquipItem.BuyPrice)
	end
end

function UIEquip:SmeltEquipType(_Type)									--_Type 1初级冶炼 2中级冶炼 3高级冶炼

	if _Type == 3 then
		if VipSys.VipLevel<2 then
			DataUIInstance.PopTip("Vip2开启")
			return 
		end
	end
	local free = EquipSummonSys.IsFree(_Type)
	if free == true then
		--免费
			EquipSummonSys.SummonCard(_Type , 1)
	else	
		local count = 0	
		if _Type == 1 then
			 count = ItemPackageSys.GetItemCountById(UIstring.NormalEquipSummonId)
				if count<1 then
					DataUIInstance.PopTip("道具不足")
					return
				end
		end
		if _Type == 2 then
			count= ItemPackageSys.GetItemCountById(UIstring.BetterEquipSummonId)
			
				if count<1 then
					local DBItemData = ShopSys.GetItemById(UIstring.BetterEquipSummonId , 1)
					local data = 
					{
						Buy_SellType = 1,
						Item = DBItemData,
					}
		
					DataUIInstance.PopTipPanel("Buy_SellItems" , UIEquip.BuyNormalCallBack , data)
					return 
				end
			
		end
		if _Type == 3 then
			count= ItemPackageSys.GetItemCountById(UIstring.BestEquipSummonId)

				if count<1 then
					local DBItemData = ShopSys.GetItemById(UIstring.BestEquipSummonId , 1)
					local data = 
					{
						Buy_SellType = 1,
						Item = DBItemData,
					}
		
					DataUIInstance.PopTipPanel("Buy_SellItems" , UIEquip.BuyNormalCallBack , data)
					return 
				end
			
		end
		EquipSummonSys.SummonCard(_Type , 0)
	end
	
	this:SmeltEquipPlayAni()
end

function UIEquip.BuyNormalCallBack(_Data)
	local _Item = _Data.Item
    ShopSys.BuyNormalItem(_Item.ShopId , _Data.Num)
end

function UIEquip:SmeltEquipPlayAni()				--翻转动画
	for i=1,#UIEquip.EquipSmeltGodList,1  do
		local mask = UIEquip.EquipSmeltGodList[i].transform:FindChild("Mask")
		GameMain.OpenObj(mask)
	end
	for i=1,#UIEquip.EquipSmeltGodList,1 do
		UIEquip.EquipSmeltGodList[i].transform:GetComponent("TweenRotation").enabled = true
		UIEquip.EquipSmeltGodList[i].transform:GetComponent("TweenRotation"):ResetToBeginning()
		UIEquip.EquipSmeltGodList[i].transform:GetComponent("TweenRotation"):Play()
	end

	local time = TimeControl.GetTime("SmeltRotate")
	if time == nil then
		time = TimeControl.LoginTime(0.3,"SmeltRotate")
	else
		TimeControl.SetTime("SmeltRotate", 0.3)
	end
	GameMain.AddUpdateLua(this.UpdateRoateTime)
end

function UIEquip:OpenAutoSmeltPanel(_Type)					
	UIEquip.SmeltType = _Type
	GameMain.OpenObj(UIEquip.SmeltControls.AutoPanel)
	UIEquip.IsAutoBuySemltEquip = false
	if UIEquip.AutoSmeltControls.Info == nil then
		this:GetAutoSmeltControls()
	end
	UIEquip.AutoSmeltControls.Info.text = ""
	this:ShowAutoBuySmeltInfo()
end

function UIEquip:GetAutoSmeltControls()
	UIEquip.AutoSmeltControls.Info = UIEquip.SmeltControls.AutoPanel.transform:FindChild("text/Info"):GetComponent("UILabel")
	UIEquip.AutoSmeltControls.AutoBuyBtn = UIEquip.SmeltControls.AutoPanel.transform:FindChild("autoBuyBtn")
	UIEquip.AutoSmeltControls.NoAutoBuyBtn = UIEquip.SmeltControls.AutoPanel.transform:FindChild("noAutoBuyBtn")
end

function UIEquip:ShowAutoBuySmeltInfo()
	if UIEquip.IsAutoBuySemltEquip == true then
		GameMain.CloseObj(UIEquip.AutoSmeltControls.AutoBuyBtn)
		GameMain.OpenObj(UIEquip.AutoSmeltControls.NoAutoBuyBtn)
	else
		GameMain.OpenObj(UIEquip.AutoSmeltControls.AutoBuyBtn)
		GameMain.CloseObj(UIEquip.AutoSmeltControls.NoAutoBuyBtn)
	end
end

function UIEquip:ToAutoSmeltEquip()
	UIEquip.IsAutoSmelt = true
	this:SmeltEquipType(UIEquip.SmeltType)
end

function UIEquip:ToStopAutoSmeltEquip()
	UIEquip.IsAutoSmelt = false
	GameMain.DelUpdateLua(this.UpdateAutoSmelt)
end

function UIEquip:ToAutoBuySemltEquip(_IsBuy)
	UIEquip.IsAutoBuySemltEquip = _IsBuy
	this:ShowAutoBuySmeltInfo()
end

function UIEquip.CloseAutoSmeltPanel()
	GameMain.CloseObj(UIEquip.SmeltControls.AutoPanel)
	this:ToStopAutoSmeltEquip()
	UIEquip.IsAutoBuySemltEquip = false
end

function UIEquip:ShowBuyEquipItemInfo(_Index)							--显示购买后的信息
	local clickData = UIEquip.EquipSmeltDataList[_Index]
	if clickData ~=nil then
		local money = ClinetInfomation.GetCoin()
		if money<clickData.BuyPrice then
			local noMoney = "金钱不足"
			DataUIInstance.PopTip(noMoney)
			if UIEquip.IsAutoSmelt == true and UIEquip.IsAutoBuySemltEquip == true then
				UIEquip.AutoSmeltControls.Info.text = UIEquip.AutoSmeltControls.Info.text .. "\n" .. UIstring.Red .. noMoney .. "[-]"
			end
			DataUIInstance.OpenCollect()
			return
		end
		if UIEquip.IsAutoSmelt == true then
			if UIEquip.IsAutoBuySemltEquip == true then
				if clickData.Quality>=5 then
					clickData:BuyInfo(1)
					this:ShowSmeltEquipItemInfo(_Index , clickData)
					EquipSummonSys.BuyEquip(clickData)
					return
				end
			end
			UIEquip.AutoBuySemltIndex = UIEquip.AutoBuySemltIndex +1
			this:SmeltAfterToBuyAuto(UIEquip.AutoBuySemltIndex)
		else
			clickData:BuyInfo(1)
			this:ShowSmeltEquipItemInfo(_Index , clickData)
			EquipSummonSys.BuyEquip(clickData)
		end
		
	end
end

function UIEquip:ShowBuyCallBack()
	for i=1,5,1  do
		this:ShowPriceItem(i , UIEquip.EquipSmeltDataList[i])
	end
	if UIEquip.IsAutoSmelt == true then
		local str = "成功购买" .. UIstring.WordColor[UIEquip.EquipSmeltDataList[UIEquip.AutoBuySemltIndex].Quality] .. UIEquip.EquipSmeltDataList[UIEquip.AutoBuySemltIndex].nickname .. "[-]"
		local strs = UIEquip.AutoSmeltControls.Info.text
		UIEquip.AutoSmeltControls.Info.text = strs .. "\n" .. str
		if UIEquip.IsAutoBuySemltEquip == true then
			UIEquip.AutoBuySemltIndex = UIEquip.AutoBuySemltIndex +1
			this:SmeltAfterToBuyAuto(UIEquip.AutoBuySemltIndex)
		end
	end
end

function UIEquip:ShowPriceItem(i ,_EquipItem)
	GameMain.OpenObj(UIEquip.EquipSmeltGodList[i])
	local price = UIEquip.EquipSmeltGodList[i].transform:FindChild("jinbi/Label"):GetComponent("UILabel")
	
	local money = ClinetInfomation.GetCoin()
	if money<_EquipItem.BuyPrice then
		price.text = UIstring.Red .. tostring(_EquipItem.BuyPrice) .. "[-]"
	else
		price.text = tostring(_EquipItem.BuyPrice)
	end
end
--endregion

--region *.操作装备的公共信息
function UIEquip:GetHandleCommonControls()
	UIEquip.HandleCommonControls.HeroUIWrap = UIEquip.HandleEquipPanel.transform:FindChild("Left/Heros"):GetComponent("UIWrap")
	UIEquip.HandleCommonControls.HeroPanel = UIEquip.HandleCommonControls.HeroUIWrap.transform:FindChild("HeroesPanel"):GetComponent("UIPanel")
	UIEquip.HandleCommonControls.HeroGrid = UIEquip.HandleCommonControls.HeroPanel.transform:FindChild("HeroGrid"):GetComponent("UIGrid")

	UIEquip.HeroDressEquips[2] = UIEquip.HandleEquipPanel.transform:FindChild("HeroInfo/2")
	UIEquip.HeroDressEquips[7] = UIEquip.HandleEquipPanel.transform:FindChild("HeroInfo/7")
	UIEquip.HeroDressEquips[4] = UIEquip.HandleEquipPanel.transform:FindChild("HeroInfo/4")
	UIEquip.HeroDressEquips[8] = UIEquip.HandleEquipPanel.transform:FindChild("HeroInfo/8")
	UIEquip.HeroDressEquips[5] = UIEquip.HandleEquipPanel.transform:FindChild("HeroInfo/5")
	UIEquip.HeroDressEquips[6] = UIEquip.HandleEquipPanel.transform:FindChild("HeroInfo/6")
	UIEquip.HeroDressEquips[3] = UIEquip.HandleEquipPanel.transform:FindChild("HeroInfo/3")
	UIEquip.HeroDressEquips[1] = UIEquip.HandleEquipPanel.transform:FindChild("HeroInfo/1")
	UIEquip.HandleCommonControls.HeroModel = UIEquip.HandleEquipPanel.transform:FindChild("HeroInfo/Model")
end

function UIEquip:ShowHandleCommonInfo()
	if UIEquip.HandleCommonControls.HeroUIWrap == nil then
		this:GetHandleCommonControls()
	end
	this:ShowHeroList()
	if UIEquip.ClickEquipIndex ~=0 then
		local choose = UIEquip.HeroDressEquips[UIEquip.ClickEquipIndex]:FindChild("Choose")
		GameMain.CloseObj(choose)
	end
end

function UIEquip:SetHeroData()
	local list = HeroPackageSys.GetHero()
	for i=1,#list,1 do
		UIEquip.HeroDataList[i] = list[i]
	end
end
function UIEquip:ShowHeroList()
	UIEquip.HandleCommonControls.HeroPanel.transform.localPosition = Vector3(0 , 0 , 0)
	UIEquip.HandleCommonControls.HeroPanel.clipOffset = Vector2(0,0)
	UIEquip.HandleCommonControls.HeroUIWrap:ResetTrans(#UIEquip.HeroDataList)
	if #UIEquip.HeroGodList == 0 then
		for i=1,10,1 do
			local data = 
			{
				Index = i,
			}
			MainGameUI.CreateLittleItem(tostring(i) , "HeroItem" , UIEquip.HandleCommonControls.HeroGrid , data , this.CreateHeroListCallBack , "UIEquip") 
		end
	else
		for i=1,10,1  do
			local data = 
			{
				Index = i,
			}
			
			if UIEquip.HeroGodList[i] == nil then
				MainGameUI.CreateLittleItem(tostring(i) , "HeroItem" , UIEquip.HandleCommonControls.HeroGrid , data , this.CreateHeroListCallBack , "UIEquip") 

			else
				this:CreateHeroListCallBack(UIEquip.HeroGodList[i] , data)
			end
		end
	end
end

function UIEquip:CreateHeroListCallBack(_Gob , _Info)
	if _Info.Index==10   then
		UIEquip.HandleCommonControls.HeroGrid.enabled = true
		UIEquip.HandleCommonControls.HeroGrid:Reposition()
		UIEquip.HandleCommonControls.HeroUIWrap:SetData(#UIEquip.HeroDataList , "UIEquip")
		this:ShowHeroEquipInfo(1)
	end

	local id = _Info.Index
	UIEquip.HeroGodList[id]=_Gob
	
	local data = UIEquip.HeroDataList[id]
	if data ~=nil then
		GameMain.OpenObj(UIEquip.HeroGodList[id])
		this:ShowHeroItem(data,UIEquip.HeroGodList[id])
	else
		GameMain.CloseObj(UIEquip.HeroGodList[id])	
	end
end

function UIEquip:UpdateItem(_LuaName , _Item) 
		local parentName = _Item.transform.parent.name
		if parentName == "HeroGrid" then
			local id = tonumber(_Item.name)
			local data = UIEquip.HeroDataList[id]
	
			if UIEquip.HeroGodList[id] == nil then
				UIEquip.HeroGodList[id] = _Item
			end
		
			if data~=nil then
				GameMain.OpenObj(_Item)
				if id~=UIEquip.ClickHeroIndex then
					GameMain.CloseObj(UIEquip.HeroGodList[id].transform:FindChild("Choose"))
				else
					GameMain.OpenObj(UIEquip.HeroGodList[id].transform:FindChild("Choose"))
				end
				this:ShowHeroItem(data,_Item)
			else
				GameMain.CloseObj(_Item)
			end
		end
		if parentName == "MatsGrid" then
			local index = tonumber(_Item.name)
			this:ShowEquipMatItem(UIEquip.EquipRecastMatDataList[index] , _Item)
		end
end

function UIEquip:ShowHeroItem(data , _Gob)
	local lv=_Gob.transform:FindChild("Lvl"):GetComponent("UILabel")
	local name=_Gob.transform:FindChild("name")
	local zhan=_Gob.transform:FindChild("Zhan")
	local Shuai=_Gob.transform:FindChild("Shuai")
	local Train=_Gob.transform:FindChild("train")
	local img=_Gob.transform:FindChild("IMG"):GetComponent("UISprite")
	local Quality=_Gob.transform:FindChild("FG"):GetComponent("UISprite")
	local fg = _Gob.transform:FindChild("bg"):GetComponent("UISprite")
	
	GameMain.CloseObj(Train)
		lv.text="LV" .. tostring(data.lvl)
		if name ~= nil then
			name.transform:GetComponent("UILabel").text= UIstring.WordColor[data.quality] .. tostring(data.nickname) .."[-]"
		end
		GameMain.CloseObj(zhan.gameObject)
		for key,value in pairs(TeamSys.GetPveHeros()) do
			if value.UUID == data.UUID then
				GameMain.OpenObj(zhan.gameObject)		--后续优化
			end
		end
		if data.IsGuaShuai==true then
			GameMain.OpenObj(Shuai.gameObject)
		else
			GameMain.CloseObj(Shuai.gameObject)
		end
	AtlasMsg.SetAtlas(img , data.AtlasName ,data.SpriteName)
	Quality.spriteName = UIstring.ItemFg[data.quality]	
	fg.spriteName = UIstring.ItemFg[data.quality]	
end

function UIEquip:ShowHeroEquipInfo(_Index)									--点击了英雄后的显示
	if UIEquip.ClickHeroIndex ~= 0 then
		GameMain.CloseObj(UIEquip.HeroGodList[UIEquip.ClickHeroIndex].transform:FindChild("Choose"))
	end
	UIEquip.ClickHeroIndex =_Index
	GameMain.OpenObj(UIEquip.HeroGodList[UIEquip.ClickHeroIndex].transform:FindChild("Choose"))
		
	local data = UIEquip.HeroDataList[_Index]
	UIEquip.HandleCommonControls.HeroModel.localEulerAngles = Vector3(0,150,0)
	if UIEquip.TempModel ~=nil then
		if data.ModelName~=UIEquip.TempModel.name then
			GameObject.Destroy(UIEquip.TempModel)
			UIEquip.TempModel = nil
		end
	end

	Create3DModel.CreateThModel(data.ModelName , nil , 5 , UIEquip.HandleCommonControls.HeroModel,this.CreateModelCallBack ,true , nil)
	
	for i=1,8,1  do
		local img =UIEquip.HeroDressEquips[i].transform:FindChild("Icon"):GetComponent("UISprite")
		local quilty=img.transform:FindChild("Bg"):GetComponent("UISprite")
		local name = UIEquip.HeroDressEquips[i].transform:FindChild("Label")
		local bg = UIEquip.HeroDressEquips[i].transform:FindChild("bg")
		local lvl = UIEquip.HeroDressEquips[i].transform:FindChild("Lvl"):GetComponent("UILabel")
		if data.Equips[i] == nil then
			GameMain.OpenObj(name.gameObject)
			GameMain.CloseObj(img.gameObject)
			GameMain.CloseObj(quilty.gameObject)
			GameMain.OpenObj(bg)
			GameMain.CloseObj(lvl)
		else
			GameMain.CloseObj(bg)
			local equipData = EquipSys.FindEquipByUUID(data.Equips[i])
			GameMain.CloseObj(name.gameObject)
			GameMain.OpenObj(img.gameObject)
			GameMain.OpenObj(quilty.gameObject)
			GameMain.OpenObj(lvl)
			quilty.spriteName = UIstring.ItemFg[equipData.Quality]
			lvl.text = "Lv"..tostring(equipData.Lvl)
			local fg = img.transform:FindChild("FG"):GetComponent("UISprite")
			fg.spriteName = UIstring.ItemFg[equipData.Quality]
			AtlasMsg.SetAtlas(img , equipData.AtlasName , equipData.SpriteName)	
		end
	end
	local tagName = UIEquip.TagClick.gameObject.name
	if tagName == "StrongTag" then
		--强化
		this:ShowDefaultStrength()
	end
	if tagName == "RecastTag" then
		--重铸
		this:ShowDefaultRecast()
	end
	if tagName == "PurifyTag" then
		--洗炼
		this:ShowDefaultPurify()	
	end
end

function UIEquip.CreateModelCallBack(NeedModel , _Data)
	UIEquip.TempModel = NeedModel
	Create3DModel.CreateHorse(UIEquip.TempModel , UIEquip.Create3DHorseCallBack) 
end

function UIEquip.Create3DHorseCallBack(_Model , _Data)
   _Model.transform.parent = UIEquip.TempModel.transform
   _Model.transform.localPosition = Vector3(0 , -2 , 0)
end

function UIEquip:ShowClickEquipItemInfo(_Index)						--点击了英雄身上的装备后的相关显示
	if UIEquip.ClickEquipIndex ~= 0 then
		local choose = UIEquip.HeroDressEquips[UIEquip.ClickEquipIndex]:FindChild("Choose")
		GameMain.CloseObj(choose)
	end
	UIEquip.ClickEquipIndex  = _Index
	local DressChoose = UIEquip.HeroDressEquips[UIEquip.ClickEquipIndex]:FindChild("Choose")
	GameMain.OpenObj(DressChoose)
	local tagName = UIEquip.TagClick.gameObject.name
	local heroData = UIEquip.HeroDataList[UIEquip.ClickHeroIndex]
	local equipData = EquipSys.FindEquipByUUID(heroData.Equips[_Index])
	UIEquip.ClickEquipItem = equipData
	if tagName == "StrongTag" then --强化
		if heroData.Equips[_Index] == nil then
			this:ShowDefaultStrength()
		else
			GameMain.CloseObj(UIEquip.StrengthControls.NullInfo)
			GameMain.OpenObj(UIEquip.StrengthControls.Info)
			this:ShowStrengthEquipInfo(equipData)
		end
	end
	if tagName == "RecastTag" then--重铸
		if heroData.Equips[_Index] == nil then
			this:ShowDefaultRecast()
		else
			GameMain.OpenObj(UIEquip.RecastEquipPanel)
			this:ShowRecastInfo(equipData , false)
		end
	end
	if tagName == "PurifyTag" then--洗炼
		if heroData.Equips[_Index] == nil then
			this:ShowDefaultPurify()
		else
			this:ShowPurifyInfo(equipData)
		end
	end
end
--endregion

--region *.装备强化

function UIEquip:ShowDefaultStrength()
	if UIEquip.StrengthControls.BeforeAtkLabel ==nil then
		this:GetStrengthControls()
	end
	this:ShowStrengthRate()
	this:ShowUseStrengthInfo()
	this:ShowStrengthCD()
	GameMain.CloseObj(UIEquip.StrengthControls.Info)
	GameMain.OpenObj(UIEquip.StrengthControls.UseStrengthProp)
	GameMain.OpenObj(UIEquip.StrengthControls.NullInfo)
	GameMain.CloseObj(UIEquip.StrengthControls.EquipIcon)
--	UIEquip.StrengthControls.EquipIcon.spriteName = nil
--	UIEquip.StrengthControls.EquipQulity.spriteName = UIstring.ItemFg[0]
	UIEquip.StrengthControls.EquipLvl.text = ""
	UIEquip.StrengthControls.Cost.text = tostring(0)
	UIEquip.ClickEquipItem = nil
end

function UIEquip:GetStrengthControls()
	UIEquip.StrengthControls.HelpPanel = UIEquip.StrengthEquipPanel.transform:FindChild("HelpPanel")
	UIEquip.StrengthControls.NullInfo = UIEquip.StrengthEquipPanel.transform:FindChild("no")
	UIEquip.StrengthControls.Info = UIEquip.StrengthEquipPanel.transform:FindChild("info")
	UIEquip.StrengthControls.AtkInfo = UIEquip.StrengthControls.Info.transform:FindChild("Atk")
	UIEquip.StrengthControls.BeforeAtkLabel = UIEquip.StrengthControls.AtkInfo.transform:FindChild("BeforeLabel"):GetComponent("UILabel")
	UIEquip.StrengthControls.AfterAtkLabel = UIEquip.StrengthControls.AtkInfo.transform:FindChild("LaterLabel"):GetComponent("UILabel")

	UIEquip.StrengthControls.StrongthEff = UIEquip.StrengthEquipPanel.transform:FindChild("FX_zhuangbei_qianghua01")
	UIEquip.StrengthControls.HpInfo = UIEquip.StrengthControls.Info.transform:FindChild("Hp")
	UIEquip.StrengthControls.BeforeHpLabel = UIEquip.StrengthControls.HpInfo.transform:FindChild("BeforeLabel"):GetComponent("UILabel")
	UIEquip.StrengthControls.AfterHpLabel = UIEquip.StrengthControls.HpInfo.transform:FindChild("LaterLabel"):GetComponent("UILabel")
	
	UIEquip.StrengthControls.AtkSpeedInfo = UIEquip.StrengthControls.Info.transform:FindChild("AtkSpeed")
	UIEquip.StrengthControls.BeforeAtkSpeedLabel = UIEquip.StrengthControls.AtkSpeedInfo.transform:FindChild("BeforeLabel"):GetComponent("UILabel")
	UIEquip.StrengthControls.AfterAtkSpeedLabel = UIEquip.StrengthControls.AtkSpeedInfo.transform:FindChild("LaterLabel"):GetComponent("UILabel")
	UIEquip.StrengthControls.SucessRateLabel = UIEquip.StrengthEquipPanel.transform:FindChild("sucessRate/Label"):GetComponent("UILabel")
	
	local equipItem = UIEquip.StrengthEquipPanel.transform:FindChild("EquipItem")
	UIEquip.StrengthControls.EquipIcon = equipItem.transform:FindChild("Icon"):GetComponent("UISprite")
	UIEquip.StrengthControls.EquipQulity = UIEquip.StrengthControls.EquipIcon.transform:FindChild("Bg"):GetComponent("UISprite")
	UIEquip.StrengthControls.EquipFg = UIEquip.StrengthControls.EquipIcon.transform:FindChild("FG"):GetComponent("UISprite")
	UIEquip.StrengthControls.EquipLvl = equipItem.transform:FindChild("Label"):GetComponent("UILabel")
	UIEquip.StrengthControls.Cost = UIEquip.StrengthEquipPanel.transform:FindChild("jinbi/Label"):GetComponent("UILabel")

	UIEquip.StrengthControls.UseStrengthProp = UIEquip.StrengthEquipPanel.transform:FindChild("UseStrengthItem")
	UIEquip.StrengthControls.NoUseProp = UIEquip.StrengthControls.UseStrengthProp.transform:FindChild("nouse")
	UIEquip.StrengthControls.UseProp = UIEquip.StrengthControls.UseStrengthProp.transform:FindChild("hasuse")
	UIEquip.StrengthControls.CD = UIEquip.StrengthEquipPanel.transform:FindChild("AccelerateBtn/CD"):GetComponent("UILabel")

	UIEquip.StrengthControls.AutoStrengthPanel = UIEquip.StrengthEquipPanel.transform:FindChild("AutoStrogthPanel")
end

--显示装备强化的CD
function UIEquip:ShowStrengthCD()
	EquipSys.SetStrengthCD()
	local time = TimeControl.GetTime("StrengthEquipCD")
	if time == nil then
		this:CloseStrengthCDBtn()
		return
	end
	GameMain.AddUpdateLua(this.UpdateStrengthCD)
end

function UIEquip:CloseStrengthCDBtn()
	GameMain.CloseObj(UIEquip.StrengthControls.CD.transform.parent)
	GameMain.DelUpdateLua(this.UpdateStrengthCD)
end

function UIEquip:UpdateStrengthCD()
	local time = TimeControl.GetTime("StrengthEquipCD")
	if time ==0 then
		this:CloseStrengthCDBtn()
	else
		GameMain.OpenObj(UIEquip.StrengthControls.CD.transform.parent)
		local str =  TimeControl.GetTimeString(time)
		if time>=600 then
			UIEquip.StrengthControls.CD.text = UIstring.Red .. "冷却时间：" .. str .. "[-]"
		else
			UIEquip.StrengthControls.CD.text = UIstring.NormalWordColor .. "冷却时间：" .. str .. "[-]"
		end
	end
end

--显示装备强化率
function UIEquip:ShowStrengthRate()				
	UIEquip.StrengthControls.SucessRateLabel.text = tostring(EquipSys.StrengthRate) .. "%"
	local curtime = ClinetInfomation.WorldTime
	if curtime<EquipSys.StrengthRateOverTime then
		TimeControl.LoginTime(EquipSys.StrengthRateOverTime-curtime, "EquipStrengthRateCDTime")
		GameMain.AddUpdateLua(this.UpdateRateTime)
	end
end

function UIEquip:UpdateRateTime()
	local time = TimeControl.GetTime("EquipStrengthRateCDTime")
	if time<=0 then
		EquipSys.GetStrengthRate()
		GameMain.DelUpdateLua(this.UpdateRateTime)
	end
end

function UIEquip:ShowStrongPanelInfo()
	if UIEquip.StrengthControls.BeforeAtkLabel ==nil then
		this:GetStrengthControls()
	end
	GameMain.CloseObj(UIEquip.RecastEquipPanel)
	GameMain.CloseObj(UIEquip.PurifyEquipPanel)
	GameMain.OpenObj(UIEquip.StrengthEquipPanel)
	GameMain.CloseObj(UIEquip.StrengthControls.StrongthEff)

	this:ShowDefaultStrength()	--初始化强化装备显示
end

function UIEquip:ShowStrengthEquipInfo(_Data)
	UIEquip.ClickEquipItem = _Data
	GameMain.OpenObj(UIEquip.StrengthControls.EquipIcon)
	AtlasMsg.SetAtlas(UIEquip.StrengthControls.EquipIcon , _Data.AtlasName , _Data.SpriteName)
	UIEquip.StrengthControls.EquipQulity.spriteName = UIstring.ItemFg[_Data.Quality]
	UIEquip.StrengthControls.EquipFg.spriteName = UIstring.ItemFg[_Data.Quality]
	UIEquip.StrengthControls.EquipLvl.text = "Lv" .. tostring(_Data.Lvl)
	local equipGod = UIEquip.HeroDressEquips[UIEquip.ClickEquipIndex]
	if equipGod ~= nil then
		equipGod.transform:FindChild("Lvl"):GetComponent("UILabel").text = "Lv" .. tostring(_Data.Lvl)
	end
	
	local atk = _Data:GetAtk()
	if atk<=0 then
		GameMain.CloseObj(UIEquip.StrengthControls.AtkInfo)
	else
		GameMain.OpenObj(UIEquip.StrengthControls.AtkInfo)
		UIEquip.StrengthControls.BeforeAtkLabel.text = tostring(atk)
		UIEquip.StrengthControls.AfterAtkLabel.text = tostring(_Data:GetAtkNextLvl())
	end
	local hp = _Data:GetHp()
	if hp<=0 then
		GameMain.CloseObj(UIEquip.StrengthControls.HpInfo)
	else
		GameMain.OpenObj(UIEquip.StrengthControls.HpInfo)
		UIEquip.StrengthControls.BeforeHpLabel.text = tostring(hp)
		UIEquip.StrengthControls.AfterHpLabel.text = tostring(_Data:GetHpNextLvl())
	end
	local atkSpeed = _Data:GetAtkSpeed()
	if atkSpeed<=0 then
		GameMain.CloseObj(UIEquip.StrengthControls.AtkSpeedInfo)
	else
		GameMain.OpenObj(UIEquip.StrengthControls.AtkSpeedInfo)
		UIEquip.StrengthControls.BeforeAtkSpeedLabel.text = tostring(atkSpeed)
		
		UIEquip.StrengthControls.AfterAtkSpeedLabel.text = tostring(_Data:GetAtkSpeedNextLvl())
	end
	local equipLvlCost = EquipLvlUpConfig.GetEquipUpLvlCost(_Data.Lvl , _Data.EquipType)
	if equipLvlCost~=nil then
		UIEquip.StrengthControls.Cost.text = tostring(equipLvlCost)
	end
	GameMain.OpenObj(UIEquip.StrengthControls.UseStrengthProp)
end

function UIEquip:ShowUseStrengthInfo()		--显示使用强化道具信息
	if UIEquip.UseStrengthProp == true then
		GameMain.CloseObj(UIEquip.StrengthControls.NoUseProp)
		GameMain.OpenObj(UIEquip.StrengthControls.UseProp)
	else
		GameMain.OpenObj(UIEquip.StrengthControls.NoUseProp)
		GameMain.CloseObj(UIEquip.StrengthControls.UseProp)
	end
end

function UIEquip:SendWebToStrengthEquip(IsSpeed)
	if UIEquip.ClickEquipItem == nil then
		DataUIInstance.PopTip("请选择装备")
		return
	end
	if UIEquip.ClickEquipItem.Lvl>=ClinetInfomation.Lvl then
		DataUIInstance.PopTip("不能超过角色等级")
		return
	end
	local costPrice = EquipLvlUpConfig.GetEquipUpLvlCost(UIEquip.ClickEquipItem.Lvl , UIEquip.ClickEquipItem.EquipType)
	if costPrice > ClinetInfomation.GetCoin() then
		DataUIInstance.PopTip("铜钱不足")
		return
	end
	if IsSpeed == 1 then
		local itemCount = ItemPackageSys.GetItemCountById(UIstring.CollectSpeedId)
		if itemCount<=0 then
			DataUIInstance.PopTip("道具不足")
			return
		end
	else	
		local canStrength = EquipSys.IsCanStrength()
		if canStrength == false then
			DataUIInstance.PopTip("冷却时间超过10分钟不可以强化")
			return
		end
	end
	if UIEquip.UseStrengthProp == true then
		local count = ItemPackageSys.GetItemCountById(UIstring.StrengthId)
		if count<0 then
			DataUIInstance.PopTip("强化符不足")
			return
		end
		UIEquip.ClickEquipItem:Strength(IsSpeed ,1)	--是否花钱买CD，是否使用强化符		1是 0否
	else
		UIEquip.ClickEquipItem:Strength(IsSpeed ,0)	--是否花钱买CD，是否使用强化符
	end
	if UIEquip.IsAutoStrong == false then
		GameMain.CloseObj(UIEquip.StrengthControls.StrongthEff)
		GameMain.OpenObj(UIEquip.StrengthControls.StrongthEff)
	end
end

function UIEquip:ClearStrengthCD()
	local itemCount = ItemPackageSys.GetItemCountById(UIstring.CollectSpeedId)
	if itemCount<=0 then
		DataUIInstance.PopTip("道具不足")
		return
	end
	EquipSys.ClearEquipStrengthCD()
end

function UIEquip:ClearStrengthCDCallBack()
	DataUIInstance.PopTip("冷却时间清除成功")
	this:ShowStrengthCD()
end

function UIEquip:ShowStrengthAfterInfo(IsSuccess)
	local price = EquipLvlUpConfig.GetEquipUpLvlCost(UIEquip.ClickEquipItem.Lvl , UIEquip.ClickEquipItem.EquipType)
	if IsSuccess == 1 then--成功了
		if UIEquip.IsAutoStrong == true then
			this:ShowAutoStrengthInfo(1 , price)
		else
			DataUIInstance.PopTip("装备强化成功")
			MusicManagerSys.StrengthSuccess()
		end
		UIEquip.ClickEquipItem.Lvl = UIEquip.ClickEquipItem.Lvl +1
		this:ShowStrengthEquipInfo(UIEquip.ClickEquipItem)
	else
		if UIEquip.IsAutoStrong == true then
			this:ShowAutoStrengthInfo(0 , price)
		else
			DataUIInstance.PopTip("装备强化失败")
			MusicManagerSys.StrengthFail()
		end
	end
	if UIEquip.IsAutoStrong == true then
		TimeControl.LoginTime(1, "AutoStrengthEquip")
		GameMain.AddUpdateLua(this.UpdateAutoStregth)
	end
	this:ShowStrengthCD()
end

function UIEquip:ShowAutoStrengthInfo(_IsSuccess , _CostPrice)
	local str = ""
	if _IsSuccess == 1 then
		str = "强化成功,消耗铜币".._CostPrice
	else
		str = "强化失败,消耗铜币".._CostPrice
	end
	local strs = UIEquip.AutoStrengthControls.Info.text
	if strs == "" then
		strs = str
	else
		strs = strs .. "\n" .. str
	end
	UIEquip.AutoStrengthControls.Info.text = strs
end


function UIEquip.UpdateAutoStregth()
	local time = TimeControl.GetTime("AutoStrengthEquip")
	if time <=0 then
		this:StartAutoStrength()
		GameMain.DelUpdateLua(this.UpdateAutoStregth)
	end
end
function UIEquip:OpenAutoStrengthPanel()
	GameMain.OpenObj(UIEquip.StrengthControls.AutoStrengthPanel)
	if UIEquip.AutoStrengthControls.Info == nil then
		this:GetAutoStrengthControls()
	end
	this:NoUseAutoSpeedItem()
	this:ShowAutoStrengthItemInfo()
	UIEquip.AutoStrengthControls.Info.text = ""
end

function UIEquip:GetAutoStrengthControls()
	UIEquip.AutoStrengthControls.Info = UIEquip.StrengthControls.AutoStrengthPanel.transform:FindChild("text/Info"):GetComponent("UILabel")
	UIEquip.AutoStrengthControls.ChooseSpeedBtn = UIEquip.StrengthControls.AutoStrengthPanel.transform:FindChild("chooseUseSpeed")
	UIEquip.AutoStrengthControls.noUseSpeedBtn = UIEquip.StrengthControls.AutoStrengthPanel.transform:FindChild("noChooseSpeed")
	UIEquip.AutoStrengthControls.ChooseStrengthBtn = UIEquip.StrengthControls.AutoStrengthPanel.transform:FindChild("chooseUseStrength")
	UIEquip.AutoStrengthControls.noUseStrengthBtn = UIEquip.StrengthControls.AutoStrengthPanel.transform:FindChild("noUseStrength")
end

function UIEquip:CloseAutoStrengthPanel()
	GameMain.CloseObj(UIEquip.StrengthControls.AutoStrengthPanel)
	UIEquip.IsAutoStrong = false
	UIEquip.IsAutoSpeed = false
	GameMain.DelUpdateLua(this.UpdateAutoStregth)
end

function UIEquip:StartAutoStrength()
--	UIEquip.IsAutoStrong = true
	local canStrength = EquipSys.IsCanStrength()
	if canStrength == false then
		if UIEquip.IsAutoSpeed == true then
			this:SendWebToStrengthEquip(1)
		else
			DataUIInstance.PopTip("冷却时间超过10分钟不可以强化")
		end
	else
		this:SendWebToStrengthEquip(0)
	end
end

function UIEquip:StopAutoStrength()
	UIEquip.IsAutoStrong = false
end

function UIEquip:ShowAutoStrengthItemInfo()
	if UIEquip.UseStrengthProp == true then
		GameMain.CloseObj(UIEquip.AutoStrengthControls.ChooseStrengthBtn)
		GameMain.OpenObj(UIEquip.AutoStrengthControls.noUseStrengthBtn)
	else
		GameMain.OpenObj(UIEquip.AutoStrengthControls.ChooseStrengthBtn)
		GameMain.CloseObj(UIEquip.AutoStrengthControls.noUseStrengthBtn)
	end 
	this:ShowUseStrengthInfo()
end

function UIEquip:UseAutoSpeedItem()
	GameMain.CloseObj(UIEquip.AutoStrengthControls.ChooseSpeedBtn)
	GameMain.OpenObj(UIEquip.AutoStrengthControls.noUseSpeedBtn)
	UIEquip.IsAutoSpeed = true
end

function UIEquip:NoUseAutoSpeedItem()
	GameMain.OpenObj(UIEquip.AutoStrengthControls.ChooseSpeedBtn)
	GameMain.CloseObj(UIEquip.AutoStrengthControls.noUseSpeedBtn)
	UIEquip.IsAutoSpeed = false
end
--endregion

--region *.装备洗炼
function UIEquip:GetPurifyControls()
	UIEquip.PurifyControls.HelpPanel = UIEquip.PurifyEquipPanel.transform:FindChild("HelpPanel")
	local equip = UIEquip.PurifyEquipPanel.transform:FindChild("EquipItem")
	UIEquip.PurifyControls.EquipSprite = equip.transform:FindChild("Icon"):GetComponent("UISprite")
	UIEquip.PurifyControls.EquipSpriteBg = equip.transform:FindChild("FG"):GetComponent("UISprite")
	UIEquip.PurifyControls.EquipName = equip.transform:FindChild("Name"):GetComponent("UILabel")
	UIEquip.PurifyControls.QuiltySprite = equip.transform:FindChild("BG"):GetComponent("UISprite")
	UIEquip.PurifyControls.PurifyEff = UIEquip.PurifyEquipPanel.transform:FindChild("FX_zhuangbei_xilian01")
	local item = UIEquip.PurifyEquipPanel.transform:FindChild("Item")
	UIEquip.PurifyControls.ItemSprite = item.transform:FindChild("Icon"):GetComponent("UISprite")
	UIEquip.PurifyControls.ItemSpriteBg = item.transform:FindChild("FG"):GetComponent("UISprite")
	UIEquip.PurifyControls.ItemQuiltySprite = item.transform:FindChild("BG"):GetComponent("UISprite")
	UIEquip.PurifyControls.ItemCount = item.transform:FindChild("Count"):GetComponent("UILabel")
	UIEquip.PurifyControls.ItemName = item.transform:FindChild("Name"):GetComponent("UILabel")
	UIEquip.PurifyControls.WinInfo = UIEquip.PurifyEquipPanel.transform:FindChild("Win/Label"):GetComponent("UILabel")
	
	local addAttr = UIEquip.PurifyEquipPanel.transform:FindChild("AddAttr")
	UIEquip.PurifyControls.AtkLabel = addAttr.transform:FindChild("Atk/Label"):GetComponent("UILabel")
	UIEquip.PurifyControls.HpLabel = addAttr.transform:FindChild("Hp/Label"):GetComponent("UILabel")
	UIEquip.PurifyControls.AtkSpeedLabel = addAttr.transform:FindChild("AtkSpeed/Label"):GetComponent("UILabel")
	
	UIEquip.PurifyControls.AutoPurifyBtn =  UIEquip.PurifyEquipPanel.transform:FindChild("AutoPurifyBtn")
	UIEquip.PurifyControls.StopPurifyBtn =  UIEquip.PurifyEquipPanel.transform:FindChild("StopAutoPurifyBtn")
end

function UIEquip:ShowPurifyPanelInfo()
	if UIEquip.PurifyControls.EquipSprite ==nil then
		this:GetPurifyControls()
	end
	GameMain.CloseObj(UIEquip.RecastEquipPanel)
	GameMain.OpenObj(UIEquip.PurifyEquipPanel)
	GameMain.CloseObj(UIEquip.StrengthEquipPanel)
	GameMain.CloseObj(UIEquip.PurifyControls.PurifyEff)
	this:ShowDefaultPurify()
end

function UIEquip:ShowDefaultPurify()
	if UIEquip.PurifyControls.EquipSprite ==nil then
		this:GetPurifyControls()
	end
	UIEquip.ClickEquipItem = nil

	local itemDataConfig = ItemDataConfig.GetItemDBConfig(UIstring.PurifyEquipItemId)
	if itemDataConfig~=nil then
		UIEquip.PurifyControls.ItemName.text = tostring(itemDataConfig.Name)
		AtlasMsg.SetAtlas(UIEquip.PurifyControls.ItemSprite , itemDataConfig.AtlasName , itemDataConfig.SpriteName)
		UIEquip.PurifyControls.ItemQuiltySprite.spriteName = UIstring.ItemFg[itemDataConfig.Quality]
		UIEquip.PurifyControls.ItemSpriteBg.spriteName = UIstring.ItemFg[itemDataConfig.Quality]
	end
	this:ShowPurifyItemCount()
	UIEquip.PurifyControls.AtkLabel.text = tostring(0)
	UIEquip.PurifyControls.HpLabel.text = tostring(0)
	UIEquip.PurifyControls.AtkSpeedLabel.text = tostring(0)
	UIEquip.PurifyControls.WinInfo.text = "？"
	UIEquip.PurifyControls.EquipSprite.spriteName = nil
	UIEquip.PurifyControls.EquipName.text = ""
	UIEquip.PurifyControls.QuiltySprite.spriteName = UIstring.ItemFg[0]
	GameMain.CloseObj(UIEquip.PurifyControls.EquipSpriteBg)
end

function UIEquip:ShowPurifyItemCount()
	local itemCount = ItemPackageSys.GetItemCountById(UIstring.PurifyEquipItemId)
	if UIEquip.PurifyControls.ItemCount ~=nil then
		UIEquip.PurifyControls.ItemCount.text = tostring(itemCount)
	end
end

function UIEquip:ShowPurifyInfo(_EquipData)
	if _EquipData.IsRefine == 0 then
		DataUIInstance.PopTip(UIstring.EquipCanNotPurify)
		this:ShowDefaultPurify()
		return 
	end
	if _EquipData.Quality <5 then
		DataUIInstance.PopTip("紫色及以上品质才可进行洗练")
		this:ShowDefaultPurify()
		return
	end
	UIEquip.PurifyControls.EquipName.text = tostring(_EquipData.nickname)
	AtlasMsg.SetAtlas( UIEquip.PurifyControls.EquipSprite , _EquipData.AtlasName , _EquipData.SpriteName)
	UIEquip.PurifyControls.QuiltySprite.spriteName = UIstring.ItemFg[_EquipData.Quality]
	GameMain.OpenObj(UIEquip.PurifyControls.EquipSpriteBg)
	UIEquip.PurifyControls.EquipSpriteBg.spriteName = UIstring.ItemFg[_EquipData.Quality]
	this:ShowPurifyAddValue(_EquipData)
end

function UIEquip:SendWebToPurifyEquip()
	if UIEquip.ClickEquipItem == nil then
		DataUIInstance.PopTip("请选择装备")
		return
	end
	local count = ItemPackageSys.GetItemCountById(UIstring.PurifyEquipItemId)
	if count<1 then
		DataUIInstance.PopTip(UIstring.EquipItemNotEngouh)
		return 
	end
	if UIEquip.ClickEquipItem~=nil then
		EquipSys.EquipAddProp(UIEquip.ClickEquipItem)
	end
end

function UIEquip:ShowPurifyAfterInfo(_EquipData , num)
	if num>0 then
		DataUIInstance.PopTip(num .. "倍暴击")
	end
	local str =this:GetPurityPopStr(_EquipData)
	if str ~="" then
		DataUIInstance.PopTip(str)
	end
	this:ShowPurifyAddValue(_EquipData)
	if UIEquip.IsAutoPurify == true then
		GameMain.CloseObj(UIEquip.PurifyControls.PurifyEff)
		TimeControl.LoginTime(1,"AutoPurifyTime")
		GameMain.AddUpdateLua(this.UpdateAutoPurify)
	else
		GameMain.CloseObj(UIEquip.PurifyControls.PurifyEff)
		GameMain.OpenObj(UIEquip.PurifyControls.PurifyEff)
	end
end

function UIEquip:GetPurityPopStr(_Data)
	local str = ""
	if _Data.HpAdd~=0 then
		str ="生命+".._Data:GetPurifyHp()
	end
	if _Data.AttackAdd~=0 then
		str = str .." 攻击+".._Data:GetPurifyAtk()
	end
	if _Data.AttackSpeedAdd~=0 then
		str  = str .. " 攻速+".._Data:GetPurifyAtkSpeed()
	end
	return str
end

function UIEquip.UpdateAutoPurify()
	local time = TimeControl.GetTime("AutoPurifyTime")
	if time <= 0 then
		this:SendWebToPurifyEquip()
		GameMain.DelUpdateLua(this.UpdateAutoPurify)
	end
end

function UIEquip:ShowPurifyAddValue(_EquipData)
	local data = UIEquip.HeroDataList[UIEquip.ClickHeroIndex]
	UIEquip.PurifyControls.AtkLabel.text = this:GetAtkValueColor(_EquipData.AttackAdd)
	UIEquip.PurifyControls.AtkSpeedLabel.text = this:GetAtkSpeedValueColor( _EquipData.AttackSpeedAdd)
	UIEquip.PurifyControls.HpLabel.text = this:GetHpValueColor( _EquipData.HpAdd)
	local count = ItemPackageSys.GetItemCountById(UIstring.PurifyEquipItemId)
	UIEquip.PurifyControls.ItemCount.text = tostring(count)
end

--根据不同的洗炼值显示不同的颜色
function UIEquip:GetHpValueColor(Value)
	if Value>=0 and Value<=1000 then
		return UIstring.WordColor[1] .."+" .. Value .. "[-]"
	end
	if Value>=1001 and Value<=2000 then
		return UIstring.WordColor[2].."+" .. Value .. "[-]"
	end
	if Value>=2001 and Value<=3000 then
		return UIstring.WordColor[3].."+" .. Value .. "[-]"
	end
	if Value>=3001 and Value<=3500 then
		return UIstring.WordColor[5].."+" .. Value .. "[-]"
	end
	if Value>=3501 then
		return UIstring.WordColor[6].."+" .. Value .. "[-]"
	end
end

function UIEquip:GetAtkValueColor(Value)
	if Value>=0 and Value<=40 then
		return UIstring.WordColor[1].."+" .. Value .. "[-]"
	end
	if Value>=41 and Value<=80 then
		return UIstring.WordColor[2].."+" .. Value .. "[-]"
	end
	if Value>=81 and Value<=120 then
		return UIstring.WordColor[3].."+" .. Value .. "[-]"
	end
	if Value>=121 and Value<=160 then
		return UIstring.WordColor[5].."+" .. Value .. "[-]"
	end
	if Value>=161 then
		return UIstring.WordColor[6].."+" .. Value .. "[-]"
	end
end

function UIEquip:GetAtkSpeedValueColor(Value)
	if Value>=0 and Value<=2 then
		return UIstring.WordColor[1].."+" .. Value .. "[-]"
	end
	if Value>=3 and Value<=4 then
		return UIstring.WordColor[2].."+" .. Value .. "[-]"
	end
	if Value>=5 and Value<=6 then
		return UIstring.WordColor[3].."+" .. Value .. "[-]"
	end
	if Value>=7 and Value<=8 then
		return UIstring.WordColor[5].."+" .. Value .. "[-]"
	end
	if Value>=9 then
		return UIstring.WordColor[6].."+" .. Value .. "[-]"
	end
end

function UIEquip:StartAutoPurify()
	GameMain.OpenObj(UIEquip.PurifyControls.StopPurifyBtn)
	GameMain.CloseObj(UIEquip.PurifyControls.AutoPurifyBtn)
	UIEquip.IsAutoPurify = true
	this:SendWebToPurifyEquip()
end

function UIEquip:StopAutoPurify()
	if UIEquip.PurifyControls.StopPurifyBtn ~= nil then
		GameMain.CloseObj(UIEquip.PurifyControls.StopPurifyBtn)
		GameMain.OpenObj(UIEquip.PurifyControls.AutoPurifyBtn)
		UIEquip.IsAutoPurify = false
		GameMain.DelUpdateLua(this.UpdateAutoPurify)
	end
end
--endregion

--region *.装备重铸
function UIEquip:GetRecastControls()
	--FX_zhuangbei_chongzhu01
	UIEquip.RecastControls.RecastEff = UIEquip.RecastEquipPanel.transform:FindChild("FX_zhuangbei_chongzhu01")
	UIEquip.RecastControls.HelpPanel = UIEquip.RecastEquipPanel.transform:FindChild("HelpPanel")
	UIEquip.RecastControls.MatListGod = UIEquip.RecastEquipPanel.transform:FindChild("Contains")
	UIEquip.RecastControls.RecastExpense = UIEquip.RecastEquipPanel.transform:FindChild("jinbi/Label"):GetComponent("UILabel")
	UIEquip.RecastControls.RecastMats = UIEquip.RecastEquipPanel.transform:FindChild("ChooseMats"):GetComponent("UIWrap")
	UIEquip.RecastControls.RecastMatsPanel = UIEquip.RecastControls.RecastMats.transform:FindChild("EquipMatsPanel"):GetComponent("UIPanel")
	UIEquip.RecastControls.RecastMatsGrid = UIEquip.RecastControls.RecastMatsPanel.transform:FindChild("MatsGrid"):GetComponent("UIGrid")
	UIEquip.RecastControls.RecastUpGrade = UIEquip.RecastEquipPanel.transform:FindChild("Des/quility"):GetComponent("UILabel")
	UIEquip.RecastControls.RecastCost = UIEquip.RecastEquipPanel.transform:FindChild("jinbi/Label"):GetComponent("UILabel")
	for i=1,5,1 do
		UIEquip.EquipRecastAddItemList[i] = UIEquip.RecastControls.MatListGod.transform:FindChild(tostring(i))
	end
end

function UIEquip:ShowDefaultRecast()
	if UIEquip.RecastControls.MatListGod ==nil then
		this:GetRecastControls()
	end
	UIEquip.ClickEquipItem = nil
	UIEquip.RecastControls.RecastCost.text = tostring(0)
	UIEquip.RecastControls.RecastUpGrade.text = ""
	for i=1,5,1  do
		local bg = UIEquip.EquipRecastAddItemList[i].transform:FindChild("Frame"):GetComponent("UISprite")
		local add = UIEquip.EquipRecastAddItemList[i].transform:FindChild("AddIcon")
		local img = UIEquip.EquipRecastAddItemList[i].transform:FindChild("IMG"):GetComponent("UISprite")
		local FG = UIEquip.EquipRecastAddItemList[i].transform:FindChild("FG")
		GameMain.CloseObj(FG)
		GameMain.OpenObj(add)
		bg.spriteName = UIstring.ItemFg[0]
		img.spriteName = nil
	end
end

function UIEquip:ShowRecastPanelInfo()		
	if UIEquip.RecastControls.MatListGod ==nil then
		this:GetRecastControls()
	end
	GameMain.OpenObj(UIEquip.RecastEquipPanel)
	GameMain.CloseObj(UIEquip.PurifyEquipPanel)
	GameMain.CloseObj(UIEquip.StrengthEquipPanel)
	GameMain.CloseObj(UIEquip.RecastControls.RecastEff)
	this:ShowDefaultRecast()
end

function UIEquip:ShowDressEquipInfo(_Data , _Index)				--显示穿在人身上的装备的信息
	local index = tonumber(_Index)
	local quilty=UIEquip.HeroDressEquips[index].transform:FindChild("Icon/Bg"):GetComponent("UISprite")
	local img =UIEquip.HeroDressEquips[index].transform:FindChild("Icon"):GetComponent("UISprite")
	local name = UIEquip.HeroDressEquips[index].transform:FindChild("Label")
	quilty.spriteName = UIstring.ItemFg[_Data.Quality]
	AtlasMsg.SetAtlas(img , _Data.AtlasName , _Data.SpriteName)
end

function UIEquip:ShowRecastInfo(_Data ,IsRecast)		--在重铸面板下显示点击的装备信息
	UIEquip.ClickEquipItem = _Data
	UIEquip.EquipRecastMatDataList = {}		--装备选择的材料list
	UIEquip.EquipRecastMatDataList=	EquipSys.GetBagEquipByType(UIEquip.ClickEquipItem.EquipType , UIEquip.ClickEquipItem.Quality , UIEquip.ClickEquipItem.QualityLvl , UIEquip.ClickEquipItem.UUID)
	UIEquip.EquipRecastAddDataList = {}
	UIEquip.ClickMatIndex = 0 
	if IsRecast == true then
		local heroData = UIEquip.HeroDataList[UIEquip.ClickHeroIndex]
		heroData.Equips[UIEquip.ClickEquipIndex] = _Data.UUID
		this:ShowDressEquipInfo(UIEquip.ClickEquipItem , UIEquip.ClickEquipIndex)
	end	
	if _Data.IsRecast == 0 then				--不可以重铸
		if IsRecast == false then
			DataUIInstance.PopTip(UIstring.EquipCanNotRecast)
			this:ShowDefaultRecast()
			return
		end
	end
	if _Data.Quality<5 then
		if _Data.IsRecast == false then
			DataUIInstance.PopTip(UIstring.EquipCanRecast)			--紫色品质以上才可以重铸
			this:ShowDefaultRecast()
			return
		end
	end
	if _Data.AdvancedId == 0 then
		if IsRecast == false then
			DataUIInstance.PopTip(UIstring.EquipHasUpGrade)			--已经重铸到最高
			this:ShowDefaultRecast()
			return
		end
	end
	local gradeData = EquipQualityUpConfig.GetEquipQualityByQuality(_Data.Quality , _Data.QualityLvl)
	UIEquip.RecastNeedNum = gradeData.UpNeed

	local upGradeData = EquipQualityUpConfig.GetEquipQualityById(gradeData.Up_To_Id)

	if upGradeData == nil then
		local nextData = EquipDataSys.GetEquipById(_Data.AdvancedId)
		UIEquip.RecastControls.RecastUpGrade.text = UIstring.WordColor[tonumber(nextData.Quality)] ..  UIstring.EquipUpGrade[tonumber(nextData.Quality)] .. "[-]"
	else
		if upGradeData.Quality_Lvl == 0 then
			UIEquip.RecastControls.RecastUpGrade.text =	UIstring.WordColor[tonumber(upGradeData.Quality)] .. UIstring.EquipUpGrade[tonumber(upGradeData.Quality)] .. "[-]"
		else
			UIEquip.RecastControls.RecastUpGrade.text = UIstring.WordColor[_Data.Quality] .. UIstring.EquipUpGrade[tonumber(upGradeData.Quality)] .. "+" .. tostring(upGradeData.Quality_Lvl) .. "[-]"
		end
		UIEquip.RecastControls.RecastCost.text = tostring(upGradeData.Cost)
		for i=1,5,1  do
			if i<=gradeData.UpNeed then
				GameMain.OpenObj(UIEquip.EquipRecastAddItemList[i])
				local bg = UIEquip.EquipRecastAddItemList[i].transform:FindChild("Frame"):GetComponent("UISprite")
				local add = UIEquip.EquipRecastAddItemList[i].transform:FindChild("AddIcon")
				local img = UIEquip.EquipRecastAddItemList[i].transform:FindChild("IMG"):GetComponent("UISprite")
				local FG = UIEquip.EquipRecastAddItemList[i].transform:FindChild("FG")
				GameMain.CloseObj(FG)
				GameMain.OpenObj(add)
				bg.spriteName = UIstring.ItemFg[0]
				img.spriteName = nil
			else
				GameMain.CloseObj(UIEquip.EquipRecastAddItemList[i])
			end
		end
	end
end

function UIEquip:RecastPutAllMats()
	local data =  UIEquip.ClickEquipItem 
	if data == nil then
		DataUIInstance.PopTip("请选择装备")
		return
	end
	if data~=nil then
		if data.IsRecast == 0 then				--不可以重铸
			DataUIInstance.PopTip(UIstring.EquipCanNotRecast)
			return
		end
		if data.Quality<5 then
			DataUIInstance.PopTip(UIstring.EquipCanRecast)			--紫色品质以上才可以重铸
			return
		end
		if data.AdvancedId == 0 then
			DataUIInstance.PopTip(UIstring.EquipHasUpGrade)			--已经重铸到最高
			return
		end
		if #UIEquip.EquipRecastMatDataList == 0 then
			DataUIInstance.PopTip(UIstring.EquipMatNotEnough)
			return
		end
		
		for i=1,UIEquip.RecastNeedNum,1  do
			UIEquip.ClickMatIndex=i
			this:ShowClickMatRecastInfo(1)
		end
	end
end

function UIEquip:SendWebToRecastEquip()				--装备重铸
	if UIEquip.ClickEquipItem == nil then
		DataUIInstance.PopTip("请选择装备")
		return
	end
	if UIEquip.ClickEquipItem.Quality<5 then
		return
	end
--	local upGrade = EquipQualityUpConfig.GetEquipQualityByQuality(UIEquip.ClickEquipItem.Quality , UIEquip.ClickEquipItem.QualityLvl)
	if #UIEquip.EquipRecastAddDataList == UIEquip.RecastNeedNum then
		--材料充足
		local ids = ""
		for key,value in pairs(UIEquip.EquipRecastAddDataList) do
			if ids == "" then
				ids = value.UUID
			else
				ids = ids .. "_" .. value.UUID
			end
		end
		UIEquip.ClickEquipItem:EquipReCast(ids)
		UIEquip.RecastNeedNum = 0
		local god = UIEquip.HeroDressEquips[UIEquip.ClickEquipIndex]
		if god ~= nil then
			UIEquip.RecastControls.RecastEff.transform.position = god.transform.position
			GameMain.CloseObj(UIEquip.RecastControls.RecastEff)
			GameMain.OpenObj(UIEquip.RecastControls.RecastEff)
		end
	else
		DataUIInstance.PopTip(UIstring.EquipMatNotEnough)
	end	
end

function UIEquip:ShowRecastEquipMatList(Index)		--显示选择材料的面板
	if UIEquip.ClickEquipItem == nil then
		DataUIInstance.PopTip("请选择装备")
		return
	end
	GameMain.CloseObj(UIEquip.HandleCommonControls.HeroModel)
	UIEquip.ClickMatIndex = Index
	GameMain.OpenObj(UIEquip.RecastControls.RecastMats)
	for i=1,25,1 do
		local data = 
		{
			Index = i,
		}
		if UIEquip.EquipRecastMatGodList[i] == nil then
			MainGameUI.CreateLittleItem(tostring(i) , "itemIcon" , UIEquip.RecastControls.RecastMatsGrid , data , this.CreateMatsCallBack , "UIEquip")
		else
			this:CreateMatsCallBack(UIEquip.EquipRecastMatGodList[i] , data)
		end
	end
end

function UIEquip:CreateMatsCallBack(_Gob , _Info)
	_Gob.transform.localScale = Vector3(0.6 , 0.6 , 1)
	local index = _Info.Index
	if _Info.Index == 25 then
		UIEquip.RecastControls.RecastMatsGrid.enabled = true
		UIEquip.RecastControls.RecastMatsGrid:Reposition()
		UIEquip.RecastControls.RecastMats:SetData(#UIEquip.EquipRecastMatDataList , "UIEquip")
	end
	UIEquip.EquipRecastMatGodList[index] = _Gob
	local data = UIEquip.EquipRecastMatDataList[index]
	this:ShowEquipMatItem(data , UIEquip.EquipRecastMatGodList[index])
end

function UIEquip:ShowEquipMatItem(_Data , _Gob)
	if _Data == nil then
		GameMain.CloseObj(_Gob)
		return
	end
	GameMain.OpenObj(_Gob)
	local img = _Gob.transform:FindChild("Img"):GetComponent("UISprite")
	local quility = _Gob.transform:FindChild("BG"):GetComponent("UISprite")
	local count = _Gob.transform:FindChild("count")
	local lv = _Gob.transform:FindChild("Lv"):GetComponent("UILabel")
	local bg = _Gob.transform:FindChild("FG"):GetComponent("UISprite")
	GameMain.CloseObj(count)
	lv.text = "Lv" .. tostring(_Data.Lvl)
	quility.spriteName = UIstring.ItemFg[_Data.Quality]
	bg.spriteName = UIstring.ItemFg[_Data.Quality]
	AtlasMsg.SetAtlas(img , _Data.AtlasName , _Data.SpriteName)
end

function UIEquip:ShowClickMatRecastInfo(_Index)		--点击了选择材料list中的材料后		
	GameMain.OpenObj(UIEquip.HandleCommonControls.HeroModel)
	local data = UIEquip.EquipRecastMatDataList[_Index]
	if data == nil then
		return
	end
	local equipData = UIEquip.EquipRecastAddDataList[UIEquip.ClickMatIndex]
	if UIEquip.ClickMatIndex~=0 then
		local god = UIEquip.EquipRecastAddItemList[UIEquip.ClickMatIndex]
		local bg = god.transform:FindChild("Frame"):GetComponent("UISprite")
		local add = god.transform:FindChild("AddIcon")
		local img = god.transform:FindChild("IMG"):GetComponent("UISprite")
		local FG = god.transform:FindChild("FG"):GetComponent("UISprite")
		GameMain.CloseObj(add)
		GameMain.OpenObj(FG)
		bg.spriteName = UIstring.ItemFg[data.Quality]
		FG.spriteName = UIstring.ItemFg[data.Quality]
		AtlasMsg.SetAtlas(img , data.AtlasName , data.SpriteName)
	end	
	UIEquip.EquipRecastAddDataList[UIEquip.ClickMatIndex] = data
	this:CloseMatsPanel()
	table.remove( UIEquip.EquipRecastMatDataList , _Index)
	if equipData~=nil then
		table.insert(UIEquip.EquipRecastMatDataList , #UIEquip.EquipRecastMatDataList+1 , equipData)
	end
end

function UIEquip:CloseMatsPanel()
	GameMain.OpenObj(UIEquip.HandleCommonControls.HeroModel)
	GameMain.CloseObj(UIEquip.RecastControls.RecastMats.gameObject)	--关闭选择matList 界面
end
--endregion

function UIEquip:UIOnPress(_LuaName , _Gob , _isPress)--按钮按下显示相应的信息
	if _isPress==false then  
		this:CloseTipsPanel()	
	end                                
	if _isPress==true then
		 local ItemKey = tonumber(_Gob.name)
		 local ItemParentName = _Gob.transform.parent.name
		 if ItemKey~=nil and ItemParentName=="HeroGrid" then
			 if UIEquip.HeroDataList[ItemKey]~=nil then                       --点击背包里面的道具
	              this:ShowHeroTipsPanel(UIEquip.HeroDataList[ItemKey],_Gob)             
				  return
			 end
		 end
	end
end

function UIEquip:ShowHeroTipsPanel(heroData , obj)--武将tips信息显示
	local pos = obj.transform.position
	local vec = Vector3(pos.x,pos.y,-460)
	DataUIInstance.CreateTipsPanel( heroData ,"Hero" , vec)
end

function UIEquip:CloseTipsPanel()
	local uiTar = MainGameUI.FindPanelTarget("TipsPanel")
	if uiTar~=nil then
		uiTar:ClosePanel()
	end
end

function UIEquip:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "SmeltTag" then
		this:ChangePanel(_Gob)
	end	
	if _Gob.name == "StrongTag" then
		this:ChangePanel(_Gob)
	end	
	if _Gob.name == "RecastTag" then
		this:ChangePanel(_Gob)
	end
	if _Gob.name == "PurifyTag" then
		this:ChangePanel(_Gob)
	end
	if _Gob.name == "CloseBtn" then
		GameMain.CloseObj(UIEquip.UIEquipGod)
		this:StopAutoPurify()
	end
	if _Gob.name == "NormalSmeltBtn" then
		this:SmeltEquipType(1)
	end
	if _Gob.name == "NormalAutoBtn" then
		--自动冶炼
		this:OpenAutoSmeltPanel(1)
	end
	if _Gob.name == "BetterAutoBtn" then
		this:OpenAutoSmeltPanel(2)
	end
	if _Gob.name == "BetterSmeltBtn" then
		this:SmeltEquipType(2)
	end
	if _Gob.name =="BestSmeltBtn" then
		this:SmeltEquipType(3)
	end
	if _Gob.name == "PurifyBtn" then
		this:StopAutoPurify()
		this:SendWebToPurifyEquip()			--洗炼
	end
	if _Gob.name == "StrengthBtn" then		--强化
		this:SendWebToStrengthEquip(0)
	end
	if _Gob.name == "AccelerateBtn" then
--		this:SendWebToStrengthEquip(1)		--加速强化
		this:ClearStrengthCD()
	end
	if _Gob.name == "RecastBtn" then		--重铸
		this:SendWebToRecastEquip()
	end
	if _Gob.name == "AllPutBtn" then
		this:RecastPutAllMats()
	end
	if _Gob.name == "Mask" then
		this:CloseMatsPanel()
	end
	if _Gob.name == "UseStrengthItem" then					--使用强化符
		if UIEquip.UseStrengthProp == false then
			UIEquip.UseStrengthProp = true
		else
			UIEquip.UseStrengthProp = false
		end
		this:ShowUseStrengthInfo()
	end
	local key = tonumber(_Gob.transform.parent.name)
	if key ~= nil then
		local parentName = _Gob.transform.parent.parent.name
		if parentName =="SmeltEquips" then
			this:ShowBuyEquipItemInfo(key)			--购买装备
		end
	end
	local selfKey = tonumber(_Gob.name)
	if selfKey ~= nil then
		local parentName = _Gob.transform.parent.name
		if parentName == "HeroGrid" then
			this:ShowHeroEquipInfo(selfKey)
		end
		if parentName == "HeroInfo" then
			this:ShowClickEquipItemInfo(selfKey)	--点击了英雄身上的装备后
		end
		if parentName == "MatsGrid" then
			this:ShowClickMatRecastInfo(selfKey)
		end
		if parentName == "Contains" then
			this:ShowRecastEquipMatList(selfKey)	--显示添加matlist列表
		end
	end
	if _Gob.name == "HelpBtn" then
		this:ShowHelpPanel()
	end
	if _Gob.name == "CloseHelpBtn" then
		this:CloseHelpPanel()
	end
	if _Gob.name == "AddItemBtn" then
		this:ToBuyPurifyItem()
	end
	if _Gob.name == "AutoPurifyBtn" then
		this:StartAutoPurify()
	end
	if _Gob.name == "StopAutoPurifyBtn" then
		this:StopAutoPurify()
	end
	if _Gob.name == "CloseAutoStrength" then
		this:CloseAutoStrengthPanel()
	end
	if _Gob.name == "AutoStrengthBtn" then
		this:OpenAutoStrengthPanel()
	end
	if _Gob.name == "StartAutoStrengthBtn" then
		UIEquip.IsAutoStrong = true
		this:StartAutoStrength()
	end
	if _Gob.name == "CloseAutoStrengthBtn" then
		this:StopAutoStrength()
	end
	if _Gob.name == "chooseUseStrength" then
		UIEquip.UseStrengthProp =true	
		this:ShowAutoStrengthItemInfo()
	end
	if _Gob.name == "noUseStrength" then
		UIEquip.UseStrengthProp = false
		this:ShowAutoStrengthItemInfo()
	end
	if _Gob.name == "chooseUseSpeed" then
		this:UseAutoSpeedItem()
	end
	if _Gob.name == "noChooseSpeed" then
		this:NoUseAutoSpeedItem()
	end

	if _Gob.name == "autoBuyBtn" then
		this:ToAutoBuySemltEquip(true)
	end
	if _Gob.name == "noAutoBuyBtn" then
		this:ToAutoBuySemltEquip(false)
	end
	if _Gob.name == "StartAutoSmeltBtn" then
		this:ToAutoSmeltEquip()
	end
	if _Gob.name == "CloseAutoSmeltBtn" then
		this:ToStopAutoSmeltEquip()
	end
	if _Gob.name == "CloseAutoSmeltPanel" then
		this:CloseAutoSmeltPanel()
	end
end

function UIEquip:ToBuyPurifyItem()					--购买洗炼石
	local DBItemData = ShopSys.GetItemById(UIstring.PurifyEquipItemId , 1)
	local data = 
	{
		Buy_SellType = 1,
		Item = DBItemData,
	}
	DataUIInstance.PopTipPanel("Buy_SellItems" , UIEquip.BuyCallBack , data) 
end

function UIEquip.BuyCallBack(_Data)
	local _Item = _Data.Item
    ShopSys.BuyNormalItem(_Item.ShopId , _Data.Num)
end

--帮助面板
function UIEquip:ShowHelpPanel()
	if UIEquip.TagClick ~=nil  then
		local tagName = UIEquip.TagClick.name
		if tagName == UIEquip.TagsName[1] then
			GameMain.OpenObj(UIEquip.SmeltControls.HelpPanel)
			if UIEquip.SmeltControls.HelpInfo == nil then
				UIEquip.SmeltControls.HelpInfo = UIEquip.SmeltControls.HelpPanel.transform:FindChild("Scroll View/Label"):GetComponent("UILabel")
			end
		local helpInfo = TipsConfig.GetDataById(101)
		UIEquip.SmeltControls.HelpInfo.text = helpInfo.Description
		end
	end	
end

function UIEquip:CloseHelpPanel()
	if UIEquip.TagClick ~=nil  then
		local tagName = UIEquip.TagClick.name
		if tagName == UIEquip.TagsName[1] then
			GameMain.CloseObj(UIEquip.SmeltControls.HelpPanel)
		end
	end	
end

function UIEquip:ReleasPanel()
	--UI相关
	UIEquip.UIEquipGod = nil

	UIEquip.SmeltEquipPanel = nil

	UIEquip.HandleEquipPanel = nil
	UIEquip.StrengthEquipPanel = nil
	UIEquip.PurifyEquipPanel = nil
	UIEquip.RecastEquipPanel = nil

	UIEquip.SmeltControls = {}	
	UIEquip.HandleCommonControls = {}

	UIEquip.TempModel = nil	--武将模型

	UIEquip.HeroDressEquips = 
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

	UIEquip.StrengthControls = {}
	UIEquip.RecastControls = {}
	UIEquip.PurifyControls = {}

	--UIEquip.CurShowPanel = nil
	UIEquip.TagClick = nil

	UIEquip.TagsName =
	{
		[1] = "SmeltTag",
		[2] = "StrongTag",
		[3] = "RecastTag",
		[4] = "PurifyTag",
	}

	UIEquip.EquipSmeltGodList = {}
	UIEquip.HeroGodList = {}
	UIEquip.EquipRecastMatGodList = {}				--装备重铸的材料
	UIEquip.EquipRecastAddItemList = {}			--显示选择的重铸list
	UIEquip.AutoStrengthControls = {}		--自动强化的控件
	UIEquip.AutoSmeltControls = {}				--自动冶炼的控件
	--Data 相关
	UIEquip.EquipSmeltDataList = {}				--冶炼刷新出来的装备
	UIEquip.SmeltType = 0						--冶炼的类型
	UIEquip.HeroDataList = {}					--武将列表
	UIEquip.ClickHeroIndex = 0					--点击的那个武将的index
	UIEquip.ClickEquipItem = nil				--点击的那个装备
	UIEquip.ClickEquipIndex = 0					--点击的装备的index
	UIEquip.EquipRecastMatDataList = {}			--装备选择的材料list
	UIEquip.EquipRecastAddDataList = {}			--显示重铸的材料list数据
	UIEquip.ClickMatIndex = 0					--点击的那个add材料

	UIEquip.PurifyItemCount = 0	--洗炼道具的数量

	UIEquip.RecastNeedNum = 0					--重铸的需要的材料数量
	UIEquip.UseStrengthProp = false				--是否使用强化符
	UIEquip.IsAutoPurify = false				--是否自动洗炼
	UIEquip.IsAutoStrong = false				--是否自动强化
	UIEquip.IsAutoSpeed = false					--是否自动使用加速符
	UIEquip.IsAutoSmelt = false					--是否自动冶炼
	UIEquip.IsAutoBuySemltEquip = false			--是否自动购买冶炼品质高的装备
	UIEquip.AutoBuySemltIndex = 0				--购买冶炼的index
	GameMain.DelUpdateLua(this.UpdateRoateTime)
	GameMain.DelUpdateLua(this.UpdateTimeOne)
	GameMain.DelUpdateLua(this.UpdateTimeTwo)
	GameMain.DelUpdateLua(this.UpdateTimeThree)
	GameMain.DelUpdateLua(this.UpdateRateTime)
	GameMain.DelUpdateLua(this.UpdateStrengthCD)
end

function UIEquip:ReleasData()
	EquipSys.EquipList = {}
	EquipSys.TempEquip = {}
	EquipSys.HeroEquipUUIDs = {}								--人物身上穿的装备
	EquipSys.HeroEquipList = {}	
	EquipSys.BagEquipList = {}									--背包的装备事件
	EquipSys.PurifyEquip = nil							--洗炼的装备

	EquipSys.StrengthRate = 0							--强化成功率
	EquipSys.StrengthRateOverTime = 0					--强化成功率的时间戳
	EquipSys.StrengthCD = 0								--强化CD时间戳点

	EquipSys.IsSort = true								--是否排序
end

return UIEquip
--endregion