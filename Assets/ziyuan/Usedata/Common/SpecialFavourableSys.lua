--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
SpecialFavourableSys = {}
SpecialFavourableSys.EveryDayList = {}
SpecialFavourableSys.EveryWeekList = {}

SpecialFavourableSys.WeekExpireTime = 0	--每周特惠过期时间戳
SpecialFavourableSys.DayExpireTime = 0	--每日一充过期时间戳

function SpecialFavourableSys.GetWeekDBData()
	local list = EveryWeekPreferentialConfig.GetAllDBData()
	local returnList = {}
	for key,value in pairs(list) do
		table.insert(returnList , #returnList + 1, value)
	end
	table.sort(returnList , SpecialFavourableSys.Comp)
	return returnList
end

function SpecialFavourableSys.GetDayDBData()
	local list = EveryDayPreferentialConfig.GetAllDBData()
	local returnList = {}
	for key,value in pairs(list) do
		table.insert(returnList , #returnList + 1, value)
	end
	table.sort(returnList , SpecialFavourableSys.Comp)
	return returnList
end

function SpecialFavourableSys.Comp(A , B)
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	if A.Id > B.Id then
		return false
	end
	if A.Id < B.Id then
		return true
	end
	if A.Id == B.Id then
		return false
	end
end

function SpecialFavourableSys.BuyEveryWeekById(_Id)
	RechargeSys.BuyGoods.EveryWeekSpecail = true
	RechargeSys.GenerateOrder(_Id)
--	local info = _Id
--	WebEvent.BuyPreferentialEveryWeek(info , "SpecialFavourableSys.BuyEveryWeekByIdCallBack" , SpecialFavourableSys.BuyEveryWeekByIdCallBack)
end

function SpecialFavourableSys.BuyEveryWeekByIdCallBack()
	local UISpecialFavourableTar = MainGameUI.FindPanelTarget("UISpecialFavourable")
	
	if UISpecialFavourableTar ~= nil then
		local god = UISpecialFavourableTar.UISpecialFavourableGob
		if god ~= nil then
			UISpecialFavourableTar:ShowBuyWeedAfter()
		end
		
	end
end

function SpecialFavourableSys.BuyEveryDayById(_Id)
	RechargeSys.BuyGoods.EveryDaySpecail = true
	RechargeSys.GenerateOrder(_Id)
--	local info = _Id
--	WebEvent.BuyRechargeEveryDay(info ,"SpecialFavourableSys.BuyEveryDayByIdCallBack" , SpecialFavourableSys.BuyEveryDayByIdCallBack)
end

function SpecialFavourableSys.BuyEveryDayByIdCallBack(data)
	local UISpecialFavourableTar = MainGameUI.FindPanelTarget("UISpecialFavourable")
	
	if UISpecialFavourableTar ~= nil  then
		local god = UISpecialFavourableTar.UISpecialFavourableGob
		if god ~= nil then
			UISpecialFavourableTar:ShowBuyEveryDayRechargeAfter(tonumber(data))
		end
		
	end
end

function SpecialFavourableSys.CommonInfoCallBack(_Data)
	SpecialFavourableSys.EveryDayList = {}
	SpecialFavourableSys.EveryWeekList = {}
	if _Data ~= nil then
		SpecialFavourableSys.EveryDayList = _Data["Recharge_EveryDay"]
		SpecialFavourableSys.EveryWeekList = _Data["Preferential_EveryWeek"]
	
		local WeekExpireTime = tonumber(_Data["Preferential_EveryWeek_expire"])
		if WeekExpireTime ~= nil then
			SpecialFavourableSys.WeekExpireTime = WeekExpireTime
		end
		local DayExpireTime = tonumber(_Data["Recharge_EveryDay_expire"])
		if DayExpireTime ~=nil then
			SpecialFavourableSys.DayExpireTime = DayExpireTime
		end
	end
end


function SpecialFavourableSys.IsBuyDayRecharge()		--是否已经购买了每日礼包
	local curTime = ClinetInfomation.WorldTime
	if curTime < SpecialFavourableSys.DayExpireTime then
		local len = #SpecialFavourableSys.EveryDayList
		if len > 0 then
			return true
		else
			return false
		end
	end
	if curTime >= SpecialFavourableSys.DayExpireTime then
		SpecialFavourableSys.EveryDayList = {}
		return false
	end
end

function SpecialFavourableSys.IsWeekExpire()				--是否过期
	local curTime = ClinetInfomation.WorldTime
	if curTime >= SpecialFavourableSys.DayExpireTime then
		SpecialFavourableSys.EveryDayList = {}
		return true
	end
	return false
end

return SpecialFavourableSys
--endregion
