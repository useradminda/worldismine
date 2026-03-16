--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
DebrisConfig={}
DebrisConfig.DebrisData={}

function DebrisConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Debris")
	while (sqReader:Read()~=false) do
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		DebrisConfig.DebrisData[id]={
			Id = id,				--碎片ID	
			Name = tostring(ObjectInfo[1]),--sqReader:GetString(1),--名字
			Description = tostring(ObjectInfo[2]),--sqReader:GetString(2),			--描述
			Icon = tostring(ObjectInfo[3]),--sqReader:GetString(3),					--Icon
			Quality = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),				--品质
			Type = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),				--类型
			Target = tonumber(ObjectInfo[6]),--sqReader:GetInt32(6),				--获得的ID
			Layer_Count = tonumber(ObjectInfo[7]),--sqReader:GetInt32(7),			--叠加上限
			Is_Sell= tonumber(ObjectInfo[8]),--sqReader:GetInt32(8),--能否被出售 int 1-可以，0-不行
			Price= tonumber(ObjectInfo[9]),--sqReader:GetInt32(9),
			Is_Visible=tonumber(ObjectInfo[10]),--sqReader:GetInt32(10),--背包是否可见 1可以0不可以
			Using=tonumber(ObjectInfo[11]),--sqReader:GetInt32(11),
			IsUse = tonumber(ObjectInfo[12]),--sqReader:GetInt32(12),
			NeedCount = tonumber(ObjectInfo[13]),--sqReader:GetInt32(13),
			}
		local iconList = GameMain.StringSplit( DebrisConfig.DebrisData[id].Icon , ",")
		DebrisConfig.DebrisData[id].AtlasName = iconList[1]
		DebrisConfig.DebrisData[id].SpriteName = iconList[2]
	end
end

function DebrisConfig.GetDebrisById(_Id)		--根据VIP等级获取相关数据
	if DebrisConfig.DebrisData[tonumber(_Id)]~=nil then
       return DebrisConfig.DebrisData[tonumber(_Id)]
    end
    Debug.LogError("Debris表配置错误:")
    Debug.LogError(_Id)
    return nil
end


return DebrisConfig

--endregion
