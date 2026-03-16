--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
DouJiangTaiShopConfig={}
DouJiangTaiShopConfig.DouJiangTaiShopData={}

function DouJiangTaiShopConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("DouJiangTai_Shop")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
		DouJiangTaiShopConfig.DouJiangTaiShopData[id]={
			Id=id,	--vip 等级
			Type = tonumber(ObjectInfo[1]),-- sqReader:GetInt32(1),	--1装备 2 item
			GoodsId = tonumber(ObjectInfo[2]),-- sqReader:GetInt32(2),
			NeedHonor = tonumber(ObjectInfo[3]),-- sqReader:GetInt32(3),
			}
	end
end

function DouJiangTaiShopConfig.GetDataById(_Id)		--根据VIP等级获取相关数据
	if DouJiangTaiShopConfig.DouJiangTaiShopData[tonumber(_Id)]~=nil then
       return DouJiangTaiShopConfig.DouJiangTaiShopData[tonumber(_Id)]
    end
    Debug.LogError("DouJiangTai_Shop表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function DouJiangTaiShopConfig.GetAllDBData()
	return DouJiangTaiShopConfig.DouJiangTaiShopData
end

return DouJiangTaiShopConfig

--endregion
