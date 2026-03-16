--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
UICollect = {}
UICollect = BasePanel:new()
local this = UICollect
--UI相关
UICollect.UICollectGod = nil
UICollect.Controls = {}

--Data
UICollect.SpeedCount = 0
UICollect.FreeCount = 0	--免费的次数
UICollect.CostCount = 0	--付费的次数
UICollect.OwnPropCount = 0	--拥有的道具数量

function UICollect:OpenUI(_PanelName , _LuaName)
	if UICollect.UICollectGod == nil then
		UICollect.UICollectGod = MainGameUI.FindPanel("UICollect")
		this:GetControls()

		this:SetInitData()
	end
	this:ShowInitInfo()
end

function UICollect:GetControls()
	local freeInfo = UICollect.UICollectGod.transform:FindChild("FreeCollect")
	UICollect.Controls.FreeCount = freeInfo.transform:FindChild("count"):GetComponent("UILabel")
	UICollect.Controls.FreeTime = freeInfo.transform:FindChild("SpeedBtn/time"):GetComponent("UILabel")
	UICollect.Controls.FreeLimit = freeInfo.transform:FindChild("limit")
	UICollect.Controls.SpeedBtn = freeInfo.transform:FindChild("SpeedBtn")
--	UICollect.Controls.SpeedCountLabel = UICollect.Controls.SpeedBtn.transform:FindChild("SpeedItemCount"):GetComponent("UILabel")

	local costInfo = UICollect.UICollectGod.transform:FindChild("CostCollect")
	UICollect.Controls.CostCount = costInfo.transform:FindChild("count"):GetComponent("UILabel")
	UICollect.Controls.CostInfo = costInfo.transform:FindChild("info"):GetComponent("UILabel")
	UICollect.Controls.CostLimit = costInfo.transform:FindChild("limit")
	UICollect.Controls.CollectPrice = UICollect.UICollectGod.transform:FindChild("Des/GetPrice"):GetComponent("UILabel")
	UICollect.Controls.CostItemCount = costInfo.transform:FindChild("ItemIcon/count"):GetComponent("UILabel")
	UICollect.Controls.CostItemIcon = costInfo.transform:FindChild("ItemIcon"):GetComponent("UISprite")
end

function UICollect:SetInitData()
	UICollect.FreeCount = CollectSys.FreeCollectTimes
	UICollect.CostCount = CollectSys.CostCollectTimes
	
	UICollect.SpeedCount = ItemPackageSys.GetItemCountById(UIstring.CollectSpeedId)
	
	UICollect.OwnPropCount = ItemPackageSys.GetItemCountById(UIstring.CostCollectId)
	local item = ItemDataConfig.GetItemDBConfig(UIstring.CostCollectId)
	AtlasMsg.SetAtlas( UICollect.Controls.CostItemIcon , item.AtlasName , item.SpriteName)
end

function UICollect:ShowFreeCDTime()
	if UICollect.FreeCount >=10 then
		GameMain.CloseObj(UICollect.Controls.SpeedBtn)
		return
	end
	local time = TimeControl.GetTime("FreeCollectTime")
	if time == nil then
		UICollect.Controls.FreeTime.text = UIstring.NormalWordColor ..  TimeControl.GetTimeString(0) .."[-]"
		GameMain.CloseObj(UICollect.Controls.SpeedBtn)
		return
	end
	if time <= 0 then
		UICollect.Controls.FreeTime.text =  UIstring.NormalWordColor ..TimeControl.GetTimeString(0) .. "[-]"
		GameMain.CloseObj(UICollect.Controls.SpeedBtn)
		return
	end
	GameMain.OpenObj(UICollect.Controls.SpeedBtn)
	GameMain.AddUpdateLua(this.UpdateTime)
end

function UICollect:UpdateTime()
	local time = TimeControl.GetTime("FreeCollectTime")
	if time ~= nil then
		local str =  TimeControl.GetTimeString(time)
		if time > 10*60 then
			UICollect.Controls.FreeTime.text = UIstring.WordColor[8] .. str .. "[-]"
		else
			UICollect.Controls.FreeTime.text = UIstring.NormalWordColor .. str .. "[-]"
		end
		if time <= 0 then
			GameMain.CloseObj(UICollect.Controls.SpeedBtn)
			GameMain.DelUpdateLua(this.UpdateTime)
		end
	else
		GameMain.CloseObj(UICollect.Controls.SpeedBtn)
		GameMain.DelUpdateLua(this.UpdateTime)
	end
end

function UICollect:ShowInitInfo()
	
	if UICollect.FreeCount >=10 then
		GameMain.CloseObj(UICollect.Controls.FreeTime)
		GameMain.OpenObj(UICollect.Controls.FreeLimit)
--		GameMain.CloseObj(UICollect.Controls.SpeedCountLabel)
	else
		GameMain.OpenObj(UICollect.Controls.FreeTime)
		GameMain.CloseObj(UICollect.Controls.FreeLimit)
--		GameMain.OpenObj(UICollect.Controls.SpeedCountLabel)
	end

	if UICollect.CostCount >=50 then
		GameMain.CloseObj(UICollect.Controls.CostInfo)
		GameMain.OpenObj(UICollect.Controls.CostLimit)
	else
		GameMain.OpenObj(UICollect.Controls.CostInfo)
		GameMain.CloseObj(UICollect.Controls.CostLimit)
	end

	local costProp = CollectSys.CostCollectDelItem(UICollect.CostCount+1)

	local str = ""
	if UICollect.OwnPropCount>=costProp then
		str = UIstring.Green .. tostring(UICollect.OwnPropCount).."[-]"
	else
		str = UIstring.Red .. tostring(UICollect.OwnPropCount) .. "[-]"
	end
	UICollect.Controls.CostInfo.text = UIstring.CollectColor ..	UIstring.CollectOwn .. str .. UIstring.CollectCount  .. UIstring.CollectCost .."[-]".. UIstring.Green.. tostring(costProp).."[-]" .. UIstring.CollectColor.. UIstring.CollectCount .."[-]"
	
	UICollect.Controls.FreeCount.text = tostring(UICollect.FreeCount) .. "/10"
	UICollect.Controls.CostCount.text = tostring(UICollect.CostCount) .. "/50"
	UICollect.Controls.CostItemCount.text = tostring(costProp)
	UICollect.Controls.CollectPrice.text = tostring(CollectSys.FreeCollectMoney()) .. "铜钱"
	this:ShowFreeCDTime()
--	this:ShowSpeedItemInfo()
end


function UICollect:UIHand(_LuaName , _Gob)
	MusicManagerSys.ButtonClick()
	if _Gob.name == "CloseBtn" then
		GameMain.CloseObj(UICollect.UICollectGod)
	end

	if _Gob.name == "FreeCollectBtn" then
		this:SendShowFreeCollectInfo()
	end
	
	if  _Gob.name == "CostCollectBtn" then
		this:SendShowCostCollectInfo()
	end
	
	if _Gob.name == "SpeedBtn" then
		this:SpeedCollect()
	end
end


function UICollect:ShowSpeedItemInfo()
	
--	UICollect.Controls.SpeedCountLabel.text =  "（"..UIstring.CollectSpeedItem.."：".. tostring(UICollect.SpeedCount) .. ")"
end

function UICollect:SpeedCollect()
--	local time = TimeControl.GetTime("FreeCollectTime")
--	if time==nil then
--		DataUIInstance.PopTip(UIstring.CollectNoNeedSpeed)
--		return
--	end
--	if time<=0 then
--		DataUIInstance.PopTip(UIstring.CollectNoNeedSpeed)
--		return
--	end

	if UICollect.SpeedCount<=0 then
		DataUIInstance.PopTip(UIstring.CollectNoEngouh)
		return
	end
	
	CollectSys.Speed()
	UICollect.SpeedCount = UICollect.SpeedCount -1
--	this:ShowSpeedItemInfo()
	TimeControl.SetTime("FreeCollectTime" , 0)
	UICollect.Controls.FreeTime.text =  TimeControl.GetTimeString(0)
	GameMain.CloseObj(UICollect.Controls.SpeedBtn)
	GameMain.DelUpdateLua(this.UpdateTime)
	DataUIInstance.PopTip("清除冷却时间成功")
end

function UICollect:SendShowFreeCollectInfo()						--普通征收
	
	if CollectSys.FreeCollectTimes >=10 then
		return
	end
	if  CollectSys.IsCanFreeCollect() == false then
		return
	end
	CollectSys.Collect(1)
	UICollect.FreeCount = UICollect.FreeCount+1

	local money = CollectSys.FreeCollectMoney()
	this:ShowPropText(money)
	GameMain.OpenObj(UICollect.Controls.SpeedBtn)
	this:ShowInitInfo()
	
end

function UICollect:SendShowCostCollectInfo()						--强征收
	if UICollect.CostCount >=50 then
		return
	end
	local costCount = CollectSys.CostCollectDelItem(UICollect.CostCount +1)
	if UICollect.OwnPropCount ==0 then
		DataUIInstance.PopTip("道具不足")
		return
	end
	if UICollect.OwnPropCount<costCount then
		DataUIInstance.PopTip("道具不足")
		return
	end
	
	CollectSys.Collect(2)
		
	ItemPackageSys.RefrashItem(UIstring.CostCollectId , UICollect.OwnPropCount - costCount)
	UICollect.OwnPropCount = UICollect.OwnPropCount - costCount

	UICollect.CostCount = UICollect.CostCount +1
	local money = CollectSys.CostCollectMoney()
	this:ShowPropText(money)

	this:ShowInitInfo()
end


function UICollect:ShowPropText(RecivedMoney)
	local str = UIstring.CollectGet .. RecivedMoney .. UIstring.CollectMoney
	DataUIInstance.PopTip(str)
end

function UICollect:ReleasPanel()
	--UI相关
	UICollect.UICollectGod = nil
	UICollect.Controls = {}

	--Data
	UICollect.SpeedCount = 0
	UICollect.FreeCount = 0	--免费的次数
	UICollect.CostCount = 0	--付费的次数
	UICollect.OwnPropCount = 0	--拥有的道具数量
	GameMain.DelUpdateLua(this.UpdateTime)
end

function UICollect:ReleasData()
	CollectSys.ClearData()
end

function UICollect:InitPanel()
	UICollect.UICollectGod.gameObject:SetActive(false)
end


return UICollect
--endregion