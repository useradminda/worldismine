--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
EquipSummonSys = {}
EquipSummonSys.TempSummonList = {}					--抽到的临时装备

EquipSummonSys.SummonFreeTime = {}					--抽卡的免费时间

function EquipSummonSys.SummonStoreInit()			--装备抽卡初始化

end

function EquipSummonSys.SummonCard(_Type , _Free)	--抽卡 1 普通 2中级 3 高级 _Free 1 免费  0收费
	EquipSummonSys.ClearSummonStore()
	local info = tostring(_Type) .. "," .. tostring(_Free)
	WebEvent.RefrashEquipStore(info , "EquipSummonSys.SummonCardCallBack" , EquipSummonSys.SummonCardCallBack)
end

function EquipSummonSys.SummonCardCallBack(data , returnId)
	local uiEquip = MainGameUI.FindPanelTarget("UIEquip")
		if uiEquip ~=nil then
			uiEquip:ShowSmeltCallBack()
		end
end

function EquipSummonSys.ClearSummonStore()			--每次招募都需要先清一下以前招募到的临时装备
	EquipSummonSys.TempSummonList = {}	
end

function EquipSummonSys.BuyEquip(_EquipData)
	local info = _EquipData.Dbid
	WebEvent.BuyStoreEquip(info , "EquipSummonSys.BuyEquipCallBack" ,EquipSummonSys.BuyEquipCallBack)
end

function EquipSummonSys.BuyEquipCallBack(data , returnId)
	local uiEquip = MainGameUI.FindPanelTarget("UIEquip")
	if uiEquip ~=nil then
		uiEquip:ShowBuyCallBack()
	end 
end

function EquipSummonSys.GetTempEquipList()			--得到招募的临时列表
	return EquipSummonSys.TempSummonList
end

function EquipSummonSys.AddTempEquip(id , isBuy)
	local EquipItem =  EquipDataSys.CreateTempEquip(id , isBuy)
	table.insert(EquipSummonSys.TempSummonList , #EquipSummonSys.TempSummonList+1 , EquipItem)
end


function EquipSummonSys.IsFree(_Type)				--是否是免费的
	local curTime = ClinetInfomation.WorldTime
	local startTime = EquipSummonSys.SummonFreeTime[_Type]
	if startTime == nil then
		return true
	end
	local del = startTime - curTime
	if del <= 0 then
		return true
	end

	if del>0 then
		TimeControl.LoginTime(del, "FreeEquipSummonTime" .. _Type)
		return false
	end
end

function EquipSummonSys.ComminfoCallBack(data)
	local lvUpCD = data["qltUpCD"]
	local storeData =  data["goods"]
	local freeTime = data["freeTime"]
	local Cd = tonumber(data["heroAddExpCD"])
	if Cd~=nil then
		RoleDataSys.SetAddExpTime(Cd)
	end
	local rate = data["qltUpPer"]
	local overTime = data["qltUpPerExpire"]
	if lvUpCD~=nil then
		EquipSys.StrengthCD = lvUpCD
	end
	if rate~=nil then
		EquipSys.StrengthRate = rate
	end
	if overTime~=nil then
		EquipSys.StrengthRateOverTime = overTime
	end
	
	if storeData ~= nil then
	
		for key,value in pairs(storeData) do
		
			local id = tonumber(value["id"])
			local isBuy = tonumber(value["soldout"])
			EquipSummonSys.AddTempEquip(id , isBuy)
			
		end
		
	end

	if freeTime~=nil then
		for key,value in pairs(freeTime) do
			local _type = tonumber(key)
			local time = tonumber(value)
			EquipSummonSys.SummonFreeTime[_type] = time
		end
	end

end

return EquipSummonSys
--endregion