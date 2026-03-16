--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
HonerShopSys = {}

function HonerShopSys.GetAllShaChangData()
	local list = ShaChangShopConfig.GetAllDBData()
	local returnList = {}
	for key,value in pairs(list) do
		local data = HonerShopSys.CreateItem(value.Id ,1)
		table.insert(returnList , #returnList+1 , data)
	end
	return returnList
end

function HonerShopSys.GetAllDouJiangTaiData()
	local list = DouJiangTaiShopConfig.GetAllDBData()
	local returnList = {}
	for key,value in pairs(list) do
		local data = HonerShopSys.CreateItem(value.Id ,2)
		table.insert(returnList , #returnList+1 , data)
	end
	return returnList
end

function HonerShopSys.CreateItem(_Dbid , _Type)			--_Type 1 沙场 2 斗将台
	local lua = GameMain.requireLuaFile("HonerShopItem")
	local rolebaby = lua:new()
	local data = nil
	if _Type == 1 then
		data = ShaChangShopConfig.GetDataById(_Dbid)
	end
	if _Type == 2 then
		data = DouJiangTaiShopConfig.GetDataById(_Dbid)
	end
	rolebaby:Init(data)
	return rolebaby
end

function HonerShopSys.BuyShop(_Data , _Type)		--_Type 1 沙场 2 斗将台 
	local info = _Data.Dbid .. "," .. _Data.BuyCount
	if _Type == 1 then
		WebEvent.BuyShaChangShop(info , "HonerShopSys.BuyShopCallBack" , HonerShopSys.BuyShopCallBack)
	end
	if _Type == 2 then
		WebEvent.BuyDoujiangtaiShop(info , "HonerShopSys.BuyShopCallBack" , HonerShopSys.BuyShopCallBack)
	end
end

function HonerShopSys.BuyShopCallBack(data , returnId)
	local UIHonorShopTar = MainGameUI.FindPanelTarget("UIHonorShop")
	if UIHonorShopTar ~=nil then
		UIHonorShopTar:ShowHonorInfo()
	end
    if returnId ==0 then
       DataUIInstance.PopTip("M1")
    end
end

return HonerShopSys
--endregion
