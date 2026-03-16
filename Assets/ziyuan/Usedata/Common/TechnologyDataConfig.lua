--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
TechnologyDataConfig={}
TechnologyDataConfig.TechnologyData={}

function TechnologyDataConfig.IniSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Technology")
	while (sqReader:Read()~=false) do
--		local id=sqReader:GetInt32(0)
		local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))
		local id= tonumber(ObjectInfo[0]) --sqReader:GetInt32(0)
		TechnologyDataConfig.TechnologyData[id]=
		{
			Id=id,
			Name=tostring(ObjectInfo[1]),--sqReader:GetString(1),
			Description=tostring(ObjectInfo[2]),--sqReader:GetString(2),
			Type=tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),	--1是武将 ，2是小兵
			Class=tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),	--1 PVE武将出战人数 2 pvp武将出站人数 3 国战移动速度 4 武将训练位置 5 士兵进阶
			Next_Id=tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),--研究后的下一个Id
			Show_Lvl=tonumber(ObjectInfo[6]),--sqReader:GetInt32(6),--显示的等级
			Learn_Lvl=tonumber(ObjectInfo[7]),--sqReader:GetInt32(7),--学习的等级
			Need_Money=tonumber(ObjectInfo[8]),--sqReader:GetInt32(8),--学习需要的money
			Times=tonumber(ObjectInfo[9]),--sqReader:GetInt32(9),--研究需要的次数
			Need_Time=tonumber(ObjectInfo[10]),--sqReader:GetFloat(10), --研究需要的时间
			Result = tostring(ObjectInfo[11]),--sqReader:GetString(11),
			Icon = tostring(ObjectInfo[12]),--sqReader:GetString(12),
			PreId = tonumber(ObjectInfo[13]),--sqReader:GetInt32(13),
		}
		local icons = GameMain.StringSplit(TechnologyDataConfig.TechnologyData[id].Icon , ",")
		TechnologyDataConfig.TechnologyData[id].AtlasName = icons[1]
		TechnologyDataConfig.TechnologyData[id].SpriteName = icons[2]
	end
end
function TechnologyDataConfig.GetDBConfig(id)
	if TechnologyDataConfig.TechnologyData[tonumber(id)]~=nil then
		return TechnologyDataConfig.TechnologyData[tonumber(id)]
	end

	Debug.LogError("Technology表配置错误ID:")
    Debug.LogError(id)
    return nil
end

function TechnologyDataConfig.GetAllData()
	return TechnologyDataConfig.TechnologyData
end
return TechnologyDataConfig
--endregion