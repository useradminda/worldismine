--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
SystemOpenConfig={}
SystemOpenConfig.SystemOpenData={}

function SystemOpenConfig.InitSome()
	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("SystemOpen")
	while (sqReader:Read()~=false) do
		local id=sqReader:GetInt32(0)
		SystemOpenConfig.SystemOpenData[id]={
			Id=id,	
			Name = sqReader:GetString(1),
			OpenType = sqReader:GetInt32(2),--开启类型
			NeedLvl = sqReader:GetInt32(3),--需要的等级
			LevelMap = sqReader:GetInt32(4),--需要通过的关卡
			Description = sqReader:GetString(5),--弹字提示
			}
	end
end

function SystemOpenConfig.GetDataById(_Id)		--根据VIP等级获取相关数据
	if SystemOpenConfig.SystemOpenData[tonumber(_Id)]~=nil then
       return SystemOpenConfig.SystemOpenData[tonumber(_Id)]
    end
    Debug.LogError("SystemOpen表配置错误:")
    Debug.LogError(_Id)
    return nil
end

function SystemOpenConfig.GetAllDBData()
	return SystemOpenConfig.SystemOpenData
end

return SystemOpenConfig

--endregion
