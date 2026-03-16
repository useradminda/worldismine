--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
GiftDataConfig={}
GiftDataConfig.GiftData={}

function GiftDataConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Gift")
	while (sqReader:Read()~=false) do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0])--sqReader:GetInt32(0)
		GiftDataConfig.GiftData[id]={
			Id = id,				--礼包ID	
			Name = tostring(ObjectInfo[1]),--sqReader:GetString(1),--礼包名字
			Description = tostring(ObjectInfo[2]),--sqReader:GetString(2),			--礼包描述
			Icon = tostring(ObjectInfo[3]),--sqReader:GetString(3),					--Icon
			Quality = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),				--品质
			Type = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),				--类型
			Target = tostring(ObjectInfo[6]),--sqReader:GetString(6),				--获得的IDlist
			Layer_Count = tonumber(ObjectInfo[7]),--sqReader:GetInt32(7),			--叠加上限
			Is_Sell= tonumber(ObjectInfo[8]),--sqReader:GetInt32(8),--能否被出售 int 1-可以，0-不行
			Price= tonumber(ObjectInfo[9]),--sqReader:GetInt32(9),
			Is_Visible= tonumber(ObjectInfo[10]),--sqReader:GetInt32(10),--背包是否可见 1可以0不可以
			Using= tonumber(ObjectInfo[11]),--sqReader:GetInt32(11),
			IsUse = tonumber(ObjectInfo[12]),--sqReader:GetInt32(12),
			UseLvl = tonumber(ObjectInfo[13]),--sqReader:GetInt32(12),
			}

        local _Icons = GameMain.StringSplit(GiftDataConfig.GiftData[id].Icon , ",")
        GiftDataConfig.GiftData[id].AtlasName = _Icons[1]
        GiftDataConfig.GiftData[id].SpriteName = _Icons[2]
	end
end

function GiftDataConfig.GetGiftDataBuyId(_Id)		--根据VIP等级获取相关数据
	if GiftDataConfig.GiftData[tonumber(_Id)]~=nil then
       return GiftDataConfig.GiftData[tonumber(_Id)]
    end
    Debug.LogError("Gift表配置错误:")
    Debug.LogError(_Id)
    return nil
end


return GiftDataConfig

--endregion
