--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
ShaChangShopConfig={}
ShaChangShopConfig.ShaChangShopData={}

function ShaChangShopConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("ShaChang_Shop")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
		ShaChangShopConfig.ShaChangShopData[id]={
			Id=id,	--vip 等级
			Type = tonumber(ObjectInfo[1]),-- sqReader:GetInt32(1),	--1装备 2 item
			GoodsId = tonumber(ObjectInfo[2]),--sqReader:GetInt32(2),
			NeedHonor = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),
			}
	end
end

function ShaChangShopConfig.GetDataById(_Id)		--根据VIP等级获取相关数据
	if ShaChangShopConfig.ShaChangShopData[tonumber(_Id)]~=nil then
       return ShaChangShopConfig.ShaChangShopData[tonumber(_Id)]
    end
    Debug.LogError("ShaChang_Shop表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function ShaChangShopConfig.GetAllDBData()
	return ShaChangShopConfig.ShaChangShopData
end

return ShaChangShopConfig

--endregion
