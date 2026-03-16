--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
VipDataSys = {}
VipDataSys.DataList = {}
VipDataSys.BuyDataList = {}			

function VipDataSys.Init()
	local list = VipDataConfig.GetAllDBData()
	for i=0,#list,1 do
		local data = VipDataSys.CreateItem(i)
		table.insert(VipDataSys.DataList , #VipDataSys.DataList+1 , data)
	end
	VipDataSys.VipBuyInit()
end


function VipDataSys.VipBuyInit()
	local list = VipBuyDataConfig.GetAllVipBuyData()

	for key, value in pairs(list) do
		local data = VipDataSys.CreateVipBuyItem(key)
		table.insert(VipDataSys.BuyDataList , #VipDataSys.BuyDataList+1 , data)
	end
	table.sort(VipDataSys.BuyDataList , VipDataSys.Comp)
end

function VipDataSys.Comp(A ,B)
	if A == nil then
		return false
	end
	if B == nil then
		return false
	end
	if A.Dbid>B.Dbid then
		return false
	end
	if A.Dbid == B.Dbid then
		return false
	end
	if A.Dbid<B.Dbid then
		return true
	end
end

function VipDataSys.CreateVipBuyItem(Id)
	local lua = GameMain.requireLuaFile("VipBuy")
    local vipbaby = lua:new()
    local _VipDBdata = VipBuyDataConfig.GetVipBuyDBConfig(Id)
    vipbaby:Init(_VipDBdata)
    return vipbaby
end

function VipDataSys.CreateItem(lvl)
   local lua = GameMain.requireLuaFile("Vip")
   local vipbaby = lua:new()
   local _VipDBdata = VipDataConfig.GetVipDBConfig(lvl)
	if _VipDBdata~=nil then
		vipbaby:Init(_VipDBdata)
	   return vipbaby 
	end
  return nil
end

function VipDataSys.GetVipDataByLvl(lvl)
	local vipdata = VipDataSys.CreateItem(lvl)
	if vipdata~=nil then
		return vipdata
	end
	return nil
end

function VipDataSys.GetDataList()
	return VipDataSys.DataList
end

function VipDataSys.GetVipBuyDataList()
	return VipDataSys.BuyDataList
end

function VipDataSys.SetBuyData(_Id , _Times)
	local index = VipDataSys.GetIndexById(_Id)
	if index ~= nil then
		VipDataSys.BuyDataList[index]:SetBuyCount(_Times)
	end
	
end

function VipDataSys.GetIndexById(_Id)
	for i=1,#VipDataSys.BuyDataList,1 do
		local data = VipDataSys.BuyDataList[i]
		if data.Dbid == _Id then
			return i
		end
	end
	return nil
end

function VipDataSys.GetVipByLvl(_Lvl)
	for i=1,#VipDataSys.DataList,1  do
		if VipDataSys.DataList[i].Lvl == _Lvl then
			return VipDataSys.DataList[i]
		end
	end
	return nil
end
function VipDataSys.GetVipBuyEndIndexByLvl(StartLvl , EndLvl)				--得到VipSlider每一段的BuyDataList 数据
	local startData = VipDataSys.DataList[StartLvl+1] 
	local endData = VipDataSys.DataList[EndLvl +1]

	for i=1,#VipDataSys.BuyDataList,1 do
		if VipDataSys.BuyDataList[i].VipExp >= endData.VipExp then
			return i-1
		end
	end
	return #VipDataSys.BuyDataList
end

return VipDataSys
--endregion
