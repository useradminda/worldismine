--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
VipBuyDataConfig={}
VipBuyDataConfig.VipBuyData={}

function VipBuyDataConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Vip_Buy")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
		VipBuyDataConfig.VipBuyData[id]={
			Id = id,	--vip 等级
			Exp = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),
			Price = tonumber(ObjectInfo[2]),-- sqReader:GetInt32(2),
			Times = tonumber(ObjectInfo[3]),-- sqReader:GetInt32(3),
			Reward = tonumber(ObjectInfo[4]),-- sqReader:GetString(4),
			Description = tostring(ObjectInfo[7]),-- sqReader:GetString(5),
			
			Show_Name = tonumber(ObjectInfo[5]),-- sqReader:GetInt32(6),
			UseId = tonumber(ObjectInfo[6]),
			ShowOrder = tonumber(ObjectInfo[8]),
			AppStore_Id = tostring(ObjectInfo[9]),
			}
	end
end

function VipBuyDataConfig.GetVipBuyDBConfig(_Id)		--根据VIP等级获取相关数据
	if VipBuyDataConfig.VipBuyData[tonumber(_Id)]~=nil then
       return VipBuyDataConfig.VipBuyData[tonumber(_Id)]
    end
    Debug.LogError("Sign表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function VipBuyDataConfig.GetAllVipBuyData()
	return VipBuyDataConfig.VipBuyData
end

return VipBuyDataConfig

--endregion
