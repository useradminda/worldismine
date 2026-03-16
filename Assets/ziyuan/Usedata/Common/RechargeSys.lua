--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
RechargeSys = {}
RechargeSys.RechargeDataList = {}
RechargeSys.IsFrist = 0		-- 0没有首冲， 1 已经首充值
RechargeSys.IsRecFrist = 0	--是否领取了首冲奖励

RechargeSys.BuyGoods = 
{
	["Recharge"] = false,--购买元宝,金券
	["EveryWeekSpecail"] = false, --每周特惠
	["EveryDaySpecail"] = false, -- 每日充值
	["VipSpecail"] = false,	--VIP特惠
	["Fund"] = false, --基金
}

function RechargeSys.Init()
	local list = RechargeDataConfig.GetAllData()
	for key,value in pairs(list) do
		local data =  RechargeSys.CreateItem(value.Id)
		table.insert(RechargeSys.RechargeDataList , #RechargeSys.RechargeDataList+1,data)
	end
	table.sort(RechargeSys.RechargeDataList ,RechargeSys.Comp)
end

function RechargeSys.CreateItem(Id)
	local lua = GameMain.requireLuaFile("Recharge")
	local rechargebaby = lua:new()
	local rechargeData = RechargeDataConfig.GetDataById (Id)
	rechargebaby:Init(rechargeData)
	return rechargebaby
end

function RechargeSys.Comp(A , B)
	if A ==nil then
		return false
	end
	if B ==nil then
		return false
	end
	if A.Dbid>B.Dbid then
		return false
	end
	if A.Dbid<B.Dbid then
		return true
	end
	if A.Dbid == B.Dbid then
		return false
	end
end

function RechargeSys.ComminfoCallBack(data)
	local list = data["rechargeTimes"]
	if list == nil then
		RechargeSys.IsFrist = 0
		return 
	else
		RechargeSys.IsFrist = 1
		for key,value in pairs(list) do
			local id = tonumber(key)
			local times= tonumber(value)
			RechargeSys.SetItemTimes(id , times)
		end
	end
	RechargeSys.IsRecFrist = tonumber(data["isRecvSCJL"])
	RechargeSys.FristShow()
end

function RechargeSys.FristShow()
	if RechargeSys.IsFrist ==1 and RechargeSys.IsRecFrist == 1 then
		local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
		if UIControlTar ~=nil then
			UIControlTar:ShowFirstRechargeInfo()
		end
	end
end

function RechargeSys.RecFirstRwd()
	local info = nil
	WebEvent.ReceiveFirstRecharge(info , "RechargeSys.RecFirstRwdCallBack",RechargeSys.RecFirstRwdCallBack)
end

function RechargeSys.RecFirstRwdCallBack(data , returnId)
	
end

function RechargeSys.SetItemTimes(id , times)			--设置购买次数
	local index = RechargeSys.GetIndex(id)
	if index~=nil then
		RechargeSys.RechargeDataList[index]:SetTimes(times)
	end
end

function RechargeSys.GetIndex(id)
	for key,value in pairs(RechargeSys.RechargeDataList) do
		if value.Dbid == id then
			return key
		end
	end
	return nil	
end

function RechargeSys.GetList()
	return RechargeSys.RechargeDataList
end

function RechargeSys.InitPanel()					--初始化界面时需要请求信息
--	WebEvent.InitSummonStore(nil , "RechargeSys.InitPanelCallBack" , RechargeSys.InitPanelCallBack)
end

function RechargeSys.InitPanelCallBack(data , returnId)
	local UIRechargeTar = MainGameUI.FindPanelTarget("UIRecharge")
	if UIRechargeTar ~=nil then
		UIRechargeTar:ShowInitInfo()
	end
end

function RechargeSys.BuyDiamond(Id)				--购买元宝
	RechargeSys.BuyGoods.Recharge = true
--	local info = Id
--	WebEvent.BuyDiamond(info , "RechargeSys.BuyDiamondCallBack" , RechargeSys.BuyDiamondCallBack)
	RechargeSys.GenerateOrder(Id)
end

function RechargeSys.BuyDiamondCallBack()
	local uiVipTar = MainGameUI.FindPanelTarget("UIVip")
	
	if uiVipTar~=nil then
		local vipgod = uiVipTar.UIVipGod
		if vipgod ~= nil then
			uiVipTar:ShowInfo()
		end
		
	end
	local uiRechargeTar = MainGameUI.FindPanelTarget("UIRecharge")
	
	if uiRechargeTar ~= nil then
		local UIRechargeGod = uiRechargeTar.UIRechargeGod
		if UIRechargeGod ~= nil then
			uiRechargeTar:ShowBuyAfter()
		end
		
	end
	local UIControlTar = MainGameUI.FindPanelTarget("UIControl")
	if UIControlTar ~= nil then
		UIControlTar:ShowVipSpecailInfo()
	end
end

RechargeSys.AppStoreId = ""

function RechargeSys.GenerateOrder(_AppStoreID)
	RechargeSys.AppStoreId = _AppStoreID
	WebEvent.GenerateOrder(RechargeSys.AppStoreId  , "RechargeSys.GenerateOrderCallBack" , RechargeSys.GenerateOrderCallBack)
end

function RechargeSys.GenerateOrderCallBack(data , returnId)
	local order = data
	GameMain.ToSendBuyInfo(RechargeSys.AppStoreId , order)
	RechargeSys.AppStoreId  = ""
end

function RechargeSys.ClearOrdersCallBack(_Data)
	if _Data ~= nil then
		for key,value in pairs(_Data) do
			local isDelete = tonumber(value["isDelete"])
			if isDelete ~= nil then
				if isDelete == 1 then
					local isSuccess = tonumber(value["isSuccess"])
					local num = tonumber(value["d"])
					local success = false
					if isSuccess~= nil then
						success = true
					end
					GameMain.ClearBuyRecord(success , num)
				end
			end
		end
	end
end

return RechargeSys
--endregion
