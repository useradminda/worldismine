--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
VipSpecialConfig={}
VipSpecialConfig.VipSpecailData={}

function VipSpecialConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Vip_Preferential")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
		VipSpecialConfig.VipSpecailData[id]={
			Id = id,	--vip 等级
			NeedRmb = tonumber(ObjectInfo[1]),--sqReader:GetInt32(1),
			NeedLevel = tonumber(ObjectInfo[2]),-- sqReader:GetInt32(2),
			Reward = tonumber(ObjectInfo[3]),-- sqReader:GetInt32(3),
			VipLevel = tonumber(ObjectInfo[4]),
			NextId = tonumber(ObjectInfo[5]),
			AppStoreId = tostring(ObjectInfo[6]),
			}
	end
end

function VipSpecialConfig.GetDataById(_Id)		
	if VipSpecialConfig.VipSpecailData[tonumber(_Id)]~=nil then
       return VipSpecialConfig.VipSpecailData[tonumber(_Id)]
    end
    Debug.LogError("Vip_Preferential表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function VipSpecialConfig.GetAllData()
	return VipSpecialConfig.VipSpecailData
end

return VipSpecialConfig

--endregion
