MainMissionConfig = {}
MainMissionConfig.MainMissionConfig = {}
function MainMissionConfig.IniSome()

	local theDB = configDB.Ins.theDB;
	local sqReader = theDB:ReadFullTable("Task")
	while (sqReader:Read() ~= false) 
	do
        local ObjectInfo = GameMain.DoDbInfo(theDB:GetText(sqReader))

        local _Id = tonumber(ObjectInfo[0])-- sqReader:GetInt32(0)
        MainMissionConfig.MainMissionConfig[_Id] = {        
            Id = tonumber(ObjectInfo[0]),--sqReader:GetInt32(0),           --lvl  
            Name = tostring(ObjectInfo[1]),--sqReader:GetString(1),           --lvl       
            Descrip = tostring(ObjectInfo[2]),--sqReader:GetString(2),          --exp
            Type = tonumber(ObjectInfo[3]),--sqReader:GetInt32(3),                --任务类型 1 主线 2 支线
            Class = tonumber(ObjectInfo[4]),--sqReader:GetInt32(4),           --种类 
            Require = tonumber(ObjectInfo[5]),--sqReader:GetInt32(5),         --需求
            Next_Id = tonumber(ObjectInfo[6]),--sqReader:GetInt32(6),         --下一条任务的ID
            Reward = tostring(ObjectInfo[7]),--sqReader:GetString(7),
		}     
    end
end

function MainMissionConfig.GetMainById(_Id)
    
    if MainMissionConfig.MainMissionConfig[tonumber(_Id)]~=nil then
       return MainMissionConfig.MainMissionConfig[tonumber(_Id)]
    end
    Debug.LogError("数据库Task等级配置错误_Id:")
    Debug.LogError(_Id)
    return nil
end

function MainMissionConfig.GetMainMissionConfig()
    
    return MainMissionConfig.MainMissionConfig

end

return MainMissionConfig